import 'package:flutter/material.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class AttendanceStatusCircle extends StatelessWidget {
  final Color? color;
  final IconData? icon;
  const AttendanceStatusCircle({super.key, this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color ?? AppColors.highlightText, shape: BoxShape.circle),
      child: SizedBox(
        height: 28,
        width: 28,
        child: Icon(icon ?? Icons.check, size: 20, color: Colors.white),
      ),
    );
  }
}
