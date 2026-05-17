import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:parent_app/core/config/api_config.dart';
import 'package:parent_app/core/network/api_client.dart';
import 'package:parent_app/features/absence/data/student_data.dart';
import 'package:parent_app/features/students/data/models/route_student_item.dart';

class StudentsRepository {
  final Dio _dio;

  StudentsRepository({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  static String? _nonEmptyField(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final v = json[key];
      if (v == null) continue;
      final s = v.toString().trim();
      if (s.isNotEmpty) return s;
    }
    return null;
  }

  static List<String> _pinsFromMasterTempKeys(Map<String, dynamic> json) {
    final master = _nonEmptyField(json, [
      'masterPincode',
      'master_pincode',
      'masterPinCode',
      'master_pin_code',
      'masterPin',
      'master_pin',
    ]);
    final temp = _nonEmptyField(json, [
      'tempPincode',
      'temp_pincode',
      'tempPinCode',
      'temp_pin_code',
      'tempPin',
      'temp_pin',
    ]);
    final pins = <String>[];
    if (master != null) pins.add(master);
    if (temp != null) pins.add(temp);
    return pins;
  }

  /// API may send `pinCodes` as a string list, or as `{ masterPin, tempPin }`,
  /// or nested `pins`/`pin`; plus top-level master/temp variants on the student.
  static List<String> _parseStudentPinCodes(Map<String, dynamic> student) {
    final raw = student['pinCodes'] ?? student['pin_codes'];
    if (raw is List) {
      final fromList = raw
          .map((e) => e.toString().trim())
          .where((s) => s.isNotEmpty)
          .toList();
      if (fromList.isNotEmpty) return fromList;
    }
    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      final fromPinCodesObj = _pinsFromMasterTempKeys(map);
      if (fromPinCodesObj.isNotEmpty) return fromPinCodesObj;
    }

    final fromFlatStudent = _pinsFromMasterTempKeys(student);
    if (fromFlatStudent.isNotEmpty) return fromFlatStudent;

    final nested = student['pins'] ?? student['pin'];
    if (nested is Map<String, dynamic>) {
      return _parseStudentPinCodes(nested);
    }
    return const [];
  }

  Future<List<RouteStudentItem>> fetchRouteStudents({
    required String direction,
  }) async {
    if (!ApiConfig.useRealApi) {
      return _mockRouteStudents();
    }

    final response = await _dio.get(
      '/api/v1/routes/students',
      queryParameters: {'direction': direction},
    );
    final body = response.data;
    final rawData = body is Map<String, dynamic>
        ? (body['data'] ?? body)
        : body;
    final students = rawData is Map<String, dynamic>
        ? rawData['students']
        : null;
    if (students is! List) {
      return _mockRouteStudents();
    }

    final mapped = students.whereType<Map<String, dynamic>>().map((student) {
      final pickup = student['activePickup'] as Map<String, dynamic>?;
      final coords = pickup?['coords'];
      LatLng? location;
      if (coords is List && coords.length >= 2) {
        location = LatLng(
          (coords[0] as num).toDouble(),
          (coords[1] as num).toDouble(),
        );
      }
      final gMapsUrl = pickup?['gMapsUrl']?.toString() ?? '';
      final address = pickup?['description']?.toString() ?? '';
      final name = student['name']?.toString() ?? 'Student';
      final backendId = _nonEmptyField(student, ['id', 'studentId', 'student_id', 'pk']);
      return RouteStudentItem(
        id: backendId ?? name,
        backendStudentId: backendId,
        name: name,
        address: address,
        gMapsUrl: gMapsUrl,
        coords: location,
        studentData: StudentData(
          id: int.tryParse(backendId ?? '') ?? 0,
          name: name,
          grade: student['grade']?.toString() ?? '',
          pinCodes: _parseStudentPinCodes(student),
          address: address,
          gMapsLink: gMapsUrl,
          coords: coords is List
              ? coords.map((e) => e.toString()).toList()
              : const [],
          latestMessage: StudentLatestMessage.tryParse(
            student['latestMessage'] ?? student['latest_message'],
          ),
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
    final mapped = StudentData.mockStudentData
        .map(
          (student) => RouteStudentItem(
            id: student.id.toString(),
            backendStudentId: student.id.toString(),
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
      gMapsUrl: 'https://maps.app.goo.gl/JqJKgJL8GUo2LHBA7',
      coords: LatLng(29.962477, 31.271561),
      isSchool: true,
    );
  }
}
