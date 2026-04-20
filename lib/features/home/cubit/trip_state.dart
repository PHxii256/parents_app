import 'package:parent_app/features/home/data/models/staff_data.dart';
import 'package:latlong2/latlong.dart';

sealed class TripState {}

class ActiveTripState extends TripState {
  final int eta;
  final String licensePlateLetters;
  final String licensePlateNumbers;
  final StaffData assistantInfo;
  final StaffData driverInfo;
  final LatLng? busCoords;
  ActiveTripState({
    required this.eta,
    required this.licensePlateLetters,
    required this.licensePlateNumbers,
    required this.assistantInfo,
    required this.driverInfo,
    this.busCoords,
  });

  static final exampleActiveState = ActiveTripState(
    assistantInfo: StaffData(name: "Samira Ahmed", phoneNum: "01061234567"),
    driverInfo: StaffData(name: "Mohsen Dawood", phoneNum: "01123546778"),
    eta: 5,
    licensePlateLetters: "س ص ع",
    licensePlateNumbers: "1345",
    busCoords: LatLng(29.972273, 30.943277),
  );
}

class InactiveTripState extends TripState {}

class OfflineTripState extends TripState {}
