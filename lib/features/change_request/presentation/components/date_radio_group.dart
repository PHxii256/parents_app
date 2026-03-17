import 'package:flutter/material.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/models/date_value.dart';
import 'package:parent_app/shared/widgets/cust_radio_group.dart';

class DateRadioGroup extends StatelessWidget {
  const DateRadioGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final today = DateUtils.dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));
    final dateOptions = [
      DateValue(
        name: '${localizations.today} (${DateValue.getDayOfWeek(today, localizations)})',
        value: today,
      ),
      DateValue(
        name: '${localizations.tomorrow} (${DateValue.getDayOfWeek(tomorrow, localizations)})',
        value: tomorrow,
      ),
      DateValue(name: localizations.specificDate, value: today),
    ];
    return CustRadioGroup(
      initialValue: dateOptions.first,
      options: dateOptions
          .map((option) => CustRadioOption(label: option.name, value: option))
          .toList(),
    );
  }
}
