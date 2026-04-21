import 'package:flutter/material.dart';
import 'package:parent_app/l10n/app_localizations.dart';

class StudentPageSearch extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  const StudentPageSearch({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SizedBox(
      height: 46,
      child: SearchBar(
        trailing: [Icon(Icons.search)],
        hintText: localizations.studentSearchHint,
        onChanged: onChanged,
        elevation: WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(6))),
        ),
      ),
    );
  }
}
