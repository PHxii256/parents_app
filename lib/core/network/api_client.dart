import 'package:dio/dio.dart';
import 'package:parent_app/core/config/api_config.dart';
import 'package:parent_app/features/auth/data/services/jwt_storage.dart';

class ApiClient {
  ApiClient._();

  static final JwtStorage _jwtStorage = JwtStorage();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 8),
      sendTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      headers: {'Accept': 'application/json'},
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final tokens = await _jwtStorage.load();
          if (tokens != null) {
            options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 403) {
            _jwtStorage.clear();
          }
          // Placeholder for refresh-token retry flow once backend refresh endpoint is defined.
          handler.next(error);
        },
      ),
    );
}
