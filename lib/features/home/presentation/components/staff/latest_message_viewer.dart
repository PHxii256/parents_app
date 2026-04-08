import 'package:flutter/material.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class LatestMessageViewer extends StatelessWidget {
  const LatestMessageViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: AppColors.mutedBg, borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 0, 0),
        child: Text("No New Messages.", style: TextStyle(color: AppColors.brownBg)),
      ),
    );
  }
}
