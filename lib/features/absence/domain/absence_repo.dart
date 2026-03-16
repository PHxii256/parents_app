import '../data/apiService.dart';

class AbsenceRepository {

  final FakeApiService apiService;

  AbsenceRepository(this.apiService);

  Future<void> markAbsent(List<int> studentIds) async {
    await apiService.markAbsent(studentIds);
  }

  Future<void> undoAbsence(List<int> studentIds) async {
    await apiService.undoAbsent(studentIds);
  }
}