import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/home/cubit/trip_state.dart';

class TripCubit extends Cubit<TripState> {
  TripCubit() : super(ActiveTripState.exampleActiveState);
  int _currentCycleIndex = 0;

  // for testing
  void cycleState() {
    final states = [ActiveTripState.exampleActiveState, OfflineTripState(), InactiveTripState()];
    emit(states[++_currentCycleIndex % 3]);
  }
}
