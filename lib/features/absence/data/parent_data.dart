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
  students: [
    StudentData(
      id: 1,
      name: "Ahmed Mohsen",
      grade: "Grade 2",
      pinCodes: ["12345", "67890"],
      address: '123 Maple Street',
      gMapsLink: 'https://maps.app.goo.gl/wGzN3oaVeLaKTMHo6',
    ),
    StudentData(
      id: 3,
      name: "Fatma Ali",
      grade: "Grade 1",
      pinCodes: ["54563", "12642"],
      address: 'Street 9 Maadi',
      gMapsLink: 'https://maps.app.goo.gl/wGzN3oaVeLaKTMHo6',
    ),
  ],
);

