import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/app_config.dart';
import 'core/app_environment.dart';
import 'core/first_launch_locale_init.dart';
import 'providers/core/shared_preferences_provider.dart';

Future<void> runAyaturaApp({required AppEnvironment environment}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final splashStopwatch = Stopwatch()..start();
  AppConfig.initialize(environment: environment);
  final prefs = await SharedPreferences.getInstance();
  await firstLaunchLocaleInit(prefs);
  const minNativeSplash = Duration(seconds: 1);
  final remaining = minNativeSplash - splashStopwatch.elapsed;
  if (remaining > Duration.zero) {
    await Future<void>.delayed(remaining);
  }
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const AyaturaApp(),
    ),
  );
}
