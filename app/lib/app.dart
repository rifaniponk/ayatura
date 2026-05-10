import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ayatura/l10n/app_localizations.dart';

import 'core/theme/app_theme.dart';
import 'providers/core/locale_provider.dart';
import 'providers/widget/widget_sync_provider.dart';
import 'screens/app_shell.dart';

class AyaturaApp extends ConsumerWidget {
  const AyaturaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    ref.watch(widgetSyncBootstrapProvider);

    return MaterialApp(
      onGenerateTitle: (context) => S.of(context)!.appTitle,
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
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
