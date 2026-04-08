import 'package:flutter/material.dart';
import 'package:parent_app/features/absence/data/student_data.dart';
import 'package:parent_app/shared/theme/app_colors.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';

class StudentPageInfoTile extends StatelessWidget {
  final StudentData studentData;
  const StudentPageInfoTile({super.key, required this.studentData});

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 15, height: 0.975);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 72),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IconBox(icon: Icons.person, width: 48, height: double.infinity, iconSize: 24),
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
                      studentData.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: AppColors.highlightText, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Hypertext extends StatelessWidget {
  const Hypertext({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        Text(
          "View in Google Maps",
          style: TextStyle(
            color: AppColors.highlightText,
            fontSize: 15,
            height: 0.975,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.highlightText,
            decorationThickness: 2,
          ),
        ),
        Icon(Icons.open_in_new, size: 15, color: AppColors.highlightText),
      ],
    );
  }
}
