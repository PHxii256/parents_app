import 'package:latlong2/latlong.dart';
import 'package:parent_app/features/absence/data/student_data.dart';

class RouteStudentItem {
  /// Stable key for UI/state maps (backend id when present, otherwise name fallback).
  final String id;
  /// Parsed from API (`id`, `studentId`, …); must be used for `/students/{id}/…` POSTs.
  final String? backendStudentId;
  final String name;
  final String address;
  final String gMapsUrl;
  final LatLng? coords;
  final bool isSchool;
  final StudentData? studentData;

  const RouteStudentItem({
    required this.id,
    this.backendStudentId,
    required this.name,
    required this.address,
    required this.gMapsUrl,
    required this.coords,
    this.isSchool = false,
    this.studentData,
  });
}
