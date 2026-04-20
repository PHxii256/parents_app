import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/home/cubit/trip_state.dart';
import 'package:parent_app/features/home/data/repositories/trip_repository.dart';

class TripCubit extends Cubit<TripState> {
  final TripRepository _tripRepository;
  Timer? _pollingTimer;

  TripCubit({TripRepository? tripRepository})
    : _tripRepository = tripRepository ?? TripRepository(),
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
      } else {
        _stopPolling();
      }
    } catch (_) {
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

  @override
  Future<void> close() {
    _stopPolling();
    return super.close();
  }
}
