import 'package:parent_app/features/students/data/models/route_student_item.dart';

class StudentsState {
  final bool loading;
  final String direction;
  final List<RouteStudentItem> students;
  final Map<String, String> statuses;
  final Map<String, String> latestMessages;
  final String? error;

  const StudentsState({
    this.loading = false,
    this.direction = 'am',
    this.students = const [],
    this.statuses = const {},
    this.latestMessages = const {},
    this.error,
  });

  StudentsState copyWith({
    bool? loading,
    String? direction,
    List<RouteStudentItem>? students,
    Map<String, String>? statuses,
    Map<String, String>? latestMessages,
    String? error,
    bool clearError = false,
  }) {
    return StudentsState(
      loading: loading ?? this.loading,
      direction: direction ?? this.direction,
      students: students ?? this.students,
      statuses: statuses ?? this.statuses,
      latestMessages: latestMessages ?? this.latestMessages,
      error: clearError ? null : error ?? this.error,
    );
  }
}
