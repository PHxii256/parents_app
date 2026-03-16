import 'package:dio/dio.dart';

// class ApiService {
//   final Dio dio;
//
//   ApiService(this.dio);

//   Future<Response> markAbsent(List<int> studentIds) async {
//     return await dio.post(
//       "/absence",
//       data: {
//         "student_id": studentIds,
//         "date": "2026-03-16"
//       },
//     );
//   }
//
//   Future<Response> undoAbsent(List<int> studentIds) async {
//     return await dio.delete(
//       "/absence/$studentIds",
//       data: {
//         "date": "2026-03-16" // fake date
//       },
//     );
//   }
// }
class FakeApiService {
  Future<void> markAbsent(List<int> studentIds) async {
    await Future.delayed(const Duration(seconds: 1));
    // simulate success
    return;
  }

  Future<void> undoAbsent(List<int> studentIds) async {
    await Future.delayed(const Duration(seconds: 1));
    // simulate success
    return;
  }
}