import 'package:flutter/material.dart';
import 'package:parent_app/features/home/presentation/components/parent/trip_panel.dart';
import 'package:parent_app/features/home/presentation/components/staff/latest_message_viewer.dart';
import 'package:parent_app/features/home/presentation/components/staff/show_messages_dialouge.dart';
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
          Expanded(child: LatestMessageViewer()),
          CircularActionButton(icon: Icons.add, onTap: () => showMessagesDialouge(context)),
          CircularActionButton(icon: Icons.call, onTap: () => launchPhoneCall("01032375504")),
        ],
      ),
    );
  }
}
