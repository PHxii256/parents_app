import 'package:parent_app/l10n/app_localizations.dart';
import 'package:latlong2/latlong.dart';

class StudentData {
  final int id;
  final String name;
  final String grade;
  final List<String> pinCodes;
  final String address;
  final String gMapsLink;
  final List<String> coords;
  final String? status;
  StudentData({
    required this.id,
    required this.name,
    required this.grade,
    required this.pinCodes,
    required this.address,
    required this.gMapsLink,
    required this.coords,
    this.status,
  });

  static final List<StudentData> mockStudentData = [
    StudentData(
      id: 1,
      name: "Ahmed Mohsen",
      grade: "Grade 2",
      pinCodes: ["12345", "67890"],
      address: '123 Maple Street',
      gMapsLink: 'https://maps.app.goo.gl/DymUiMNdKbPPAVGe7',
      coords: ["29.972273", "30.943277"],
    ),
    StudentData(
      id: 3,
      name: "Fatma Ali",
      grade: "Grade 1",
      pinCodes: ["54563", "12642"],
      address: 'Street 9 Maadi, Building 31 Next to Mc\'cdonalds And Metro El-Maadi',
      gMapsLink: 'https://maps.app.goo.gl/6krL3XuvmKCF7Lcz7',
      coords: ["29.964891", "30.958971"],
    ),
  ];

  String localizedGrade(AppLocalizations localizations) {
    final match = RegExp(r'\d+').firstMatch(grade);
    if (match == null) {
      return grade;
    }
    return localizations.gradeWithNumber(match.group(0)!);
  }

  LatLng? toLatLng() {
    if (coords.length < 2) {
      return null;
    }
    final latitude = double.tryParse(coords[0]);
    final longitude = double.tryParse(coords[1]);
    if (latitude == null || longitude == null) {
      return null;
    }
    return LatLng(latitude, longitude);
  }
}
