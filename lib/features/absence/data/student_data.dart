import 'package:parent_app/l10n/app_localizations.dart';
import 'package:latlong2/latlong.dart';

/// Guardian latest message snippet from roster API or realtime.
class StudentLatestMessage {
  final String content;
  final DateTime? createdAt;

  const StudentLatestMessage({required this.content, this.createdAt});

  static StudentLatestMessage? tryParse(dynamic raw) {
    if (raw == null) return null;
    if (raw is String) {
      final s = raw.trim();
      if (s.isEmpty) return null;
      return StudentLatestMessage(content: s);
    }
    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      final text = map['content']?.toString().trim() ?? '';
      if (text.isEmpty) return null;
      final createdRaw = map['createdAt'] ?? map['created_at'];
      DateTime? created;
      if (createdRaw != null) {
        created = DateTime.tryParse(createdRaw.toString());
      }
      return StudentLatestMessage(content: text, createdAt: created);
    }
    return null;
  }

  /// `content · N min ago` (or plain [content] if no timestamp), for assistant tiles.
  String assistantDisplayLine([DateTime? clock]) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return '';
    final at = createdAt;
    if (at == null) return trimmed;
    return '$trimmed · ${_minutesAgo(at, clock ?? DateTime.now())}';
  }

  static String _minutesAgo(DateTime createdAt, DateTime now) {
    final local = createdAt.isUtc ? createdAt.toLocal() : createdAt;
    var elapsed = now.difference(local);
    if (elapsed.isNegative) elapsed = Duration.zero;
    final minutes = elapsed.inMinutes;
    if (minutes < 1) return 'now';
    return '$minutes min ago';
  }
}

class StudentData {
  final int id;
  final String name;
  final String grade;
  final List<String> pinCodes;
  final String address;
  final String gMapsLink;
  final List<String> coords;
  final String? status;
  /// Latest guardian message from GET `/routes/students` when provided (string or object).
  final StudentLatestMessage? latestMessage;
  StudentData({
    required this.id,
    required this.name,
    required this.grade,
    required this.pinCodes,
    required this.address,
    required this.gMapsLink,
    required this.coords,
    this.status,
    this.latestMessage,
  });

  static final List<StudentData> mockStudentData = [
    StudentData(
      id: 1,
      name: "Ahmed Mohsen",
      grade: "Grade 2",
      pinCodes: ["12345", "67890"],
      address: 'Abrag Othman, Building 3, Maadi.',
      gMapsLink: 'https://maps.app.goo.gl/7E59oVXWJmU6c5nG9',
      coords: ["29.9651415", "31.2443606"],
    ),
    StudentData(
      id: 3,
      name: "Fatma Ali",
      grade: "Grade 1",
      pinCodes: ["54563", "12642"],
      address: 'Street 9 Maadi, Building 31 Next to Metro El-Maadi',
      gMapsLink: 'https://maps.app.goo.gl/RgV5r59XV5FxAGwL8',
      coords: ["29.9606911", "31.2578564"],
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
