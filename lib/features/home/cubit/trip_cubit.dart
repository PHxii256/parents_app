import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/home/cubit/trip_state.dart';
import 'package:parent_app/features/home/data/repositories/trip_repository.dart';

class TripCubit extends Cubit<TripState> {
  final TripRepository _tripRepository;

  TripCubit({TripRepository? tripRepository})
    : _tripRepository = tripRepository ?? TripRepository(),
      super(ActiveTripState.exampleActiveState);

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
    } catch (_) {
      emit(OfflineTripState());
    }
  }
}
