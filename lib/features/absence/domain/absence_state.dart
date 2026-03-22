import 'package:equatable/equatable.dart';

class AbsenceState extends Equatable {
  final List<int> selectedChildrenIds; // currently selected for absence
  final List<int> absentChildrenIds;   // already marked absent
  final bool isLoading;
  final String? errorMessage;

  const AbsenceState({
    this.selectedChildrenIds = const [],
    this.absentChildrenIds = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  AbsenceState copyWith({
    List<int>? selectedChildrenIds,
    List<int>? absentChildrenIds,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AbsenceState(
      selectedChildrenIds: selectedChildrenIds ?? this.selectedChildrenIds,
      absentChildrenIds: absentChildrenIds ?? this.absentChildrenIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [selectedChildrenIds, absentChildrenIds, isLoading, errorMessage];
}