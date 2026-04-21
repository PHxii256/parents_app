import 'package:flutter/material.dart';
import 'package:parent_app/features/home/presentation/components/parent/trip_panel.dart';
import 'package:parent_app/features/home/presentation/components/staff/latest_message_viewer.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactParentsTile extends StatelessWidget {
  final VoidCallback? onLocationTap;
  const ContactParentsTile({super.key, this.onLocationTap});

  static const String _motherNumber = '+20 01009207148';
  static const String _fatherNumber = '+20 1064141108';

  Future<void> _launchPhoneCall(String phoneNumber) async {
    final normalizedPhone = phoneNumber.replaceAll(' ', '').trim();
    if (normalizedPhone.isEmpty) return;
    await launchUrl(Uri(scheme: 'tel', path: normalizedPhone));
  }

  Future<void> _showCallOptionsDialog(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(localizations?.callContactTitle ?? 'Call Guardian'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                localizations?.primaryContactMother ??
                    'Primary Contact (Mother)',
              ),
              subtitle: const Text(_motherNumber),
              trailing: IconButton(
                icon: Icon(Icons.call, color: AppColors.textHighlight),
                onPressed: () => _launchPhoneCall(_motherNumber),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                localizations?.secondaryContactFather ??
                    'Secondary Contact (Father)',
              ),
              subtitle: const Text(_fatherNumber),
              trailing: IconButton(
                icon: Icon(Icons.call, color: AppColors.textHighlight),
                onPressed: () => _launchPhoneCall(_fatherNumber),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(localizations?.commonCancel ?? 'Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 6,
      children: [
        IconBox(icon: Icons.group, height: 42, iconSize: 24, width: 48),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: SizedBox(
              height: 48,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 6,
                  children: [
                    Expanded(child: LatestMessageViewer()),
                    CircularActionButton(
                      icon: Icons.call,
                      size: 16,
                      onTap: () => _showCallOptionsDialog(context),
                    ),
                    CircularActionButton(
                      icon: Icons.location_pin,
                      size: 16,
                      onTap: onLocationTap,
                    ),

                    //RoundedCtaButton(text: "", icon: Icons.call, height: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
