import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/app_config.dart';
import 'core/app_environment.dart';
import 'providers/core/shared_preferences_provider.dart';

Future<void> runAyaturaApp({required AppEnvironment environment}) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.initialize(environment: environment);
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const AyaturaApp(),
    ),
  );
}
