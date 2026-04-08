import 'package:flutter/material.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';

class StaffQuickActions extends StatelessWidget {
  final VoidCallback? onDone;

  const StaffQuickActions({super.key, this.onDone});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const labelStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    final openMapsLabel = localizations.staffOpenInGoogleMaps;
    final endTripLabel = localizations.staffEndTrip;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            localizations.quickActionsTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
          ),
        ),

        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 8.0;
            final availableWidth = constraints.maxWidth - spacing;
            final mapsTileWidth = availableWidth * (2 / 3);
            final endTripTileWidth = availableWidth - mapsTileWidth;

            return Row(
              children: [
                SizedBox(
                  width: endTripTileWidth,
                  child: Column(
                    spacing: 6,
                    children: [
                      IconBox(
                        icon: Icons.check_circle_outline,
                        height: 80,
                        iconSize: 32,
                        width: endTripTileWidth,
                        onTap: onDone,
                      ),
                      Text(endTripLabel, style: labelStyle),
                    ],
                  ),
                ),
                const SizedBox(width: spacing),

                SizedBox(
                  width: mapsTileWidth,
                  child: Column(
                    spacing: 6,
                    children: [
                      IconBox(
                        icon: Icons.navigation_outlined,
                        height: 80,
                        iconSize: 32,
                        width: mapsTileWidth,
                        onTap: () {},
                      ),
                      Text(openMapsLabel, style: labelStyle),
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
