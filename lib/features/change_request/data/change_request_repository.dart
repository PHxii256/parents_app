import 'package:dio/dio.dart';
import 'package:parent_app/core/config/api_config.dart';
import 'package:parent_app/core/network/api_client.dart';

class LocationChangeRequestData {
  final String id;
  final String status;
  final String? effectiveUntil;

  const LocationChangeRequestData({
    required this.id,
    required this.status,
    this.effectiveUntil,
  });
}

class ChangeRequestRepository {
  final Dio _dio;
  LocationChangeRequestData? _mockActiveRequest;

  ChangeRequestRepository({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  Future<LocationChangeRequestData?> getActiveRequest() async {
    if (!ApiConfig.useRealApi) {
      return _mockActiveRequest;
    }
    final response = await _dio.get('/api/v1/guardian/location-change-requests/active');
    final body = response.data;
    final data = body is Map<String, dynamic> ? (body['data'] ?? body) : body;
    final request = data is Map<String, dynamic> ? data['request'] : null;
    if (request is! Map<String, dynamic>) return null;
    return LocationChangeRequestData(
      id: request['id']?.toString() ?? '',
      status: request['status']?.toString() ?? 'pending_review',
      effectiveUntil: request['effectiveUntil']?.toString(),
    );
  }

  Future<LocationChangeRequestData> submitRequest({
    required DateTime targetDate,
    required String changeType,
    required String locationId,
  }) async {
    if (!ApiConfig.useRealApi) {
      _mockActiveRequest = LocationChangeRequestData(
        id: 'mock-${DateTime.now().millisecondsSinceEpoch}',
        status: 'pending_review',
      );
      return _mockActiveRequest!;
    }
    final response = await _dio.post(
      '/api/v1/guardian/location-change-requests',
      data: {
        'targetDate': targetDate.toIso8601String().split('T').first,
        'changeType': changeType,
        'newLocationId': locationId,
      },
    );
    final body = response.data;
    final data = body is Map<String, dynamic> ? (body['data'] ?? body) : body;
    final requestId = data is Map<String, dynamic> ? data['requestId']?.toString() : null;
    return LocationChangeRequestData(id: requestId ?? '', status: 'pending_review');
  }

  Future<bool> cancelRequest(String requestId) async {
    if (!ApiConfig.useRealApi) {
      _mockActiveRequest = null;
      return true;
    }
    final response = await _dio.delete('/api/v1/guardian/location-change-requests/$requestId');
    return (response.statusCode ?? 500) < 400;
  }

  Future<LocationChangeRequestData?> getRequestById(String requestId) async {
    if (!ApiConfig.useRealApi) {
      return _mockActiveRequest;
    }
    final response = await _dio.get('/api/v1/guardian/location-change-requests/$requestId');
    final body = response.data;
    final data = body is Map<String, dynamic> ? (body['data'] ?? body) : body;
    if (data is! Map<String, dynamic>) return null;
    return LocationChangeRequestData(
      id: data['id']?.toString() ?? requestId,
      status: data['status']?.toString() ?? 'pending_review',
      effectiveUntil: data['effectiveUntil']?.toString(),
    );
  }
}
