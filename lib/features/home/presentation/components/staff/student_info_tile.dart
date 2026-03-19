import 'package:flutter/material.dart';
import 'package:parent_app/core/utils/truncate_text.dart';
import 'package:parent_app/features/absence/data/student_data.dart';
import 'package:parent_app/shared/theme/app_colors.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';

class StudentInfoTile extends StatelessWidget {
  final StudentData studentData;
  const StudentInfoTile({super.key, required this.studentData});

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 15, height: 0.975);
    return LayoutBuilder(
      builder: (context, constraints) {
        final iconHeight = constraints.maxHeight.isFinite ? constraints.maxHeight : 48.0;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IconBox(icon: Icons.person, width: 48, height: iconHeight, iconSize: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  spacing: 4,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 6,
                      children: [
                        Text(
                          studentData.name,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, height: 0.95),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 6,
                      children: [
                        Text(studentData.grade, style: textStyle),
                        Text("•", style: textStyle),
                        Text("PIN codes:", style: textStyle),
                        ...studentData.pinCodes.map((pin) => Text(pin, style: textStyle)),
                      ],
                    ),
                    Text(
                      truncateText(studentData.address),
                      style: TextStyle(color: AppColors.highlightText, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
