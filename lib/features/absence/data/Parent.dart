class Student {
  final int id;
  final String name;
  final String grade;

  Student({required this.id, required this.name, required this.grade});
}

// Example Parent account
final Parent currentParent = Parent(
  id: 1,
  name: "Ali Hassan",
  students: [
    Student(id: 1, name: "Ahmed Mohsen", grade: "Grade 2"),
    Student(id: 3, name: "Fatma Ali", grade: "Grade 1"),
  ],
);

class Parent {
  final int id;
  final String name;
  final List<Student> students;

  Parent({required this.id, required this.name, required this.students});
}
