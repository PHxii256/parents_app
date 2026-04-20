sealed class DriverTripSessionState {}

class DriverTripIdleState extends DriverTripSessionState {}

class DriverTripActiveState extends DriverTripSessionState {}

class DriverTripUpdatingState extends DriverTripSessionState {}

class DriverTripErrorState extends DriverTripSessionState {
  final String message;
  DriverTripErrorState(this.message);
}
