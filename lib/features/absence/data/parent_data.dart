import 'package:parent_app/features/absence/data/student_data.dart';

class ParentData {
  final int id;
  final String name;
  final List<StudentData> students;

  ParentData({required this.id, required this.name, required this.students});
}

// Example Parent account
final ParentData currentParent = ParentData(
  id: 1,
  name: "Ali Hassan",
  students: [StudentData.mockStudentData.first, StudentData.mockStudentData.last],
);
