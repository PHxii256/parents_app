import 'package:dio/dio.dart';
import 'package:parent_app/core/config/api_config.dart';
import 'package:parent_app/core/network/api_client.dart';

abstract class AbsenceApiService {
  Future<void> markAbsent(List<int> ids, DateTime date);
  Future<void> undoAbsent(List<int> ids, DateTime date);
}

class FakeApiService implements AbsenceApiService {
  @override
  Future<void> markAbsent(List<int> ids, DateTime date) async {
    await Future.delayed(Duration(seconds: 1));
    print("Marked absent: $ids at $date");
  }

  @override
  Future<void> undoAbsent(List<int> ids, DateTime date) async {
    await Future.delayed(Duration(seconds: 1));
    print("Undo absent: $ids at $date");
  }
}

class RealAbsenceApiService implements AbsenceApiService {
  final Dio _dio;

  RealAbsenceApiService({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  @override
  Future<void> markAbsent(List<int> ids, DateTime date) async {
    await _dio.post(
      '/api/v1/absence',
      data: {
        'student_ids': ids,
        'date': date.toIso8601String().split('T').first,
      },
    );
  }

  @override
  Future<void> undoAbsent(List<int> ids, DateTime date) async {
    await _dio.delete(
      '/api/v1/absence',
      data: {
        'student_ids': ids,
        'date': date.toIso8601String().split('T').first,
      },
    );
  }
}

AbsenceApiService buildAbsenceApiService() {
  if (ApiConfig.useRealApi) {
    return RealAbsenceApiService();
  }
  return FakeApiService();
}
