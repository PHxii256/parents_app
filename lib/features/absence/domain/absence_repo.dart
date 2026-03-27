import '../data/api_service.dart';
import '../data/student_data.dart';

class AbsenceRepository {
  final FakeApiService api;

  AbsenceRepository(this.api);

  Future<void> markAbsent(List<int> ids, DateTime date) async {
    await api.markAbsent(ids, date);
  }

  Future<void> undoAbsence(List<int> ids, DateTime date) async {
    await api.undoAbsent(ids, date);
  }
}
