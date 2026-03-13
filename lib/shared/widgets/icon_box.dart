import 'package:flutter/material.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class IconBox extends StatelessWidget {
  final IconData icon;
  final double height;
  final double? width;
  final double? iconSize;
  final void Function()? onTap;

  const IconBox({
    super.key,
    required this.icon,
    required this.height,
    this.width,
    this.iconSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.mutedBg,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        splashColor: Colors.amber.withAlpha(60),
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: width ?? height,
          height: height,
          child: Icon(icon, size: iconSize ?? height / 2),
        ),
      ),
    );
  }
}
