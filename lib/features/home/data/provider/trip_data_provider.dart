import 'package:dio/dio.dart';
import 'package:parent_app/core/network/api_client.dart';
import 'package:parent_app/core/models/server_exception.dart';

class TripDataProvider {
  final Dio _dio;

  TripDataProvider({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  Future<Response> getCurrentTrip() async {
    try {
      final response = await _dio.get('/api/v1/trips/current');
      return response;
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Network error');
    }
  }

  Future<Response> startTrip() async {
    try {
      return await _dio.post('/api/v1/trips/start');
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Network error');
    }
  }

  Future<Response> updateLocation(List<double> currentCoords) async {
    try {
      return await _dio.post('/api/v1/trips/location', data: {'currentCoords': currentCoords});
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Network error');
    }
  }

  Future<Response> getActiveTrip() async {
    try {
      return await _dio.get('/api/v1/trips/active');
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Network error');
    }
  }

  Future<Response> endTrip() async {
    try {
      return await _dio.post('/api/v1/trips/end');
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Network error');
    }
  }
}
