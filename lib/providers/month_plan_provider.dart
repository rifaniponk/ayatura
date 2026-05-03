import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/plan.dart';
import '../data/services/month_plan_generator.dart';
import 'database_provider.dart';
import 'surah_data_providers.dart';

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
    return db.loadLatestPlan();
  }

  /// Returns `false` when fewer than two enabled hifdh-list rows exist.
  Future<bool> regenerate() async {
    final pool = await ref.read(poolEntriesAsyncProvider.future);
    final enabled = pool.where((e) => e.enabled).toList();
    if (enabled.length < 2) {
      return false;
    }

    final now = DateTime.now();
    final current = state.value;
    final next = MonthPlanGenerator.generate(
      month: now.month,
      year: now.year,
      enabledPool: enabled,
      existingPlan: current,
    );

    final db = ref.read(appDatabaseProvider);
    await db.savePlan(next);
    state = AsyncData(next);

    final dim = DateTime(next.year, next.month + 1, 0).day;
    final day = ref.read(selectedPlanDayProvider);
    if (day > dim) {
      ref.read(selectedPlanDayProvider.notifier).setDay(dim);
    }
    return true;
  }

  Future<void> clear() async {
    final db = ref.read(appDatabaseProvider);
    final plan = state.value ?? await db.loadLatestPlan();
    if (plan != null) {
      await db.deletePlan(plan.year, plan.month);
    }
    state = const AsyncData(null);
  }
}

final monthPlanProvider = AsyncNotifierProvider<MonthPlanNotifier, MonthPlan?>(
  MonthPlanNotifier.new,
);
