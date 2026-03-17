import 'package:parent_app/l10n/app_localizations.dart';

final class DateValue {
  final String name;
  final DateTime value;
  const DateValue({required this.name, required this.value});

  static String getDayOfWeek(DateTime date, AppLocalizations localizations) {
    final days = [
      localizations.monday,
      localizations.tuesday,
      localizations.wednesday,
      localizations.thursday,
      localizations.friday,
      localizations.saturday,
      localizations.sunday,
    ];
    return days[date.weekday - 1];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is DateValue && other.name == name && other.value.isAtSameMomentAs(value);
  }

  @override
  int get hashCode => Object.hash(name, value.millisecondsSinceEpoch);
}
