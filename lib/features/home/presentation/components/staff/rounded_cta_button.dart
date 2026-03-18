import 'package:flutter/material.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class RoundedCtaButton extends StatelessWidget {
  const RoundedCtaButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.mutedBgDark),
        onPressed: () {},
        child: Text(
          "End Trip",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurfaceDark,
          ),
        ),
      ),
    );
  }
}
