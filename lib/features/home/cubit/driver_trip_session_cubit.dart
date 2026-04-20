import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parent_app/features/home/cubit/driver_trip_session_state.dart';
import 'package:parent_app/features/home/data/repositories/trip_repository.dart';

class DriverTripSessionCubit extends Cubit<DriverTripSessionState> {
  final TripRepository _tripRepository;
  StreamSubscription<Position>? _positionSubscription;
  DateTime? _lastSentAt;
  Position? _lastSentPosition;

  DriverTripSessionCubit({TripRepository? tripRepository})
    : _tripRepository = tripRepository ?? TripRepository(),
      super(DriverTripIdleState());

  Future<void> startSession() async {
    try {
      final started = await _tripRepository.startTrip();
      if (!started) {
        emit(DriverTripErrorState('Unable to start trip.'));
        return;
      }
      emit(DriverTripActiveState());
      await _positionSubscription?.cancel();
      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 25,
        ),
      ).listen(_onPositionUpdate);
    } catch (e) {
      emit(DriverTripErrorState('Unable to start trip.'));
    }
  }

  Future<void> endSession() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    try {
      final ended = await _tripRepository.endTrip();
      if (!ended) {
        emit(DriverTripErrorState('Unable to end trip.'));
        return;
      }
      emit(DriverTripIdleState());
    } catch (_) {
      emit(DriverTripErrorState('Unable to end trip.'));
    }
  }

  Future<void> _onPositionUpdate(Position position) async {
    final now = DateTime.now();
    final recentlySent =
        _lastSentAt != null && now.difference(_lastSentAt!) < const Duration(seconds: 5);
    final movedDistance =
        _lastSentPosition == null
            ? 9999
            : Geolocator.distanceBetween(
              _lastSentPosition!.latitude,
              _lastSentPosition!.longitude,
              position.latitude,
              position.longitude,
            );

    if (recentlySent && movedDistance < 100) {
      return;
    }

    emit(DriverTripUpdatingState());
    final sent = await _tripRepository.updateLocation([position.latitude, position.longitude]);
    if (sent) {
      _lastSentAt = now;
      _lastSentPosition = position;
      emit(DriverTripActiveState());
    } else {
      emit(DriverTripErrorState('Unable to upload location update.'));
    }
  }

  @override
  Future<void> close() async {
    await _positionSubscription?.cancel();
    return super.close();
  }
}
