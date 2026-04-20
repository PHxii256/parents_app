import 'package:latlong2/latlong.dart';
import 'package:parent_app/features/absence/data/student_data.dart';

class RouteStudentItem {
  final String id;
  final String name;
  final String address;
  final String gMapsUrl;
  final LatLng? coords;
  final bool isSchool;
  final StudentData? studentData;

  const RouteStudentItem({
    required this.id,
    required this.name,
    required this.address,
    required this.gMapsUrl,
    required this.coords,
    this.isSchool = false,
    this.studentData,
  });
}
