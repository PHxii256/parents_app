import 'package:flutter/material.dart';
import 'package:parent_app/core/utils/truncate_text.dart';
import 'package:parent_app/shared/theme/app_colors.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';

class StudentInfoTile extends StatelessWidget {
  final String name;
  final String grade;
  final List<String> pinCodes;
  final String address;
  const StudentInfoTile({
    super.key,
    required this.name,
    required this.grade,
    required this.pinCodes,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
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
                        name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, height: 0.95),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 6,
                    children: [
                      Text(
                        grade,
                        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15, height: 0.975),
                      ),
                      Text(
                        "•",
                        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15, height: 0.975),
                      ),
                      Text(
                        "PIN codes:",
                        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15, height: 0.975),
                      ),
                      ...pinCodes.map(
                        (pin) => Text(
                          pin,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                            height: 0.975,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    truncateText(address),
                    style: TextStyle(color: AppColors.highlightText, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
