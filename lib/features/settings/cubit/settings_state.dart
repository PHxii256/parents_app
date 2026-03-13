import 'package:flutter/material.dart';

class SettingsState {
  final Locale locale;
  final bool isArabicSwitchOn;

  const SettingsState({required this.locale, required this.isArabicSwitchOn});

  bool get isArabic => locale.languageCode == 'ar';

  SettingsState copyWith({Locale? locale, bool? isArabicSwitchOn}) {
    return SettingsState(
      locale: locale ?? this.locale,
      isArabicSwitchOn: isArabicSwitchOn ?? this.isArabicSwitchOn,
    );
  }
}
