import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:parent_app/core/config/api_config.dart';
import 'package:parent_app/core/models/server_exception.dart';
import 'package:parent_app/core/network/api_client.dart';

String _messageFromDio(DioException e) {
  final data = e.response?.data;
  if (data is Map) {
    final msg = data['message'];
    if (msg != null && msg.toString().trim().isNotEmpty) {
      return msg.toString();
    }
    final errs = data['errors'];
    if (errs is Map) {
      for (final value in errs.values) {
        if (value is List && value.isNotEmpty) {
          return value.first.toString();
        }
      }
    }
  }
    return e.message?.trim().isNotEmpty == true ? e.message! : 'Network error';
}

void _debugAuthDioFailure(String action, DioException e) {
  if (!kDebugMode) return;
  debugPrint('[Auth] $action → ${e.response?.statusCode} ${e.requestOptions.uri}');
  debugPrint('[Auth] response body: ${e.response?.data}');
}

class AuthDataProvider {
  final Dio _dio;

  AuthDataProvider({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  String _authPath(String role, String action) {
    final roleSegment = ApiConfig.roleAuthPathSegment(role);
    return '/api/v1/$roleSegment/auth/$action';
  }

  Future<Response<dynamic>> passwordLogin({
    required String role,
    required String email,
    required String password,
  }) async {
    try {
      return await _dio.post<dynamic>(
        _authPath(role, 'login'),
        data: {'email': email, 'password': password},
      );
    } on DioException catch (e) {
      _debugAuthDioFailure('POST login', e);
      throw ServerException(message: _messageFromDio(e));
    }
  }

  Future<Response<dynamic>> verifyOtp({
    required String role,
    required String email,
    required String otp,
  }) async {
    try {
      return await _dio.post<dynamic>(
        _authPath(role, 'verify'),
        data: {'email': email, 'otp': otp},
      );
    } on DioException catch (e) {
      _debugAuthDioFailure('POST verify', e);
      throw ServerException(message: _messageFromDio(e));
    }
  }

  Future<Response<dynamic>> setInitialPassword({
    required String role,
    required String email,
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      return await _dio.post<dynamic>(
        _authPath(role, 'set-initial-password'),
        data: {
          'email': email,
          'reset_token': resetToken,
          'new_password': newPassword,
          'confirm_password': newPassword,
        },
      );
    } on DioException catch (e) {
      _debugAuthDioFailure('POST set-initial-password', e);
      throw ServerException(message: _messageFromDio(e));
    }
  }

  Future<Response<dynamic>> resendOtp({
    required String role,
    required String email,
    required String password,
  }) async {
    try {
      return await _dio.post<dynamic>(
        _authPath(role, 'resend-otp'),
        data: {'email': email, 'password': password},
      );
    } on DioException catch (e) {
      _debugAuthDioFailure('POST resend-otp', e);
      throw ServerException(message: _messageFromDio(e));
    }
  }

  Future<Response<dynamic>> changePassword({
    required String role,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      return await _dio.post<dynamic>(
        _authPath(role, 'change-password'),
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
          'confirm_password': newPassword,
        },
      );
    } on DioException catch (e) {
      _debugAuthDioFailure('POST change-password', e);
      throw ServerException(message: _messageFromDio(e));
    }
  }

  Future<Response<dynamic>> logout() async {
    // Collection has no logout endpoint; clear tokens locally only.
    return Response<dynamic>(
      requestOptions: RequestOptions(path: '/logout-local-stub'),
      statusCode: 200,
      data: {'success': true},
    );
  }
}
