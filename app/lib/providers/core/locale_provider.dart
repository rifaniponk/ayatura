import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_preferences_provider.dart';

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<Locale> {
  static const languageCodePreferenceKey = 'locale_language_code';
  static const localeInitializedKey = 'locale_initialised';

  @override
  Locale build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final code = prefs.getString(languageCodePreferenceKey);
    return _normalize(code);
  }

  Future<void> setLocale(Locale locale) async {
    final normalized = _normalize(locale.languageCode);
    state = normalized;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(languageCodePreferenceKey, normalized.languageCode);
    await prefs.setBool(localeInitializedKey, true);
  }

  static Locale _normalize(String? code) {
    if (code == 'id') return const Locale('id');
    return const Locale('en');
  }
}
