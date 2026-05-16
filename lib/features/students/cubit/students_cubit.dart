import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/home/cubit/trip_state.dart';
import 'package:parent_app/features/home/data/models/trip_socket_event.dart';
import 'package:parent_app/features/home/data/repositories/trip_repository.dart';
import 'package:parent_app/features/home/data/services/trip_socket_client.dart';
import 'package:parent_app/features/students/cubit/students_state.dart';
import 'package:parent_app/features/students/data/repositories/students_repository.dart';

class StudentsCubit extends Cubit<StudentsState> {
  final StudentsRepository _studentsRepository;
  final TripRepository _tripRepository;
  final TripSocketClient _tripSocketClient;
  StreamSubscription<TripSocketEvent>? _tripSocketSubscription;
  int? _connectedTripId;

  StudentsCubit({
    StudentsRepository? studentsRepository,
    TripRepository? tripRepository,
    TripSocketClient? tripSocketClient,
  }) : _studentsRepository = studentsRepository ?? StudentsRepository(),
       _tripRepository = tripRepository ?? TripRepository(),
       _tripSocketClient = tripSocketClient ?? TripSocketClient(),
       super(const StudentsState());

  Future<void> loadStudents({String? direction}) async {
    final targetDirection = direction ?? state.direction;
    emit(state.copyWith(loading: true, direction: targetDirection, clearError: true));
    try {
      final students = await _studentsRepository.fetchRouteStudents(direction: targetDirection);
      await _syncTripRealtime();
      emit(state.copyWith(loading: false, students: students, clearError: true));
    } catch (e) {
      emit(state.copyWith(loading: false, error: 'Failed to load students.'));
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
      if (tripState is! ActiveTripState || tripState.tripId == null) {
        await _disconnectTripRealtime();
        return;
      }
      final tripId = tripState.tripId!;
      if (_connectedTripId == tripId) return;
      await _disconnectTripRealtime();
      _tripSocketSubscription = _tripSocketClient.events.listen(_onTripSocketEvent);
      await _tripSocketClient.connect(tripId: tripId);
      _connectedTripId = tripId;
    } catch (_) {
      await _disconnectTripRealtime();
    }
  }

  void _onTripSocketEvent(TripSocketEvent event) {
    if (event is GuardianMessageSocketEvent) {
      final studentId = event.studentId;
      if (studentId == null || studentId.isEmpty) return;
      final latest = Map<String, String>.from(state.latestMessages);
      final guardian = (event.guardianName ?? '').trim();
      final content = event.content.trim();
      latest[studentId] = guardian.isNotEmpty ? '$guardian: $content' : content;
      emit(state.copyWith(latestMessages: latest));
      return;
    }
    if (event is StudentStatusSocketEvent) {
      final studentId = event.studentId;
      if (studentId == null || studentId.isEmpty) return;
      final status = event.status.trim();
      if (status.isEmpty) return;
      final updated = Map<String, String>.from(state.statuses);
      updated[studentId] = status;
      emit(state.copyWith(statuses: updated));
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
    await _disconnectTripRealtime();
    await _tripSocketClient.dispose();
    return super.close();
  }
}
