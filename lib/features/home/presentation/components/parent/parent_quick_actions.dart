import 'package:flutter/material.dart';
import 'package:parent_app/features/absence/presentation/absence_page.dart';
import 'package:parent_app/features/change_request/presentation/change_request_page.dart';
import 'package:parent_app/features/pin_code/presentation/pin_code_page.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';

class ParentQuickActions extends StatelessWidget {
  const ParentQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
        Row(
          spacing: 8,
          children: [
            Column(
              spacing: 6,
              children: [
                IconBox(
                  icon: Icons.key,
                  width: 80,
                  height: 80,
                  iconSize: 32,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => PinCodePage()));
                  },
                ),
                Text(
                  localizations.pinCodeTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            Column(
              spacing: 6,
              children: [
                IconBox(
                  icon: Icons.calendar_month,
                  width: 80,
                  height: 80,
                  iconSize: 32,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => AbsencePage()));
                  },
                ),
                Text(
                  localizations.absenceTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            Expanded(
              child: Column(
                spacing: 6,
                children: [
                  IconBox(
                    icon: Icons.pin_drop,
                    height: 80,
                    iconSize: 32,
                    width: double.maxFinite,
                    onTap: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => ChangeRequestPage()));
                    },
                  ),
                  Text(
                    localizations.changePickupDropoff,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
