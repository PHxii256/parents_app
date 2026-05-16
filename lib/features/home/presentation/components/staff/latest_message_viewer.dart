import 'package:flutter/material.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class LatestMessageViewer extends StatelessWidget {
  final String? latestMessage;

  const LatestMessageViewer({super.key, this.latestMessage});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final message = latestMessage?.trim();
    final hasMessage = message != null && message.isNotEmpty;

    return DecoratedBox(
      decoration: BoxDecoration(color: AppColors.mutedBg, borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
        child: Text(
          hasMessage ? message : '${localizations.noNewMessages}.',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: AppColors.brownBg),
        ),
      ),
    );
  }
}
