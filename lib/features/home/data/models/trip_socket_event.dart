import 'package:latlong2/latlong.dart';

sealed class TripSocketEvent {
  const TripSocketEvent();

  static TripSocketEvent? fromJson(Map<String, dynamic> json) {
    final type = json['type']?.toString().trim().toLowerCase();
    final data = json['data'];
    if (type == null || data is! Map) return null;
    final payload = <String, dynamic>{};
    data.forEach((k, v) => payload[k.toString()] = v);

    switch (type) {
      case 'location_update':
        final coordsRaw = payload['currentCoords'];
        if (coordsRaw is List && coordsRaw.length >= 2) {
          final lat = (coordsRaw[0] as num?)?.toDouble();
          final lng = (coordsRaw[1] as num?)?.toDouble();
          if (lat != null && lng != null) {
            return LocationUpdateSocketEvent(currentCoords: LatLng(lat, lng));
          }
        }
        return null;
      case 'guardian_message':
        return GuardianMessageSocketEvent(
          studentId: payload['student_id']?.toString(),
          content: payload['content']?.toString() ?? '',
          guardianName: payload['guardian_name']?.toString(),
        );
      case 'student_status':
        return StudentStatusSocketEvent(
          studentId: payload['student_id']?.toString(),
          status: payload['status']?.toString() ?? '',
        );
      default:
        return null;
    }
  }
}

class LocationUpdateSocketEvent extends TripSocketEvent {
  final LatLng currentCoords;

  const LocationUpdateSocketEvent({required this.currentCoords});
}

class GuardianMessageSocketEvent extends TripSocketEvent {
  final String? studentId;
  final String content;
  final String? guardianName;

  const GuardianMessageSocketEvent({
    required this.studentId,
    required this.content,
    required this.guardianName,
  });
}

class StudentStatusSocketEvent extends TripSocketEvent {
  final String? studentId;
  final String status;

  const StudentStatusSocketEvent({required this.studentId, required this.status});
}
