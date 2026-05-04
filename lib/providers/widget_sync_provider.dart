import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/prayer_times.dart';
import '../data/services/widget_payload_service.dart';
import 'database_provider.dart';
import 'shared_preferences_provider.dart';

final widgetPayloadServiceProvider = Provider<WidgetPayloadService>((ref) {
  return WidgetPayloadService(ref.read(appDatabaseProvider));
});

class WidgetSyncService {
  const WidgetSyncService({
    required this.payloadService,
    required this.preferences,
  });

  static const payloadKey = 'widget_payload';

  final WidgetPayloadService payloadService;
  final SharedPreferences preferences;

  Future<void> sync({DateTime? now}) async {
    final prayerTimes = PrayerTimes.fromPreferences(preferences);
    final payload = await payloadService.build(
      prayerTimes: prayerTimes,
      now: now,
    );
    final encoded = jsonEncode(payload.toJson());

    await HomeWidget.saveWidgetData<String>(payloadKey, encoded);
    await HomeWidget.updateWidget(
      iOSName: 'SurahPlannerWidget',
      androidName: 'SurahPlannerWidgetProvider',
    );
  }
}

final widgetSyncServiceProvider = Provider<WidgetSyncService>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return WidgetSyncService(
    payloadService: ref.read(widgetPayloadServiceProvider),
    preferences: prefs,
  );
});

Future<void> syncHomeWidget(dynamic ref) async {
  try {
    await ref.read(widgetSyncServiceProvider).sync();
  } catch (error, stackTrace) {
    debugPrint('Failed to sync home widget: $error\n$stackTrace');
  }
}
