import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/absence/domain/request_state.dart';

import 'absence_repo.dart';
import 'absence_state.dart';

class AbsenceCubit extends Cubit<AbsenceState> {

  final AbsenceRepository repository;

  AbsenceCubit(this.repository) : super(AbsenceState.initial());

  Future<void> toggleAbsence(List<int>studentIds) async {

    emit(state.copyWith(status: RequestStatus.loading));

    try {

      if (state.isAbsent) {

        await repository.undoAbsence(studentIds);

        emit(
          state.copyWith(
            isAbsent: false,
            status: RequestStatus.success,
          ),
        );

      } else {

        await repository.markAbsent(studentIds);

        emit(
          state.copyWith(
            isAbsent: true,
            status: RequestStatus.success,
          ),
        );

      }

    } catch (e) {

      emit(
        state.copyWith(
          status: RequestStatus.error,
          message: "Something went wrong",
        ),
      );

    }
  }
}