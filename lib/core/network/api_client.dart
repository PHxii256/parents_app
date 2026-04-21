import 'package:dio/dio.dart';
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
  )..interceptors.add(
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
    );
}
