import 'package:latlong2/latlong.dart';
import 'package:parent_app/core/config/api_config.dart';
import 'package:parent_app/features/home/cubit/trip_state.dart';
import 'package:parent_app/features/home/data/provider/trip_data_provider.dart';
import 'package:parent_app/features/home/data/models/staff_data.dart';

class TripRepository {
  final TripDataProvider tripData = TripDataProvider();

  Future<TripState> fetchTripState() async {
    if (!ApiConfig.useRealApi) {
      return ActiveTripState.exampleActiveState;
    }

    final response = await tripData.getCurrentTrip();
    final body = response.data;
    final data = _extractDataEnvelope(body);

    if (data is! Map<String, dynamic>) {
      return InactiveTripState();
    }

    final isTripActive = data['tripActive'] as bool? ?? false;
    if (!isTripActive) {
      return InactiveTripState();
    }

    final status = (data['status'] as String?)?.toLowerCase();
    if (status == 'offline' || status == 'network_error') {
      return OfflineTripState();
    }

    final eta =
        (data['eta'] as num?)?.toInt() ??
        ((data['tripUpdate'] as Map<String, dynamic>?)?['eta'] as num?)?.toInt() ??
        0;

    final plate = data['licensePlate'] as Map<String, dynamic>?;
    final assistant = data['assistantInfo'] as Map<String, dynamic>?;
    final driver = data['driverInfo'] as Map<String, dynamic>?;

    final busCoords =
        _parseBusCoords(data['busCoords']) ??
        _parseBusCoords((data['tripUpdate'] as Map<String, dynamic>?)?['busCoords']);

    return ActiveTripState(
      eta: eta,
      licensePlateLetters:
          (data['licencePlateLetters'] as String?) ??
          (plate?['letters'] as String?) ??
          '',
      licensePlateNumbers:
          (data['licencePlateNumbers'] as String?) ??
          (plate?['numbers'] as String?) ??
          '',
      assistantInfo: StaffData(
        name: (data['assistantName'] as String?) ?? (assistant?['name'] as String?) ?? '',
        phoneNum: (data['assistantPhoneNum'] as String?) ?? (assistant?['phoneNum'] as String?) ?? '',
        whatsappLink: assistant?['whatsappLink'] as String?,
      ),
      driverInfo: StaffData(
        name: (data['driverName'] as String?) ?? (driver?['name'] as String?) ?? '',
        phoneNum: (driver?['phoneNum'] as String?) ?? '',
        whatsappLink: driver?['whatsappLink'] as String?,
      ),
      busCoords: busCoords,
    );
  }

  Future<bool> startTrip() async {
    if (!ApiConfig.useRealApi) return true;
    final response = await tripData.startTrip();
    return (response.statusCode ?? 500) < 400;
  }

  Future<bool> updateLocation(List<double> currentCoords) async {
    if (!ApiConfig.useRealApi) return true;
    final response = await tripData.updateLocation(currentCoords);
    return (response.statusCode ?? 500) < 400;
  }

  Future<bool> isTripActive() async {
    if (!ApiConfig.useRealApi) return true;
    final response = await tripData.getActiveTrip();
    final data = _extractDataEnvelope(response.data);
    if (data is Map<String, dynamic>) {
      return data['tripActive'] as bool? ?? false;
    }
    return false;
  }

  Future<bool> endTrip() async {
    if (!ApiConfig.useRealApi) return true;
    final response = await tripData.endTrip();
    return (response.statusCode ?? 500) < 400;
  }

  dynamic _extractDataEnvelope(dynamic body) {
    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data != null) return data;
      return body;
    }
    return body;
  }

  LatLng? _parseBusCoords(dynamic rawCoords) {
    if (rawCoords is List && rawCoords.length >= 2) {
      final lat = (rawCoords[0] as num?)?.toDouble();
      final lng = (rawCoords[1] as num?)?.toDouble();
      if (lat != null && lng != null) {
        return LatLng(lat, lng);
      }
    }
    return null;
  }
}
