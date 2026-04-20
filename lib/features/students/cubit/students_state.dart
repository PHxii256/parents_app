import 'package:parent_app/features/students/data/models/route_student_item.dart';

class StudentsState {
  final bool loading;
  final String direction;
  final List<RouteStudentItem> students;
  final Map<String, String> statuses;
  final String? error;

  const StudentsState({
    this.loading = false,
    this.direction = 'am',
    this.students = const [],
    this.statuses = const {},
    this.error,
  });

  StudentsState copyWith({
    bool? loading,
    String? direction,
    List<RouteStudentItem>? students,
    Map<String, String>? statuses,
    String? error,
    bool clearError = false,
  }) {
    return StudentsState(
      loading: loading ?? this.loading,
      direction: direction ?? this.direction,
      students: students ?? this.students,
      statuses: statuses ?? this.statuses,
      error: clearError ? null : error ?? this.error,
    );
  }
}
