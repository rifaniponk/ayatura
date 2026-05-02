import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'core/theme/app_theme.dart';
import 'screens/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: SurahPlannerApp()));
}

class SurahPlannerApp extends StatelessWidget {
  const SurahPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surah Planner',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      supportedLocales: FormBuilderLocalizations.supportedLocales,
      localizationsDelegates: FormBuilderLocalizations.localizationsDelegates,
      home: const AppShell(),
    );
  }
}
