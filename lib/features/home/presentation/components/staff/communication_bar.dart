import 'package:flutter/material.dart';
import 'package:parent_app/features/home/presentation/components/parent/trip_panel.dart';
import 'package:parent_app/shared/theme/app_colors.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunicationBar extends StatelessWidget {
  const CommunicationBar({super.key});

  Future<void> launchPhoneCall(String phoneNumber) async {
    final normalizedPhone = phoneNumber.trim();
    if (normalizedPhone.isEmpty) {
      return;
    }

    await launchUrl(Uri(scheme: 'tel', path: normalizedPhone));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          IconBox(icon: Icons.message, height: 48, width: 48),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.mutedBgDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 0, 0),
                  child: Text(
                    "Press + to send a message",
                    style: TextStyle(color: AppColors.brownBg),
                  ),
                ),
              ),
            ),
          ),
          CircularActionButton(icon: Icons.add, onTap: () {}),
          CircularActionButton(icon: Icons.call, onTap: () => launchPhoneCall("01032375504")),
        ],
      ),
    );
  }
}
