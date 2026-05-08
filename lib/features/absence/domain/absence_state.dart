import 'package:equatable/equatable.dart';

class AbsenceChild {
  final int id;
  final String name;
  final String grade;

  const AbsenceChild({required this.id, required this.name, required this.grade});
}

class AbsenceState extends Equatable {
  final List<AbsenceChild> children;
  final List<int> selectedChildrenIds;
  final List<int> absentChildrenIds;
  final bool isLoading;
  final String? errorMessage;
  final DateTime? absenceDate;

  const AbsenceState({
    this.children = const [],
    this.selectedChildrenIds = const [],
    this.absentChildrenIds = const [],
    this.isLoading = false,
    this.errorMessage,
    this.absenceDate,
  });

  AbsenceState copyWith({
    List<AbsenceChild>? children,
    List<int>? selectedChildrenIds,
    List<int>? absentChildrenIds,
    bool? isLoading,
    String? errorMessage,
    DateTime? absenceDate,
  }) {
    return AbsenceState(
      children: children ?? this.children,
      selectedChildrenIds: selectedChildrenIds ?? this.selectedChildrenIds,
      absentChildrenIds: absentChildrenIds ?? this.absentChildrenIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      absenceDate: absenceDate ?? this.absenceDate,
    );
  }

  @override
  List<Object?> get props => [
    children,
    selectedChildrenIds,
    absentChildrenIds,
    isLoading,
    errorMessage,
    absenceDate,
  ];
}
