import 'package:flutter/material.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class RoundedCtaButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final double height;

  const RoundedCtaButton({super.key, required this.text, this.icon, this.height = 30});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mutedBgDark,
          padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            icon != null
                ? Transform.translate(
                    offset: Offset(0, 1),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: Icon(icon, size: 16),
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(width: text.isNotEmpty ? 4 : 0),
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurfaceDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
