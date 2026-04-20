import 'package:dio/dio.dart';
import 'package:parent_app/core/config/api_config.dart';
import 'package:parent_app/core/network/api_client.dart';
import 'package:parent_app/core/models/server_exception.dart';

class AuthDataProvider {
  final Dio _dio;

  AuthDataProvider({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  String _authPath(String role, String action) {
    final roleSegment = ApiConfig.roleAuthPathSegment(role);
    return '/api/v1/$roleSegment/auth/$action';
  }

  Future<Response> passwordLogin({
    required String role,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        _authPath(role, 'login'),
        data: {'email': email, 'password': password},
      );
      return response;
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Network error');
    }
  }

  Future<Response> verifyOtp({
    required String role,
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        _authPath(role, 'verify'),
        data: {'email': email, 'otp': otp},
      );
      return response;
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Network error');
    }
  }

  Future<Response> setInitialPassword({
    required String role,
    required String email,
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        _authPath(role, 'set-initial-password'),
        data: {
          'email': email,
          'reset_token': resetToken,
          'new_password': newPassword,
          'confirm_password': newPassword,
        },
      );
      return response;
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Network error');
    }
  }

  Future<Response> resendOtp({
    required String role,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        _authPath(role, 'resend-otp'),
        data: {'email': email, 'password': password},
      );
      return response;
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Network error');
    }
  }

  Future<Response> changePassword({
    required String role,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        _authPath(role, 'change-password'),
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
          'confirm_password': newPassword,
        },
      );
      return response;
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Network error');
    }
  }

  Future<Response> logout() async {
    // Backend logout endpoint is not finalized yet; keep local logout functional.
    return Response(
      requestOptions: RequestOptions(path: '/logout-local-stub'),
      statusCode: 200,
      data: {'success': true},
    );
  }
}
