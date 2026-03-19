import 'package:flutter/material.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class TrackSegment extends StatelessWidget {
  final EdgeInsets? padding;
  final double? height;
  const TrackSegment({super.key, this.padding, this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 22.0, vertical: 6),
      child: SizedBox(
        height: height ?? 18,
        width: 6,
        child: DecoratedBox(decoration: BoxDecoration(color: AppColors.mutedBgDark)),
      ),
    );
  }
}
