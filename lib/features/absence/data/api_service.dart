//import 'package:dio/dio.dart';

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
  Future<void> markAbsent(List<int> ids, DateTime date) async {
    await Future.delayed(Duration(seconds: 1));
    print("Marked absent: $ids at $date");
  }

  Future<void> undoAbsent(List<int> ids, DateTime date) async {
    await Future.delayed(Duration(seconds: 1));
    print("Undo absent: $ids at $date");
  }
}
