import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/students/cubit/students_state.dart';
import 'package:parent_app/features/students/data/repositories/students_repository.dart';

class StudentsCubit extends Cubit<StudentsState> {
  final StudentsRepository _studentsRepository;

  StudentsCubit({StudentsRepository? studentsRepository})
    : _studentsRepository = studentsRepository ?? StudentsRepository(),
      super(const StudentsState());

  Future<void> loadStudents({String? direction}) async {
    final targetDirection = direction ?? state.direction;
    emit(state.copyWith(loading: true, direction: targetDirection, clearError: true));
    try {
      final students = await _studentsRepository.fetchRouteStudents(direction: targetDirection);
      emit(state.copyWith(loading: false, students: students, clearError: true));
    } catch (e) {
      emit(state.copyWith(loading: false, error: 'Failed to load students.'));
    }
  }

  Future<void> markBoarded(String studentId) async {
    final ok = await _studentsRepository.markBoarded(studentId);
    if (!ok) return;
    final updated = Map<String, String>.from(state.statuses);
    updated[studentId] = 'boarded';
    emit(state.copyWith(statuses: updated));
  }

  Future<void> markDroppedOff(String studentId) async {
    final ok = await _studentsRepository.markDroppedOff(studentId);
    if (!ok) return;
    final updated = Map<String, String>.from(state.statuses);
    updated[studentId] = 'dropped-off';
    emit(state.copyWith(statuses: updated));
  }
}
