import 'package:flutter/material.dart';
import 'package:parent_app/features/absence/presentation/absence_page.dart';
import 'package:parent_app/features/change_request/presentation/change_request_page.dart';
import 'package:parent_app/features/pin_code/presentation/pin_code_page.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text("Quick Actions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
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
                Text("Pin Code", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
                Text("Absence", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
                    width: double.infinity,
                    onTap: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => ChangeRequestPage()));
                    },
                  ),
                  Text(
                    "Change Pickup/Drop-off",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
