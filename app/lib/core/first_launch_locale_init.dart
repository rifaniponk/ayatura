import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/core/locale_provider.dart';

/// One-time locale guess from IP country before any user language choice exists.
///
/// Skips when [LocaleNotifier.localeInitializedKey] is already true, or when
/// [LocaleNotifier.languageCodePreferenceKey] exists (existing install or
/// manual choice).
Future<void> firstLaunchLocaleInit(SharedPreferences prefs) async {
  if (prefs.getBool(LocaleNotifier.localeInitializedKey) == true) {
    return;
  }
  if (prefs.containsKey(LocaleNotifier.languageCodePreferenceKey)) {
    await prefs.setBool(LocaleNotifier.localeInitializedKey, true);
    return;
  }

  var languageCode = 'en';
  try {
    final response = await http
        .get(Uri.parse('https://ipinfo.io/json'))
        .timeout(const Duration(seconds: 3));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) {
        final country = body['country'];
        if (country == 'ID') {
          languageCode = 'id';
        }
      }
    }
  } catch (_) {
    // Default English, no user-visible error.
  }

  await prefs.setString(LocaleNotifier.languageCodePreferenceKey, languageCode);
  await prefs.setBool(LocaleNotifier.localeInitializedKey, true);
}
