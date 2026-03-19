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
    final resolvedHeight = height.isFinite ? height : 48.0;
    final resolvedWidth = (width != null && width!.isFinite) ? width! : resolvedHeight;
    final resolvedIconSize = (iconSize != null && iconSize!.isFinite)
        ? iconSize!
        : resolvedHeight / 2;

    return Material(
      color: AppColors.mutedBg,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        splashColor: AppColors.highlightText.withAlpha(60),
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: resolvedWidth,
          height: resolvedHeight,
          child: Icon(icon, size: resolvedIconSize, color: AppColors.onSurfaceDark),
        ),
      ),
    );
  }
}
