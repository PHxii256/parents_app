import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:parent_app/core/config/api_config.dart';
import 'package:parent_app/core/network/api_client.dart';
import 'package:parent_app/features/absence/data/student_data.dart';
import 'package:parent_app/features/students/data/models/route_student_item.dart';

class StudentsRepository {
  final Dio _dio;

  StudentsRepository({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  Future<List<RouteStudentItem>> fetchRouteStudents({required String direction}) async {
    if (!ApiConfig.useRealApi) {
      return _mockRouteStudents();
    }

    final response = await _dio.get('/api/v1/routes/students', queryParameters: {'direction': direction});
    final body = response.data;
    final rawData = body is Map<String, dynamic> ? (body['data'] ?? body) : body;
    final students = rawData is Map<String, dynamic> ? rawData['students'] : null;
    if (students is! List) {
      return _mockRouteStudents();
    }

    final mapped =
        students.whereType<Map<String, dynamic>>().map((student) {
          final pickup = student['activePickup'] as Map<String, dynamic>?;
          final coords = pickup?['coords'];
          LatLng? location;
          if (coords is List && coords.length >= 2) {
            location = LatLng((coords[0] as num).toDouble(), (coords[1] as num).toDouble());
          }
          final gMapsUrl = pickup?['gMapsUrl']?.toString() ?? '';
          final address = pickup?['description']?.toString() ?? '';
          final name = student['name']?.toString() ?? 'Student';
          return RouteStudentItem(
            id: student['id']?.toString() ?? name,
            name: name,
            address: address,
            gMapsUrl: gMapsUrl,
            coords: location,
            studentData: StudentData(
              id: int.tryParse(student['id']?.toString() ?? '') ?? 0,
              name: name,
              grade: student['grade']?.toString() ?? '',
              pinCodes: const [],
              address: address,
              gMapsLink: gMapsUrl,
              coords: coords is List ? coords.map((e) => e.toString()).toList() : const [],
            ),
          );
        }).toList();

    return withSchoolEndpoints(mapped);
  }

  Future<RouteStudentItem> fetchSchoolLocation() async {
    if (!ApiConfig.useRealApi) {
      return _mockSchool();
    }
    final response = await _dio.get('/api/v1/school/location');
    final body = response.data;
    final data = body is Map<String, dynamic> ? (body['data'] ?? body) : body;
    if (data is Map<String, dynamic>) {
      return RouteStudentItem(
        id: 'school',
        name: data['name']?.toString() ?? 'School',
        address: data['name']?.toString() ?? 'School',
        gMapsUrl: data['gMapsUrl']?.toString() ?? '',
        coords: null,
        isSchool: true,
      );
    }
    return _mockSchool();
  }

  Future<bool> markBoarded(String studentId) async {
    if (!ApiConfig.useRealApi) return true;
    final response = await _dio.post('/api/v1/students/$studentId/boarded');
    return (response.statusCode ?? 500) < 400;
  }

  Future<bool> markDroppedOff(String studentId) async {
    if (!ApiConfig.useRealApi) return true;
    final response = await _dio.post('/api/v1/students/$studentId/dropped-off');
    return (response.statusCode ?? 500) < 400;
  }

  List<RouteStudentItem> withSchoolEndpoints(List<RouteStudentItem> students) {
    final school = _mockSchool();
    return [school, ...students, school];
  }

  List<RouteStudentItem> _mockRouteStudents() {
    final mapped =
        StudentData.mockStudentData
            .map(
              (student) => RouteStudentItem(
                id: student.id.toString(),
                name: student.name,
                address: student.address,
                gMapsUrl: student.gMapsLink,
                coords: student.toLatLng(),
                studentData: student,
              ),
            )
            .toList();
    return withSchoolEndpoints(mapped);
  }

  RouteStudentItem _mockSchool() {
    return const RouteStudentItem(
      id: 'school',
      name: 'Victory College School',
      address: 'School Campus',
      gMapsUrl: 'https://maps.app.goo.gl/JAHtk8j2YfS2DE5j9',
      coords: null,
      isSchool: true,
    );
  }
}
