import 'package:flutter/material.dart';
import 'package:parent_app/features/absence/data/student_data.dart';
import 'package:parent_app/features/students/presentation/components/location_tile.dart';
import 'package:parent_app/features/students/presentation/components/student_page_search.dart';
import 'package:parent_app/features/students/presentation/components/track_segment.dart';
import 'package:parent_app/features/students/presentation/components/student_page_tile.dart';
import 'package:parent_app/l10n/app_localizations.dart';

class StudentsPage extends StatelessWidget {
  const StudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            centerTitle: true,
            title: Text(
              localizations.students,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const StudentPageSearch(),
          const SizedBox(height: 18),
          const LocationTile(),
          const TrackSegment(height: 32, padding: EdgeInsets.fromLTRB(22, 0, 22, 0)),
          StudentPageTile(student: StudentData.mockStudentData[0]),
          const TrackSegment(),
          StudentPageTile(student: StudentData.mockStudentData[1]),
        ],
      ),
    );
  }
}
