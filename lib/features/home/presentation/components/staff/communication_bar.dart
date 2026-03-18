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
          CircularActionButton(
            icon: Icons.add,
            onTap: () {
              showDialog(
                context: context,
                builder: (dialogContext) => Dialog(
                  insetPadding: EdgeInsets.symmetric(horizontal: 22),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select a Message",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                          ),
                          const SizedBox(height: 12),
                          MessageChoices(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          CircularActionButton(icon: Icons.call, onTap: () => launchPhoneCall("01032375504")),
        ],
      ),
    );
  }
}

class MessageChoices extends StatefulWidget {
  const MessageChoices({super.key});

  @override
  State<MessageChoices> createState() => _MessageChoicesState();
}

class _MessageChoicesState extends State<MessageChoices> {
  static const List<String> _choices = [
    'I Have arrived',
    'Please Hurry Up',
    'Please be ready at pickup point',
    'I Have Left',
    'Okay',
  ];

  String? _selectedChoice;

  @override
  Widget build(BuildContext context) {
    final isSelected = _selectedChoice != null;
    final sendColor = isSelected ? AppColors.textHighlight : AppColors.onSurfaceDark.withAlpha(100);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 4,
          runSpacing: 1,
          children: _choices.map((choice) {
            final selected = _selectedChoice == choice;
            return Theme(
              data: Theme.of(context).copyWith(splashColor: Colors.transparent),
              child: ChoiceChip(
                label: Text(choice),
                selected: selected,
                showCheckmark: false,
                side: selected
                    ? BorderSide(color: AppColors.textHighlight, width: 2)
                    : BorderSide(color: AppColors.onSurfaceDark, width: 2),
                backgroundColor: AppColors.mutedBgDark,
                selectedColor: AppColors.textHighlight,
                labelStyle: TextStyle(
                  color: selected ? AppColors.mutedBg : AppColors.onSurfaceDark,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                onSelected: (value) {
                  setState(() => _selectedChoice = value ? choice : null);
                },
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Send',
                style: TextStyle(color: sendColor, fontWeight: FontWeight.w600),
              ),
              IconButton(
                onPressed: isSelected ? () => Navigator.of(context).pop() : null,
                icon: Icon(Icons.send, color: sendColor),
                tooltip: 'Send message',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
