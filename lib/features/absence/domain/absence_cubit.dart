import 'package:flutter_bloc/flutter_bloc.dart';

import 'absence_repo.dart';
import 'absence_state.dart';

class AbsenceCubit extends Cubit<AbsenceState> {
  final AbsenceRepository _repository;

  AbsenceCubit(this._repository) : super(const AbsenceState());

  // Select or deselect a student
  void toggleSelectChild(int childId) {
    final current = List<int>.from(state.selectedChildrenIds);
    if (current.contains(childId)) {
      current.remove(childId);
    } else {
      current.add(childId);
    }
    emit(state.copyWith(selectedChildrenIds: current));
  }

  // Mark selected students as absent
  Future<void> markAbsent() async {
    if (state.selectedChildrenIds.isEmpty) return;

    emit(state.copyWith(isLoading: true));

    try {
      await _repository.markAbsent(state.selectedChildrenIds);

      final updatedAbsent = List<int>.from(state.absentChildrenIds)
        ..addAll(state.selectedChildrenIds);

      emit(state.copyWith(
        absentChildrenIds: updatedAbsent,
        selectedChildrenIds: [],
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to mark absence',
      ));
    }
  }

  // Undo absence for a single student
  Future<void> undoAbsence(int childId) async {
    emit(state.copyWith(isLoading: true));

    try {
      await _repository.undoAbsence([childId]);

      final updatedAbsent =
      state.absentChildrenIds.where((id) => id != childId).toList();

      emit(state.copyWith(
        absentChildrenIds: updatedAbsent,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to undo absence',
      ));
    }
  }
}