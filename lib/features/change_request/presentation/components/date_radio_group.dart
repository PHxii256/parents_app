import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../absence/presentation/absence_page.dart';

class DateRadioGroup extends StatefulWidget {
  final Function(DateTime selectedDate) onDateSelected;

  const DateRadioGroup({super.key, required this.onDateSelected});

  @override
  State<DateRadioGroup> createState() => _DateRadioGroupState();
}

class _DateRadioGroupState extends State<DateRadioGroup> {
  AbsenceDateOption selectedOption = AbsenceDateOption.today;
  DateTime? specificDate;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    final today = DateUtils.dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));

    final todayDay = DateFormat('EEEE,ar', locale).format(today);
    final tomorrowDay = DateFormat('EEEE', locale).format(tomorrow);
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [

        GestureDetector(
          onTap: () {
            setState(() {
              selectedOption = AbsenceDateOption.today;
              specificDate = null;
            });
            widget.onDateSelected(today);
          },
          child: _buildItem(
            title: "${localizations.today} ($todayDay)",
            value: AbsenceDateOption.today,
          ),
        ),

        const SizedBox(height: 12),

        /// 🔹 Tomorrow
        GestureDetector(
          onTap: () {
            setState(() {
              selectedOption = AbsenceDateOption.tomorrow;
              specificDate = null;
            });
            widget.onDateSelected(tomorrow);
          },
          child: _buildItem(
            title: "${localizations.tomorrow} ($tomorrowDay)",
            value: AbsenceDateOption.tomorrow,
          ),
        ),

        const SizedBox(height: 12),

        /// 🔹 Specific Date
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: specificDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );

            if (picked != null) {
              setState(() {
                specificDate = picked;
                selectedOption = AbsenceDateOption.specific;
              });

              widget.onDateSelected(picked);
            }
          },
          child: _buildItem(
            title: specificDate != null
                ? DateFormat('EEEE, d MMMM', locale).format(specificDate!)
                : "${localizations.specificDate}",
            value: AbsenceDateOption.specific,
          ),
        ),
      ],
    );
  }

  Widget _buildItem({
    required String title,
    required AbsenceDateOption value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          Radio<AbsenceDateOption>(
            value: value,
            groupValue: selectedOption,
            activeColor: Colors.black,
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }
}