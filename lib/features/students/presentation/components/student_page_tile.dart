import 'package:flutter/material.dart';
import 'package:parent_app/features/absence/data/student_data.dart';
import 'package:parent_app/features/students/presentation/components/contact_parents_tile.dart';
import 'package:parent_app/features/students/presentation/components/student_page_info_tile.dart';
import 'package:parent_app/features/students/presentation/components/student_page_tile_status.dart';

class StudentPageTile extends StatelessWidget {
  final StudentData student;
  final VoidCallback? onLocationTap;
  final bool boardedBus;
  final bool droppedOff;
  final ValueChanged<bool>? onBoardedChanged;
  final ValueChanged<bool>? onDroppedOffChanged;
  const StudentPageTile({
    super.key,
    required this.student,
    this.onLocationTap,
    this.boardedBus = false,
    this.droppedOff = false,
    this.onBoardedChanged,
    this.onDroppedOffChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StudentPageInfoTile(studentData: student),
        SizedBox(height: 4),
        ContactParentsTile(onLocationTap: onLocationTap),
        SizedBox(height: 4),
        StudentPageTileStatus(
          studentName: student.name,
          boardedBus: boardedBus,
          droppedOff: droppedOff,
          onBoardedChanged: onBoardedChanged,
          onDroppedOffChanged: onDroppedOffChanged,
        ),
      ],
    );
  }
}
