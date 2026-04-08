import 'package:flutter/material.dart';
import 'package:parent_app/features/absence/data/student_data.dart';
import 'package:parent_app/features/students/presentation/components/contact_parents_tile.dart';
import 'package:parent_app/features/students/presentation/components/student_page_info_tile.dart';
import 'package:parent_app/features/students/presentation/components/student_page_tile_status.dart';

class StudentPageTile extends StatelessWidget {
  final StudentData student;
  const StudentPageTile({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StudentPageInfoTile(studentData: student),
        SizedBox(height: 4),
        ContactParentsTile(),
        SizedBox(height: 4),
        StudentPageTileStatus(studentName: student.name),
      ],
    );
  }
}
