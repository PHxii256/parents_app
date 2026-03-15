import 'package:flutter/material.dart';
import 'package:parent_app/features/home/presentation/components/address_tile.dart';
import 'package:parent_app/l10n/app_localizations.dart';

class NextPickupTile extends StatelessWidget {
  const NextPickupTile({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return AddressTile(
      addressName: localizations.homeAddressName,
      addressDesc: localizations.homeAddressDesc,
      trailing: localizations.nextPickup,
    );
  }
}
