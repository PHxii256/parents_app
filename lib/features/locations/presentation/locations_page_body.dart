import 'package:flutter/material.dart';
import 'package:parent_app/l10n/app_localizations.dart';

class LocationsPage extends StatelessWidget {
  const LocationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        AppBar(
          centerTitle: true,
          title: Text(
            localizations.locationsTab,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
