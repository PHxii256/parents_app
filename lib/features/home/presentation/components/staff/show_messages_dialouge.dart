import 'package:flutter/material.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

void showMessagesDialouge(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (dialogContext) => Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 22),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.selectAMessage,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              const MessageChoices(),
            ],
          ),
        ),
      ),
    ),
  );
}

class MessageChoices extends StatefulWidget {
  const MessageChoices({super.key});

  @override
  State<MessageChoices> createState() => _MessageChoicesState();
}

class _MessageChoicesState extends State<MessageChoices> {
  String? _selectedChoice;
  final TextEditingController _customMessageController = TextEditingController();

  @override
  void dispose() {
    _customMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final choices = [
      localizations.messagePleaseWaitForUsWeAreComing,
      localizations.messageWeAreWaitingAtBusStop,
    ];
    final hasCustomMessage = _customMessageController.text.trim().isNotEmpty;
    final isSelected = _selectedChoice != null || hasCustomMessage;
    final sendColor = isSelected ? AppColors.textHighlight : AppColors.onSurfaceDark.withAlpha(100);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.quickMessagesTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 1,
          children: choices.map((choice) {
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
        const SizedBox(height: 16),
        Text(localizations.customMessageLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
        TextField(
          controller: _customMessageController,
          minLines: 1,
          maxLines: 2,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: localizations.customMessageHint,
            enabledBorder: const UnderlineInputBorder(),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.textHighlight, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                localizations.send,
                style: TextStyle(color: sendColor, fontWeight: FontWeight.w600),
              ),
              IconButton(
                onPressed: isSelected
                    ? () {
                        final selectedMessage = _customMessageController.text.trim().isNotEmpty
                            ? _customMessageController.text.trim()
                            : _selectedChoice!;
                        if (selectedMessage.isNotEmpty) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Message Sent")));
                        }
                      }
                    : null,
                icon: Icon(Icons.send, color: sendColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
