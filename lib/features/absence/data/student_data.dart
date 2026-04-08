class StudentData {
  final int id;
  final String name;
  final String grade;
  final List<String> pinCodes;
  final String address;
  final String gMapsLink;
  final String? status;
  StudentData({
    required this.id,
    required this.name,
    required this.grade,
    required this.pinCodes,
    required this.address,
    required this.gMapsLink,
    this.status,
  });

  static final List<StudentData> mockStudentData = [
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
      address: 'Street 9 Maadi, Building 31 Next to Mc\'cdonalds And Metro El-Maadi',
      gMapsLink: 'https://maps.app.goo.gl/wGzN3oaVeLaKTMHo6',
    ),
  ];
}
