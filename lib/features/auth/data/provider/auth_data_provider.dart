import 'package:dio/dio.dart';
import 'package:parent_app/core/models/server_exception.dart';

class AuthDataProvider {
  final _dio = Dio(BaseOptions(baseUrl: "http://localhost:5000"));

  Future<Response> passwordLogin(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {'email': email, 'password': password});
      return response;
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Network error');
    }
  }

  // To:do replace double check params to make sure they makes sense
  Future<Response> jwtLogin({required String accessToken, required String refreshToken}) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'accessToken': accessToken, 'refreshToken': refreshToken},
      );
      return response;
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Network error');
    }
  }

  Future<Response> logout({required String accessToken, required String refreshToken}) async {
    final response = await _dio.post(
      '/logout',
      data: {'accessToken': accessToken, 'refreshToken': refreshToken},
    );
    return response;
  }

  Future<Response> requestOTP({required String email}) async {
    final response = await _dio.get('/otp', data: {'email': email});
    return response;
  }

  Future<Response> resetPassword({
    required String newPassword,
    required String otp,
    required String email,
  }) async {
    final response = await _dio.post(
      '/reset-password',
      data: {'password': newPassword, 'otp': otp, email: email},
    );
    return response;
  }
}
