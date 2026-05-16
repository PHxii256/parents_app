import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/core/config/api_config.dart';
import 'package:parent_app/features/home/cubit/trip_state.dart';
import 'package:parent_app/features/home/data/models/trip_socket_event.dart';
import 'package:parent_app/features/home/data/repositories/trip_repository.dart';
import 'package:parent_app/features/home/data/services/trip_socket_client.dart';
import 'package:parent_app/features/students/cubit/students_state.dart';
import 'package:parent_app/features/students/data/models/route_student_item.dart';
import 'package:parent_app/features/students/data/repositories/students_repository.dart';

class StudentsCubit extends Cubit<StudentsState> {
  final StudentsRepository _studentsRepository;
  final TripRepository _tripRepository;
  final TripSocketClient _tripSocketClient;
  StreamSubscription<TripSocketEvent>? _tripSocketSubscription;
  int? _connectedTripId;
  Timer? _assistantPollTimer;

  static const _assistantPollInterval = Duration(seconds: 25);

  StudentsCubit({
    StudentsRepository? studentsRepository,
    TripRepository? tripRepository,
    TripSocketClient? tripSocketClient,
  }) : _studentsRepository = studentsRepository ?? StudentsRepository(),
       _tripRepository = tripRepository ?? TripRepository(),
       _tripSocketClient = tripSocketClient ?? TripSocketClient(),
       super(const StudentsState());

  void _dbg(String message) {
    if (kDebugMode) {
      debugPrint('[StudentsCubit] $message');
    }
  }

  Map<String, String> _mergeLatestFromRoster(
    List<RouteStudentItem> roster,
    Map<String, String> current,
  ) {
    final merged = Map<String, String>.from(current);
    for (final item in roster) {
      if (item.isSchool) continue;
      final sd = item.studentData;
      final msg = sd?.latestMessage?.trim();
      if (msg == null || msg.isEmpty) continue;
      merged[item.id] = msg;
      if (sd != null && sd.id != 0) {
        merged[sd.id.toString()] = msg;
      }
    }
    return merged;
  }

  /// Maps socket/API numeric ids onto roster keys (`RouteStudentItem.id`, `StudentData.id`).
  Set<String> _keysForStudentEvent(String coreKey) {
    final keys = <String>{coreKey};
    for (final item in state.students) {
      if (item.isSchool) continue;
      final sd = item.studentData;
      if (sd == null) continue;
      final idStr = sd.id != 0 ? sd.id.toString() : null;
      final rosterMatches = item.id == coreKey || (idStr != null && idStr == coreKey);
      if (rosterMatches) {
        keys.add(item.id);
        if (idStr != null) keys.add(idStr);
      }
    }
    return keys;
  }

  Future<void> loadStudents({String? direction}) async {
    final targetDirection = direction ?? state.direction;
    emit(state.copyWith(loading: true, direction: targetDirection, clearError: true));
    try {
      final students = await _studentsRepository.fetchRouteStudents(direction: targetDirection);
      await _syncTripRealtime();
      final latest = _mergeLatestFromRoster(students, state.latestMessages);
      emit(
        state.copyWith(
          loading: false,
          students: students,
          latestMessages: latest,
          clearError: true,
        ),
      );
      _startAssistantPollingIfNeeded();
    } catch (e) {
      _dbg('loadStudents failed: $e');
      emit(state.copyWith(loading: false, error: 'Failed to load students.'));
    }
  }

  void _startAssistantPollingIfNeeded() {
    _assistantPollTimer?.cancel();
    if (!ApiConfig.useRealApi) return;
    _assistantPollTimer = Timer.periodic(_assistantPollInterval, (_) {
      if (isClosed) return;
      unawaited(_pollStudentsQuiet());
    });
    _dbg('started roster poll every ${_assistantPollInterval.inSeconds}s');
  }

  Future<void> _pollStudentsQuiet() async {
    try {
      final students = await _studentsRepository.fetchRouteStudents(direction: state.direction);
      await _syncTripRealtime();
      if (isClosed) return;
      final latest = _mergeLatestFromRoster(students, state.latestMessages);
      emit(state.copyWith(students: students, latestMessages: latest));
      _dbg('quiet poll ok students=${students.length} latestKeys=${latest.length}');
    } catch (e) {
      _dbg('quiet poll failed: $e');
    }
  }

  Future<void> markBoarded(String studentId) async {
    final ok = await _studentsRepository.markBoarded(studentId);
    if (!ok) return;
    final updated = Map<String, String>.from(state.statuses);
    updated[studentId] = 'boarded';
    emit(state.copyWith(statuses: updated));
  }

  Future<void> markDroppedOff(String studentId) async {
    final ok = await _studentsRepository.markDroppedOff(studentId);
    if (!ok) return;
    final updated = Map<String, String>.from(state.statuses);
    updated[studentId] = 'dropped-off';
    emit(state.copyWith(statuses: updated));
  }

  void setStatusLocal(String studentId, String? status) {
    final updated = Map<String, String>.from(state.statuses);
    if (status == null || status.isEmpty) {
      updated.remove(studentId);
    } else {
      updated[studentId] = status;
    }
    emit(state.copyWith(statuses: updated));
  }

  Future<void> _syncTripRealtime() async {
    try {
      final tripState = await _tripRepository.fetchTripState();
      if (tripState is! ActiveTripState) {
        _dbg('trip WS skipped: not ActiveTripState (${tripState.runtimeType})');
        await _disconnectTripRealtime();
        return;
      }
      final tripId = tripState.tripId;
      if (tripId == null) {
        _dbg(
          'trip WS skipped: tripId is null after GET /trips/current '
          '(backend should send tripId, trip_id, id, or routeId if channels match)',
        );
        await _disconnectTripRealtime();
        return;
      }

      final rosterPreview = state.students
          .where((e) => !e.isSchool)
          .map((e) => '${e.id}(studentData.id=${e.studentData?.id ?? "?"})')
          .take(12)
          .join(', ');
      _dbg(
        'trip WS check tripId=$tripId cubitConnected=$_connectedTripId '
        'socketOpen=${_tripSocketClient.isConnected} rosterSample=[$rosterPreview]',
      );

      if (_connectedTripId == tripId && _tripSocketClient.isConnected) {
        _dbg('trip WS already subscribed tripId=$tripId');
        return;
      }

      await _disconnectTripRealtime();
      _tripSocketSubscription = _tripSocketClient.events.listen(_onTripSocketEvent);
      await _tripSocketClient.connect(tripId: tripId);

      if (_tripSocketClient.isConnected) {
        _connectedTripId = tripId;
        _dbg('trip WS subscribed tripId=$tripId');
      } else {
        _connectedTripId = null;
        _dbg('trip WS connect ended without socket tripId=$tripId');
        await _tripSocketSubscription?.cancel();
        _tripSocketSubscription = null;
      }
    } catch (e, _) {
      _dbg('trip WS sync error: $e');
      await _disconnectTripRealtime();
    }
  }

  void _onTripSocketEvent(TripSocketEvent event) {
    switch (event) {
      case GuardianMessageSocketEvent():
        final studentId = event.studentId;
        if (studentId == null || studentId.isEmpty) {
          _dbg('guardian_message ignored: missing studentId');
          return;
        }
        final latest = Map<String, String>.from(state.latestMessages);
        final guardian = (event.guardianName ?? '').trim();
        final content = event.content.trim();
        final line = guardian.isNotEmpty ? '$guardian: $content' : content;
        final keys = _keysForStudentEvent(studentId);
        _dbg(
          'guardian_message rawStudentId=$studentId expandedKeys=${keys.join('|')} '
          'preview=${line.length > 80 ? '${line.substring(0, 80)}…' : line}',
        );
        for (final k in keys) {
          latest[k] = line;
        }
        emit(state.copyWith(latestMessages: latest));

      case StudentStatusSocketEvent():
        final studentId = event.studentId;
        if (studentId == null || studentId.isEmpty) return;
        final status = event.status.trim();
        if (status.isEmpty) return;
        final updated = Map<String, String>.from(state.statuses);
        final keys = _keysForStudentEvent(studentId);
        _dbg('student_status rawStudentId=$studentId keys=${keys.join('|')} status=$status');
        for (final k in keys) {
          updated[k] = status;
        }
        emit(state.copyWith(statuses: updated));

      case LocationUpdateSocketEvent():
        _dbg('location_update latLng=${event.currentCoords.latitude},${event.currentCoords.longitude}');
    }
  }

  Future<void> _disconnectTripRealtime() async {
    await _tripSocketSubscription?.cancel();
    _tripSocketSubscription = null;
    _connectedTripId = null;
    await _tripSocketClient.disconnect();
  }

  @override
  Future<void> close() async {
    _assistantPollTimer?.cancel();
    _assistantPollTimer = null;
    await _disconnectTripRealtime();
    await _tripSocketClient.dispose();
    return super.close();
  }
}
