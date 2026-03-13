import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/core/utils/personal_prefs.dart';
import 'package:parent_app/features/settings/cubit/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState(locale: Locale('en'), isArabicSwitchOn: false));

  int _toggleRequestId = 0;

  Future<void> loadSavedLanguage() async {
    final languageCode = await PersonalPrefs.getLanguageCode();
    if (languageCode == null) return;

    final isArabic = languageCode == 'ar';
    emit(state.copyWith(locale: Locale(languageCode), isArabicSwitchOn: isArabic));
  }

  Future<void> toggleLanguage(bool useArabic) async {
    if (state.isArabicSwitchOn == useArabic) return;

    _toggleRequestId++;
    final currentRequest = _toggleRequestId;
    emit(state.copyWith(isArabicSwitchOn: useArabic));

    final nextLocale = useArabic ? const Locale('ar') : const Locale('en');

    // Allow the switch thumb animation to complete before rebuilding app locale.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (currentRequest != _toggleRequestId) return;

    await PersonalPrefs.setLanguageCode(nextLocale.languageCode);
    emit(state.copyWith(locale: nextLocale));
  }
}
