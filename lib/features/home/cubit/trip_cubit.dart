import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/home/cubit/trip_state.dart';
import 'package:parent_app/features/home/data/models/trip_socket_event.dart';
import 'package:parent_app/features/home/data/repositories/trip_repository.dart';
import 'package:parent_app/features/home/data/services/trip_socket_client.dart';
import 'package:parent_app/core/config/api_config.dart';

class TripCubit extends Cubit<TripState> {
  final TripRepository _tripRepository;
  Timer? _pollingTimer;
  final TripSocketClient _tripSocketClient;
  StreamSubscription<TripSocketEvent>? _tripSocketSubscription;

  TripCubit({TripRepository? tripRepository, TripSocketClient? tripSocketClient})
    : _tripRepository = tripRepository ?? TripRepository(),
      _tripSocketClient = tripSocketClient ?? TripSocketClient(),
      super(ActiveTripState.exampleActiveState) {
    syncTripState();
  }

  int _currentCycleIndex = 0;

  // for testing
  void cycleState() {
    final states = [ActiveTripState.exampleActiveState, OfflineTripState(), InactiveTripState()];
    emit(states[++_currentCycleIndex % 3]);
  }

  Future<void> syncTripState() async {
    try {
      final tripState = await _tripRepository.fetchTripState();
      emit(tripState);
      if (tripState is ActiveTripState) {
        _startPolling();
        await _startRealtime(tripState);
      } else {
        _stopPolling();
        await _stopRealtime();
      }
    } catch (_) {
      await _stopRealtime();
      emit(OfflineTripState());
    }
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 45), (_) async {
      await syncTripState();
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> _startRealtime(ActiveTripState state) async {
    if (!ApiConfig.useRealApi) return;
    final tripId = state.tripId;
    if (tripId == null) return;
    _tripSocketSubscription ??= _tripSocketClient.events.listen(_onSocketEvent);
    await _tripSocketClient.connect(tripId: tripId);
  }

  void _onSocketEvent(TripSocketEvent event) {
    final current = state;
    if (event is LocationUpdateSocketEvent && current is ActiveTripState) {
      emit(current.copyWith(busCoords: event.currentCoords));
      return;
    }

    if (kDebugMode) {
      if (event is GuardianMessageSocketEvent) {
        debugPrint(
          '[TripSocket] guardian_message student=${event.studentId} guardian=${event.guardianName}',
        );
      } else if (event is StudentStatusSocketEvent) {
        debugPrint('[TripSocket] student_status student=${event.studentId} status=${event.status}');
      }
    }
  }

  Future<void> _stopRealtime() async {
    await _tripSocketSubscription?.cancel();
    _tripSocketSubscription = null;
    await _tripSocketClient.disconnect();
  }

  @override
  Future<void> close() async {
    _stopPolling();
    await _stopRealtime();
    await _tripSocketClient.dispose();
    return super.close();
  }
}
