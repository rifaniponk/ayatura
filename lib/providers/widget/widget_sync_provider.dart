import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/month_plan.dart';
import '../../data/services/prayer_times_sync_service.dart';
import '../../data/services/widget_sync_service.dart';
import '../core/locale_provider.dart';
import '../plan/month_plan_provider.dart';
import '../prayer/prayer_times_provider.dart';

final widgetSyncBootstrapProvider = Provider<void>((ref) {
  ref.listen<Locale>(localeProvider, (previous, next) {
    if (previous != null && previous.languageCode != next.languageCode) {
      unawaited(WidgetSyncService.sync(ref));
    }
  });
  ref.listen<AsyncValue<MonthPlan?>>(monthPlanProvider, (previous, next) {
    unawaited(WidgetSyncService.sync(ref));
  });
  ref.listen<AsyncValue<PrayerTimesSyncResult?>>(prayerTimesSyncProvider, (
    previous,
    next,
  ) {
    unawaited(WidgetSyncService.sync(ref));
  });
  unawaited(WidgetSyncService.sync(ref));
});
