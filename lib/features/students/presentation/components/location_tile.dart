import 'package:flutter/material.dart';
import 'package:parent_app/features/home/presentation/components/parent/trip_panel.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';

class LocationTile extends StatelessWidget {
  final String? name;
  final IconData? icon;
  final VoidCallback? onLocationTap;
  const LocationTile({super.key, this.name, this.icon, this.onLocationTap});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 12,
          children: [
            IconBox(icon: icon ?? Icons.pin_drop, height: 48),
            Text(
              name ?? 'Victory College ${localizations.schoolSuffix}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, height: 0.95),
            ),
          ],
        ),
        SizedBox.square(
          dimension: 36,
          child: CircularActionButton(
            icon: Icons.location_pin,
            size: 16,
            onTap: onLocationTap,
          ),
        ),
      ],
    );
  }
}
