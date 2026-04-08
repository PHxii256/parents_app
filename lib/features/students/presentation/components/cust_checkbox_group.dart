import 'package:flutter/material.dart';
import 'package:parent_app/l10n/app_localizations.dart';

class CustCheckboxGroup extends StatelessWidget {
  final String title;
  final bool value;
  final bool enabled;
  final ValueChanged<bool>? onChanged;

  const CustCheckboxGroup({
    super.key,
    required this.title,
    required this.value,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final effectiveTextColor = enabled
        ? Theme.of(context).textTheme.bodyMedium?.color
        : Theme.of(context).disabledColor;

    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$title: ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: effectiveTextColor,
                ),
              ),
              Text(
                value ? localizations.commonYes : localizations.commonNo,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: effectiveTextColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
            child: Checkbox(
              visualDensity: VisualDensity.compact,
              value: value,
              onChanged: enabled
                  ? (current) {
                      onChanged?.call(current ?? false);
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
