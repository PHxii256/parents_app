import 'package:flutter/material.dart';
import 'package:parent_app/l10n/app_localizations.dart';

class StudentPageSearch extends StatelessWidget {
  const StudentPageSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SizedBox(
      height: 46,
      child: SearchBar(
        trailing: [Icon(Icons.search)],
        hintText: localizations.studentSearchHint,
        elevation: WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(6))),
        ),
      ),
    );
  }
}
