import 'package:flutter/material.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'address_tile.dart';

class TripStatus extends StatelessWidget {
  const TripStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations.tripStatusTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
            Row(
              spacing: 8,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                  child: SizedBox(width: 14, height: 14),
                ),
                Text(
                  localizations.noTripCurrently,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
        AddressTile(
          addressName: localizations.homeAddressName,
          addressDesc: localizations.homeAddressDesc,
          trailing: localizations.nextPickup,
        ),
      ],
    );
  }
}
