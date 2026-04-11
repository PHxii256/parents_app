import 'package:flutter/material.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class LatestMessageViewer extends StatelessWidget {
  const LatestMessageViewer({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return DecoratedBox(
      decoration: BoxDecoration(color: AppColors.mutedBg, borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
        child: Text('${localizations.noNewMessages}.', style: TextStyle(color: AppColors.brownBg)),
      ),
    );
  }
}
