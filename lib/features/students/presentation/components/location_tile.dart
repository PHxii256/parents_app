import 'package:flutter/material.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';

class LocationTile extends StatelessWidget {
  final String? name;
  final IconData? icon;
  const LocationTile({super.key, this.name, this.icon});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      spacing: 12,
      children: [
        IconBox(icon: icon ?? Icons.pin_drop, height: 48),
        Text(
          name ?? 'Victory College ${localizations.schoolSuffix}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, height: 0.95),
        ),
      ],
    );
  }
}
