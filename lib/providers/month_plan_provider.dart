import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/plan.dart';
import '../data/services/month_plan_generator.dart';
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

/// In-memory month plan for the active session (persist to Drift later).
class MonthPlanNotifier extends Notifier<MonthPlan?> {
  @override
  MonthPlan? build() => null;

  /// Returns `false` when fewer than two enabled hifdh-list rows exist.
  Future<bool> regenerate() async {
    final pool = await ref.read(poolEntriesAsyncProvider.future);
    final enabled = pool.where((e) => e.enabled).toList();
    if (enabled.length < 2) {
      return false;
    }

    final now = DateTime.now();
    final next = MonthPlanGenerator.generate(
      month: now.month,
      year: now.year,
      enabledPool: enabled,
      existingPlan: state,
    );
    state = next;

    final dim = DateTime(next.year, next.month + 1, 0).day;
    final day = ref.read(selectedPlanDayProvider);
    if (day > dim) {
      ref.read(selectedPlanDayProvider.notifier).setDay(dim);
    }
    return true;
  }

  void clear() => state = null;
}

final monthPlanProvider = NotifierProvider<MonthPlanNotifier, MonthPlan?>(
  MonthPlanNotifier.new,
);
