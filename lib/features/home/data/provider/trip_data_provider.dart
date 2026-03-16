import 'package:dio/dio.dart';
import 'package:parent_app/core/models/server_exception.dart';

class TripDataProvider {
  final _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5000'));

  Future<Response> getCurrentTrip() async {
    try {
      final response = await _dio.get('/trip/current');
      return response;
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Network error');
    }
  }
}
