import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:parent_app/core/config/api_config.dart';
import 'package:parent_app/features/auth/data/services/jwt_storage.dart';

class ApiClient {
  ApiClient._();

  static final JwtStorage _jwtStorage = JwtStorage();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'Accept': 'application/json',
        Headers.contentTypeHeader: Headers.jsonContentType,
      },
    ),
  )..interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.extra['skipAuth'] == true) {
            handler.next(options);
            return;
          }
          final tokens = await _jwtStorage.load();
          if (tokens != null) {
            options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode != 401) {
            if (error.response?.statusCode == 403) {
              await _jwtStorage.clear();
            }
            handler.next(error);
            return;
          }

          final requestOptions = error.requestOptions;
          if (requestOptions.extra['skipAuth'] == true ||
              requestOptions.extra['retried'] == true) {
            await _jwtStorage.clear();
            handler.next(error);
            return;
          }

          final tokens = await _jwtStorage.load();
          if (tokens == null || tokens.refreshToken.isEmpty) {
            await _jwtStorage.clear();
            handler.next(error);
            return;
          }

          try {
            final refreshResponse = await dio.post<dynamic>(
              '/api/common/auth/token/refresh',
              data: {'refresh_token': tokens.refreshToken},
              options: Options(
                extra: {'skipAuth': true},
                contentType: Headers.jsonContentType,
              ),
            );

            Map<String, dynamic>? dataMap;
            final body = refreshResponse.data;
            if (body is Map<String, dynamic>) {
              final inner = body['data'];
              dataMap = inner is Map<String, dynamic> ? inner : body;
            }

            final access = dataMap?['access']?.toString();
            final newRefresh = dataMap?['refresh']?.toString();
            if (access == null || access.isEmpty) {
              await _jwtStorage.clear();
              handler.next(error);
              return;
            }

            await _jwtStorage.save(
              accessToken: access,
              refreshToken: (newRefresh != null && newRefresh.isNotEmpty)
                  ? newRefresh
                  : tokens.refreshToken,
            );

            requestOptions.headers['Authorization'] = 'Bearer $access';
            requestOptions.extra = Map<String, dynamic>.from(requestOptions.extra)
              ..['retried'] = true;

            final response = await dio.fetch<dynamic>(requestOptions);
            handler.resolve(response);
          } catch (_) {
            await _jwtStorage.clear();
            handler.next(error);
          }
        },
      ),
      if (kDebugMode) _DebugHttpLoggingInterceptor(),
    ]);
}

/// Logs each HTTP request and response to the console in debug builds only.
/// Sensitive keys (tokens, passwords) are redacted.
class _DebugHttpLoggingInterceptor extends Interceptor {
  static const int _maxBodyChars = 4096;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final auth = options.headers['Authorization'] ?? options.headers['authorization'];
    final buf = StringBuffer()
      ..writeln('[HTTP] --> ${options.method} ${options.uri}');
    if (auth != null) {
      buf.writeln('[HTTP]     Authorization: Bearer <redacted>');
    }
    final data = options.data;
    if (data != null) {
      buf.writeln('[HTTP]     ${_truncate(_stringifyForLog(data))}');
    }
    debugPrint(buf.toString().trimRight());
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final body = _truncate(_stringifyForLog(response.data));
    debugPrint(
      '[HTTP] <-- ${response.statusCode} ${response.requestOptions.uri}\n'
      '[HTTP]     $body',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
      '[HTTP] xx ${err.response?.statusCode ?? '---'} ${err.requestOptions.uri} '
      '${err.message}',
    );
    final d = err.response?.data;
    if (d != null) {
      debugPrint('[HTTP]     ${_truncate(_stringifyForLog(d))}');
    }
    handler.next(err);
  }

  static String _stringifyForLog(dynamic data) {
    try {
      final redacted = _redactSensitive(data);
      if (redacted is Map || redacted is List) {
        return const JsonEncoder.withIndent('  ').convert(redacted);
      }
      return redacted.toString();
    } catch (_) {
      return data.toString();
    }
  }

  static dynamic _redactSensitive(dynamic value) {
    if (value is Map) {
      return value.map((dynamic k, dynamic v) {
        final key = k.toString().toLowerCase();
        final sensitive =
            key.contains('token') ||
            key.contains('password') ||
            key.contains('secret') ||
            key == 'authorization';
        if (sensitive) {
          return MapEntry(k, '<redacted>');
        }
        return MapEntry(k, _redactSensitive(v));
      });
    }
    if (value is List) {
      return value.map(_redactSensitive).toList();
    }
    return value;
  }

  static String _truncate(String s) {
    if (s.length <= _maxBodyChars) return s;
    return '${s.substring(0, _maxBodyChars)}… (${s.length} chars total)';
  }
}
