import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:surah_planner/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'providers/locale_provider.dart';
import 'providers/shared_preferences_provider.dart';
import 'screens/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  const dsn = String.fromEnvironment('SENTRY_DSN');

  void launch({required bool sentryEnabled}) {
    final app = const SurahPlannerApp();
    runApp(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: sentryEnabled ? SentryWidget(child: app) : app,
      ),
    );
  }

  if (dsn.isEmpty) {
    launch(sentryEnabled: false);
    return;
  }

  await SentryFlutter.init(
    (options) {
      options.dsn = dsn;
      options.sendDefaultPii = true;
      options.tracesSampleRate = 1.0;
      // ignore: experimental_member_use
      options.profilesSampleRate = 1.0;
      options.replay.sessionSampleRate = 0.1;
      options.replay.onErrorSampleRate = 1.0;
      options.enableLogs = true;
      options.environment = const bool.fromEnvironment('dart.vm.product')
          ? 'production'
          : 'development';
    },
    appRunner: () => launch(sentryEnabled: true),
  );
}

class SurahPlannerApp extends ConsumerWidget {
  const SurahPlannerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Surah Planner',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [SentryNavigatorObserver()],
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('id')],
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FormBuilderLocalizations.delegate,
      ],
      home: const AppShell(),
    );
  }
}
