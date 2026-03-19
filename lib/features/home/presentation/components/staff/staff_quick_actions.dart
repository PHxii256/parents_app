import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:parent_app/shared/widgets/rounded_cta_button.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';

class StaffQuickActions extends StatelessWidget {
  const StaffQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const labelStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    const firstLabelAM = "Mark Present/Absent";
    const firstLabelPM = "Confirm Drop-off";
    const secondLabel = "Open In Google Maps";
    // depends on if it's am or pm trip
    final bool am = true;
    String getCurrentFirstLabel() {
      // ignore: dead_code
      return am ? firstLabelAM : firstLabelPM;
    }

    double measureLabelWidth(String text) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: labelStyle),
        textDirection: Directionality.of(context),
        maxLines: 1,
      )..layout();
      return painter.width;
    }

    final maxLabelWidth = math.max(
      measureLabelWidth(getCurrentFirstLabel()),
      measureLabelWidth(secondLabel),
    );
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
              RoundedCtaButton(text: "End Trip"),
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
                      // ignore: dead_code
                      am ? _AmActions(tileWidth: tileWidth) : _PmActions(tileWidth: tileWidth),
                      Text(getCurrentFirstLabel(), style: labelStyle),
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

class _AmActions extends StatelessWidget {
  const _AmActions({super.key, required this.tileWidth});

  final double tileWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class _PmActions extends StatelessWidget {
  const _PmActions({super.key, required this.tileWidth});

  final double tileWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
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
      ],
    );
  }
}
