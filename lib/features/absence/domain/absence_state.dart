import 'package:equatable/equatable.dart';

class AbsenceState extends Equatable {
  final List<int> selectedChildrenIds;
  final List<int> absentChildrenIds;
  final bool isLoading;
  final String? errorMessage;
  final DateTime? absenceDate;

  const AbsenceState({
    this.selectedChildrenIds = const [],
    this.absentChildrenIds = const [],
    this.isLoading = false,
    this.errorMessage,
    this.absenceDate,
  });

  AbsenceState copyWith({
    List<int>? selectedChildrenIds,
    List<int>? absentChildrenIds,
    bool? isLoading,
    String? errorMessage,
    DateTime? absenceDate,
  }) {
    return AbsenceState(
      selectedChildrenIds: selectedChildrenIds ?? this.selectedChildrenIds,
      absentChildrenIds: absentChildrenIds ?? this.absentChildrenIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      absenceDate: absenceDate ?? this.absenceDate,
    );
  }

  @override
  List<Object?> get props => [
    selectedChildrenIds,
    absentChildrenIds,
    isLoading,
    errorMessage,
    absenceDate,
  ];
}
