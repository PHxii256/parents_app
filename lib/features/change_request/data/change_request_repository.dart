import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:parent_app/core/config/api_config.dart';
import 'package:parent_app/core/network/api_client.dart';
import 'package:parent_app/features/guardian/data/guardian_repository.dart';

class LocationChangeRequestData {
  final String id;
  final String status;
  final String? effectiveUntil;
  final String? targetDate;
  final String? changeType;
  final String? newLocationId;

  const LocationChangeRequestData({
    required this.id,
    required this.status,
    this.effectiveUntil,
    this.targetDate,
    this.changeType,
    this.newLocationId,
  });

  /// True unless the server considers this request finished (no longer occupies the "active" slot).
  /// Shapes differ by backend: [pending], [pending_review], [accepted], [approved], etc.
  bool get blocksNewSubmissions {
    final normalized = status.trim().toLowerCase().replaceAll(RegExp(r'[\s-]+'), '_');
    if (normalized.isEmpty) return true;
    const terminal = {
      'fulfilled',
      'completed',
      'complete',
      'done',
      'cancelled',
      'canceled',
      'rejected',
      'denied',
      'expired',
      'failed',
      'void',
      'closed',
      'withdrawn',
    };
    return !terminal.contains(normalized);
  }
}

dynamic _parseNewLocationId(String locationId) {
  final trimmed = locationId.trim();
  final asInt = int.tryParse(trimmed);
  if (asInt != null) return asInt;
  return trimmed;
}

bool _looksLikeChangeRequestMap(Map<String, dynamic> m) {
  return m['id'] != null ||
      m['pk'] != null ||
      m['request_id'] != null ||
      m['requestId'] != null ||
      m['status'] != null ||
      m['target_date'] != null ||
      m['targetDate'] != null ||
      m['change_type'] != null ||
      m['changeType'] != null ||
      m['new_location_id'] != null ||
      m['newLocationId'] != null;
}

/// Dio/jsonDecode often yield [Map<dynamic, dynamic>], which fails `is Map<String, dynamic>`.
Map<String, dynamic>? _jsonObjectMap(dynamic value) {
  if (value == null) return null;
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    final out = <String, dynamic>{};
    value.forEach((k, v) {
      out[k.toString()] = v;
    });
    return out;
  }
  return null;
}

/// Unwraps `{ data: ... }`, double envelopes, and nested `request` keys from GET …/active.
Map<String, dynamic>? _extractActiveChangeRequestMap(dynamic body) {
  final root = _jsonObjectMap(body);
  if (root == null) return null;

  dynamic rawLayer = root['data'] ?? root['result'] ?? root;
  Map<String, dynamic>? layerMap = _jsonObjectMap(rawLayer);

  // `data` may be a single-element list wrapping the request object.
  if (layerMap == null && rawLayer is List && rawLayer.isNotEmpty) {
    layerMap = _jsonObjectMap(rawLayer.first);
  }

  if (layerMap == null) return null;

  Map<String, dynamic> map = layerMap;

  final inner = map['data'];
  final innerMap = _jsonObjectMap(inner);
  if (innerMap != null &&
      map['request'] == null &&
      !_looksLikeChangeRequestMap(map)) {
    if (innerMap['request'] != null || _looksLikeChangeRequestMap(innerMap)) {
      map = innerMap;
    }
  }

  if (map.containsKey('request')) {
    final req = map['request'];
    if (req != null) {
      final parsed = _jsonObjectMap(req);
      if (parsed != null) return parsed;
    }
  }

  const nestedKeys = [
    'active_request',
    'activeRequest',
    'active',
    'location_change_request',
    'locationChangeRequest',
    'current_request',
    'currentRequest',
    'pending_request',
    'pendingRequest',
  ];
  for (final key in nestedKeys) {
    final parsed = _jsonObjectMap(map[key]);
    if (parsed != null) return parsed;
  }

  if (_looksLikeChangeRequestMap(map)) return map;

  return _findNestedChangeRequestMap(map);
}

/// Last resort: walk nested maps/lists under `data` (some APIs nest under `results`, etc.).
Map<String, dynamic>? _findNestedChangeRequestMap(dynamic node, [int depth = 0]) {
  if (depth > 8) return null;
  final m = _jsonObjectMap(node);
  if (m != null) {
    if (_looksLikeChangeRequestMap(m)) return m;
    for (final v in m.values) {
      final found = _findNestedChangeRequestMap(v, depth + 1);
      if (found != null) return found;
    }
  } else if (node is List) {
    for (final e in node) {
      final found = _findNestedChangeRequestMap(e, depth + 1);
      if (found != null) return found;
    }
  }
  return null;
}

class ChangeRequestRepository {
  final Dio _dio;
  final GuardianRepository _guardianRepository;
  LocationChangeRequestData? _mockActiveRequest;

  ChangeRequestRepository({Dio? dio, GuardianRepository? guardianRepository})
    : _dio = dio ?? ApiClient.dio,
      _guardianRepository = guardianRepository ?? GuardianRepository();

  Future<LocationChangeRequestData?> getActiveRequest() async {
    if (!ApiConfig.useRealApi) {
      return _mockActiveRequest;
    }
    final response = await _dio.get('/api/v1/guardian/location-change-requests/active');
    final body = response.data;
    final extracted = _extractActiveChangeRequestMap(body);
    if (kDebugMode && extracted == null) {
      final root = _jsonObjectMap(body);
      final dataRaw = root?['data'];
      debugPrint(
        '[ChangeRequest] getActiveRequest: no request map parsed. '
        'body keys: ${root?.keys.toList()}, data runtimeType: ${dataRaw?.runtimeType}',
      );
    }
    if (extracted == null) return null;
    return _locationChangeRequestFromMap(extracted);
  }

  LocationChangeRequestData _locationChangeRequestFromMap(Map<String, dynamic> request) {
    final idRaw =
        request['id'] ??
        request['pk'] ??
        request['request_id'] ??
        request['requestId'];
    return LocationChangeRequestData(
      id: idRaw?.toString() ?? '',
      status: request['status']?.toString() ?? 'pending_review',
      effectiveUntil:
          request['effectiveUntil']?.toString() ?? request['effective_until']?.toString(),
      targetDate: request['targetDate']?.toString() ?? request['target_date']?.toString(),
      changeType:
          request['changeType']?.toString() ??
          request['change_type']?.toString(),
      newLocationId:
          request['newLocationId']?.toString() ??
          request['new_location_id']?.toString(),
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
        targetDate: targetDate.toIso8601String().split('T').first,
        changeType: changeType,
        newLocationId: locationId,
      );
      return _mockActiveRequest!;
    }
    final studentIds = await _guardianRepository.getAssignedStudentIds();
    if (studentIds.isEmpty && kDebugMode) {
      debugPrint(
        '[ChangeRequest] submitRequest: studentIds is empty — POST may fail if the backend requires students.',
      );
    }
    // Matches Postman "Submit New Day Change": snake_case keys + studentIds.
    final response = await _dio.post(
      '/api/v1/guardian/location-change-requests',
      data: {
        'target_date': targetDate.toIso8601String().split('T').first,
        'change_type': changeType,
        'newLocationId': _parseNewLocationId(locationId),
        'studentIds': studentIds,
      },
    );
    final body = response.data;
    final data = body is Map<String, dynamic> ? (body['data'] ?? body) : body;
    final requestId = data is Map<String, dynamic>
        ? (data['requestId'] ?? data['request_id'] ?? data['id'])?.toString()
        : null;
    return LocationChangeRequestData(
      id: requestId ?? '',
      status: 'pending_review',
      targetDate: targetDate.toIso8601String().split('T').first,
      changeType: changeType,
      newLocationId: locationId,
    );
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
    return _locationChangeRequestFromMap(data);
  }
}
