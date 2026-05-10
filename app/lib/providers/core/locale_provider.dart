import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_preferences_provider.dart';

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<Locale> {
  static const _key = 'locale_language_code';

  @override
  Locale build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final code = prefs.getString(_key);
    return _normalize(code);
  }

  Future<void> setLocale(Locale locale) async {
    final normalized = _normalize(locale.languageCode);
    state = normalized;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, normalized.languageCode);
  }

  static Locale _normalize(String? code) {
    if (code == 'id') return const Locale('id');
    return const Locale('en');
  }
}
