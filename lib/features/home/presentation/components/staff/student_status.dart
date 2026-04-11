import 'package:flutter/material.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';

class StudentStatus extends StatelessWidget {
  const StudentStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SizedBox(
      height: 28,
      child: Row(
        spacing: 6,
        children: [
          IconBox(icon: Icons.info_outline, height: 40, width: 48),
          Text(
            '${localizations.status}:',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text('(${localizations.comingToday})', style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
