import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ayatura/l10n/app_localizations.dart';

List<LocalizationsDelegate<dynamic>> get testLocalizationDelegates => [
  S.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  FormBuilderLocalizations.delegate,
];

void main() {
  testWidgets('S resolves English strings', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('id')],
        localizationsDelegates: testLocalizationDelegates,
        home: Builder(builder: (context) => Text(S.of(context)!.navHome)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('S resolves Indonesian strings', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('id'),
        supportedLocales: const [Locale('en'), Locale('id')],
        localizationsDelegates: testLocalizationDelegates,
        home: Builder(builder: (context) => Text(S.of(context)!.navHome)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Beranda'), findsOneWidget);
  });
}
