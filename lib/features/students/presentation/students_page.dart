import 'package:flutter/material.dart';
import 'package:parent_app/features/absence/data/student_data.dart';
import 'package:parent_app/features/students/presentation/components/location_tile.dart';
import 'package:parent_app/features/students/presentation/components/student_page_search.dart';
import 'package:parent_app/features/students/presentation/components/track_segment.dart';
import 'package:parent_app/features/students/presentation/components/student_page_tile.dart';
//import 'package:parent_app/l10n/app_localizations.dart';

class StudentsPage extends StatelessWidget {
  const StudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    //final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            centerTitle: true,
            title: Text("Students", style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          StudentPageSearch(),
          SizedBox(height: 18),
          LocationTile(),
          TrackSegment(height: 32, padding: const EdgeInsets.fromLTRB(22, 0, 0, 6)),
          StudentPageTile(student: StudentData.mockStudentData[0]),
          TrackSegment(),
          StudentPageTile(student: StudentData.mockStudentData[1]),
        ],
      ),
    );
  }
}
