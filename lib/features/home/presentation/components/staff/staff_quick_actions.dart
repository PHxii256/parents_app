import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:parent_app/features/home/presentation/components/staff/rounded_cta_button.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';

class StaffQuickActions extends StatelessWidget {
  const StaffQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const labelStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    const firstLabel = "Mark Present/Absent";
    const secondLabel = "Open In Google Maps";

    double measureLabelWidth(String text) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: labelStyle),
        textDirection: Directionality.of(context),
        maxLines: 1,
      )..layout();
      return painter.width;
    }

    final maxLabelWidth = math.max(measureLabelWidth(firstLabel), measureLabelWidth(secondLabel));
    final minTileWidth = maxLabelWidth + 24;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.quickActionsTitle,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
              RoundedCtaButton(),
            ],
          ),
        ),

        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 8.0;
            final equalWidth = (constraints.maxWidth - spacing) / 2;
            final tileWidth = math.max(equalWidth, minTileWidth);

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                SizedBox(
                  width: tileWidth,
                  child: Column(
                    spacing: 6,
                    children: [
                      Row(
                        spacing: 6,
                        children: [
                          Expanded(
                            child: IconBox(
                              icon: Icons.check_circle_outline,
                              width: (tileWidth - 2) / 2,
                              height: 80,
                              iconSize: 32,
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            child: IconBox(
                              icon: Icons.cancel_outlined,
                              width: (tileWidth - 2) / 2,
                              height: 80,
                              iconSize: 32,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      Text(firstLabel, style: labelStyle),
                    ],
                  ),
                ),
                SizedBox(
                  width: tileWidth,
                  child: Column(
                    spacing: 6,
                    children: [
                      IconBox(
                        icon: Icons.navigation_outlined,
                        height: 80,
                        iconSize: 32,
                        width: tileWidth,
                        onTap: () {},
                      ),
                      Text(secondLabel, style: labelStyle),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
