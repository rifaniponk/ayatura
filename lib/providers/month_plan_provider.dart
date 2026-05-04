import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/plan.dart';
import '../data/services/month_plan_generator.dart';
import 'database_provider.dart';
import 'settings_provider.dart';
import 'surah_data_providers.dart';
import 'widget_sync_provider.dart';

/// True while [MonthPlanNotifier.regenerate] is running (Month tab button UX).
class MonthPlanRegenerateBusy extends Notifier<bool> {
  @override
  bool build() => false;
}

final monthPlanRegenerateBusyProvider =
    NotifierProvider<MonthPlanRegenerateBusy, bool>(
      MonthPlanRegenerateBusy.new,
    );

/// Current calendar day highlighted on Home (1–31).
class SelectedPlanDayNotifier extends Notifier<int> {
  @override
  int build() => DateTime.now().day;

  void setDay(int value) => state = value;
}

final selectedPlanDayProvider = NotifierProvider<SelectedPlanDayNotifier, int>(
  SelectedPlanDayNotifier.new,
);

/// Month plan loaded from Drift on startup and persisted on regenerate.
class MonthPlanNotifier extends AsyncNotifier<MonthPlan?> {
  @override
  Future<MonthPlan?> build() async {
    final db = ref.read(appDatabaseProvider);
    final latest = await db.loadLatestPlan();
    unawaited(syncHomeWidget(ref));
    return latest;
  }

  /// Returns `false` when fewer than two enabled hifdh-list rows exist.
  ///
  /// [month] / [year] default to the current calendar month. Locked slots are
  /// preserved only when the stored plan is for that same month/year.
  Future<bool> regenerate({int? month, int? year}) async {
    final pool = await ref.read(poolEntriesAsyncProvider.future);
    final enabled = pool.where((e) => e.enabled).toList();
    if (enabled.length < 2) {
      return false;
    }

    final clock = DateTime.now();
    final targetMonth = month ?? clock.month;
    final targetYear = year ?? clock.year;
    final current = state.value;
    final existingForTarget =
        current != null &&
            current.month == targetMonth &&
            current.year == targetYear
        ? current
        : null;

    ref.read(monthPlanRegenerateBusyProvider.notifier).state = true;
    try {
      final surahsPerPrayer = ref.read(surahsPerPrayerProvider);
      final next = MonthPlanGenerator.generate(
        month: targetMonth,
        year: targetYear,
        enabledPool: enabled,
        surahsPerPrayer: surahsPerPrayer,
        existingPlan: existingForTarget,
      );

      final db = ref.read(appDatabaseProvider);
      await db.savePlan(next);
      state = AsyncData(next);

      if (next.year == clock.year && next.month == clock.month) {
        final dim = DateTime(next.year, next.month + 1, 0).day;
        final day = ref.read(selectedPlanDayProvider);
        if (day > dim) {
          ref.read(selectedPlanDayProvider.notifier).setDay(dim);
        }
      }
      await syncHomeWidget(ref);
      return true;
    } finally {
      ref.read(monthPlanRegenerateBusyProvider.notifier).state = false;
    }
  }

  Future<void> clear() async {
    final db = ref.read(appDatabaseProvider);
    final plan = state.maybeWhen(data: (p) => p, orElse: () => null);
    if (plan != null) {
      await db.deletePlan(plan.year, plan.month);
    }
    state = const AsyncData(null);
    await syncHomeWidget(ref);
  }
}

final monthPlanProvider = AsyncNotifierProvider<MonthPlanNotifier, MonthPlan?>(
  MonthPlanNotifier.new,
);
