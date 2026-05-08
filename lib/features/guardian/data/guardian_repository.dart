import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:parent_app/core/config/api_config.dart';
import 'package:parent_app/core/network/api_client.dart';
import 'package:parent_app/features/locations/data/models/saved_location.dart';

/// Splits API `description` like `"Home — Apt 5"` into title + detail for models and tiles.
(String, String) _splitLocationDescription(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return ('', '');
  const separators = [' — ', ' – ', ' - '];
  for (final sep in separators) {
    final i = trimmed.indexOf(sep);
    if (i >= 0) {
      return (
        trimmed.substring(0, i).trim(),
        trimmed.substring(i + sep.length).trim(),
      );
    }
  }
  return (trimmed, '');
}

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
      return const GuardianPinsData(masterPin: '12345', tempPin: '56789');
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
          {'id': '1', 'name': 'Ahmed Mohsen', 'grade': 'Grade 2'},
          {'id': '2', 'name': 'Fatma Mohsen', 'grade': 'Grade 5'},
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
                  .toList()
                  .asMap()
                  .entries
                  .map(
                    (entry) => {
                      'id':
                          entry.value['id']?.toString() ??
                          entry.value['student_id']?.toString() ??
                          entry.value['studentId']?.toString() ??
                          '${entry.key + 1}',
                      'name': entry.value['name']?.toString() ?? '',
                      'grade': entry.value['grade']?.toString() ?? '',
                    },
                  )
                  .toList()
              : const [],
    );
  }

  /// Student IDs for the logged-in guardian (from profile children). Empty if none parsed.
  Future<List<int>> getAssignedStudentIds() async {
    final profile = await getProfile();
    final ids = <int>[];
    for (final child in profile.children) {
      final raw = (child['id'] ?? '').trim();
      if (raw.isEmpty) continue;
      final n = int.tryParse(raw);
      if (n != null) {
        ids.add(n);
      }
    }
    if (ids.isEmpty && kDebugMode) {
      debugPrint(
        '[Guardian] getAssignedStudentIds: no numeric ids (${profile.children.length} children in profile).',
      );
    }
    return ids;
  }

  Future<List<SavedLocation>> getLocations() async {
    if (!ApiConfig.useRealApi) {
      return const [];
    }
    final response = await _dio.get('/api/v1/guardian/locations');
    final data = _extractData(response.data);
    if (data is! List) return const [];
    return data.whereType<Map<String, dynamic>>().map((location) {
      final lat = (location['latitude'] as num?)?.toDouble();
      final lng = (location['longitude'] as num?)?.toDouble();
      final rawDesc = location['description']?.toString().trim() ?? '';
      final parts = _splitLocationDescription(rawDesc);
      return SavedLocation(
        id: location['id']?.toString() ?? '',
        name: parts.$1.isNotEmpty ? parts.$1 : 'Saved location',
        addressLine: parts.$2,
        latitude: lat,
        longitude: lng,
      );
    }).toList();
  }

  Future<void> createLocation(SavedLocation location) async {
    if (!ApiConfig.useRealApi) return;
    final lat = location.latitude;
    final lng = location.longitude;
    if (lat == null || lng == null) {
      if (kDebugMode) {
        debugPrint('[Guardian] createLocation skipped: missing latitude/longitude');
      }
      return;
    }
    final description = location.addressLine.isNotEmpty
        ? '${location.name.trim()} — ${location.addressLine.trim()}'
        : location.name.trim();
    // Matches Postman `Add Saved Location`: description, latitude, longitude, gmaps_url
    await _dio.post(
      '/api/v1/guardian/locations',
      data: {
        'description': description.isNotEmpty ? description : 'Saved location',
        'latitude': lat,
        'longitude': lng,
        'gmaps_url': 'https://maps.google.com/?q=$lat,$lng',
      },
    );
  }

  Future<void> sendMessage({required String content, required String studentId}) async {
    if (!ApiConfig.useRealApi) return;
    await _dio.post('/api/v1/guardian/messages', data: {'content': content, 'studentId': studentId});
  }

  /// Backend expects `token` + `device_type` (see Postman: ANDROID / IOS / …).
  Future<void> registerFcmToken(String? token) async {
    if (!ApiConfig.useRealApi || token == null || token.isEmpty) return;
    try {
      await _dio.post(
        '/api/v1/devices/fcm-token',
        data: {'token': token, 'device_type': _fcmDeviceType()},
      );
    } on DioException catch (e) {
      // Registration is best-effort; local FCM still works. Avoid surfacing raw Dio to UI.
      if (kDebugMode) {
        debugPrint(
          '[FCM] POST /devices/fcm-token failed: ${e.response?.statusCode} '
          '${e.response?.data}',
        );
      }
    }
  }

  static String _fcmDeviceType() {
    if (kIsWeb) return 'WEB';
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'ANDROID',
      TargetPlatform.iOS => 'IOS',
      TargetPlatform.macOS => 'MACOS',
      TargetPlatform.windows => 'WINDOWS',
      TargetPlatform.linux => 'LINUX',
      TargetPlatform.fuchsia => 'FUCHSIA',
    };
  }

  dynamic _extractData(dynamic body) {
    if (body is Map<String, dynamic>) {
      return body['data'] ?? body;
    }
    return body;
  }
}
