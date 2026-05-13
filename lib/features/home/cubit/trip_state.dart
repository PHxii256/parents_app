import 'package:parent_app/features/home/data/models/staff_data.dart';
import 'package:latlong2/latlong.dart';

sealed class TripState {}

class ActiveTripState extends TripState {
  final int? tripId;
  final int eta;
  final String licensePlateLetters;
  final String licensePlateNumbers;
  final StaffData assistantInfo;
  final StaffData driverInfo;
  final LatLng? busCoords;
  ActiveTripState({
    this.tripId,
    required this.eta,
    required this.licensePlateLetters,
    required this.licensePlateNumbers,
    required this.assistantInfo,
    required this.driverInfo,
    this.busCoords,
  });

  ActiveTripState copyWith({
    int? tripId,
    int? eta,
    String? licensePlateLetters,
    String? licensePlateNumbers,
    StaffData? assistantInfo,
    StaffData? driverInfo,
    LatLng? busCoords,
    bool clearBusCoords = false,
  }) {
    return ActiveTripState(
      tripId: tripId ?? this.tripId,
      eta: eta ?? this.eta,
      licensePlateLetters: licensePlateLetters ?? this.licensePlateLetters,
      licensePlateNumbers: licensePlateNumbers ?? this.licensePlateNumbers,
      assistantInfo: assistantInfo ?? this.assistantInfo,
      driverInfo: driverInfo ?? this.driverInfo,
      busCoords: clearBusCoords ? null : (busCoords ?? this.busCoords),
    );
  }

  static final exampleActiveState = ActiveTripState(
    assistantInfo: StaffData(name: "Samira Ahmed", phoneNum: "01061234567"),
    driverInfo: StaffData(name: "Mohsen Dawood", phoneNum: "01123546778"),
    eta: 5,
    licensePlateLetters: "س ص ع",
    licensePlateNumbers: "1345",
    busCoords: LatLng(29.996608, 30.965438),
  );
}

class InactiveTripState extends TripState {}

class OfflineTripState extends TripState {}
