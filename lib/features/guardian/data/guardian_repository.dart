import 'package:dio/dio.dart';
import 'package:parent_app/core/config/api_config.dart';
import 'package:parent_app/core/network/api_client.dart';
import 'package:parent_app/features/locations/data/models/saved_location.dart';

class GuardianProfileData {
  final String name;
  final String primaryPhone;
  final String secondaryPhone;
  final String email;
  final List<Map<String, String>> children;

  const GuardianProfileData({
    required this.name,
    required this.primaryPhone,
    required this.secondaryPhone,
    required this.email,
    required this.children,
  });
}

class GuardianPinsData {
  final String masterPin;
  final String tempPin;

  const GuardianPinsData({required this.masterPin, required this.tempPin});
}

class GuardianRepository {
  final Dio _dio;

  GuardianRepository({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  Future<GuardianPinsData> getPins() async {
    if (!ApiConfig.useRealApi) {
      return const GuardianPinsData(masterPin: '1234', tempPin: '5678');
    }
    final response = await _dio.get('/api/v1/guardian/pins');
    final data = _extractData(response.data);
    return GuardianPinsData(
      masterPin: data['masterPin']?.toString() ?? '',
      tempPin: data['tempPin']?.toString() ?? '',
    );
  }

  Future<GuardianProfileData> getProfile() async {
    if (!ApiConfig.useRealApi) {
      return const GuardianProfileData(
        name: 'Ahmed Mohamed Ahmed',
        primaryPhone: '01020002650',
        secondaryPhone: '01030002400',
        email: 'test@gmail.com',
        children: [
          {'name': 'Ahmed Mohsen', 'grade': 'Grade 2'},
          {'name': 'Fatma Mohsen', 'grade': 'Grade 5'},
        ],
      );
    }
    final response = await _dio.get('/api/v1/guardian/profile');
    final data = _extractData(response.data);
    final childrenRaw = data['children'];
    return GuardianProfileData(
      name: data['name']?.toString() ?? '',
      primaryPhone: data['primaryPhone']?.toString() ?? '',
      secondaryPhone: data['secondaryPhone']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      children:
          childrenRaw is List
              ? childrenRaw
                  .whereType<Map<String, dynamic>>()
                  .map(
                    (child) => {
                      'name': child['name']?.toString() ?? '',
                      'grade': child['grade']?.toString() ?? '',
                    },
                  )
                  .toList()
              : const [],
    );
  }

  Future<List<SavedLocation>> getLocations() async {
    if (!ApiConfig.useRealApi) {
      return const [];
    }
    final response = await _dio.get('/api/v1/guardian/locations');
    final data = _extractData(response.data);
    if (data is! List) return const [];
    return data.whereType<Map<String, dynamic>>().map((location) {
      return SavedLocation(
        id: location['id']?.toString() ?? '',
        name: location['description']?.toString() ?? 'Saved location',
        addressLine: location['description']?.toString() ?? '',
      );
    }).toList();
  }

  Future<void> createLocation(SavedLocation location) async {
    if (!ApiConfig.useRealApi) return;
    await _dio.post(
      '/api/v1/guardian/locations',
      data: {'id': location.id, 'description': location.addressLine},
    );
  }

  Future<void> sendMessage({required String content, required String studentId}) async {
    if (!ApiConfig.useRealApi) return;
    await _dio.post('/api/v1/guardian/messages', data: {'content': content, 'studentId': studentId});
  }

  Future<void> registerFcmToken(String? token) async {
    if (!ApiConfig.useRealApi || token == null || token.isEmpty) return;
    await _dio.post('/api/v1/devices/fcm-token', data: {'token': token});
  }

  dynamic _extractData(dynamic body) {
    if (body is Map<String, dynamic>) {
      return body['data'] ?? body;
    }
    return body;
  }
}
