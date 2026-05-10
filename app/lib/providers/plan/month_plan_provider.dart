import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/plan.dart';
import '../../data/models/prayer.dart';
import '../../data/models/plan_surah.dart';
import '../../data/models/surah_pool_entry.dart';
import '../../data/services/month_plan_generator.dart';
import '../../data/services/widget_sync_service.dart';
import '../core/database_provider.dart';
import '../insight/hifdh_frequency_provider.dart';
import 'month_plan_regenerate_busy_provider.dart';
import 'selected_plan_day_provider.dart';
import '../core/settings_provider.dart';
import '../quran/surah_data_providers.dart';

typedef YearMonth = ({int year, int month});

final monthPlanByYearMonthProvider =
    FutureProvider.family<MonthPlan?, YearMonth>((ref, ym) {
      final db = ref.watch(appDatabaseProvider);
      return db.loadPlan(ym.year, ym.month);
    });

final monthPlanExistsByYearMonthProvider =
    FutureProvider.family<bool, YearMonth>((ref, ym) async {
      final db = ref.watch(appDatabaseProvider);
      final plan = await db.loadPlan(ym.year, ym.month);
      return plan != null;
    });

/// Month plan loaded from Drift on startup and persisted on regenerate.
class MonthPlanNotifier extends AsyncNotifier<MonthPlan?> {
  @override
  Future<MonthPlan?> build() async {
    final db = ref.read(appDatabaseProvider);
    final now = DateTime.now();
    return db.loadPlan(now.year, now.month);
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
    final db = ref.read(appDatabaseProvider);
    final existingForTarget = await db.loadPlan(targetYear, targetMonth);
    final lockPastPrayers = ref.read(lockPastPrayersProvider);
    final shouldLockPastDays =
        lockPastPrayers &&
        targetYear == clock.year &&
        targetMonth == clock.month &&
        existingForTarget != null;
    final preprocessedExistingPlan = shouldLockPastDays
        ? _lockPastDays(existingForTarget, clock.day)
        : existingForTarget;

    ref.read(monthPlanRegenerateBusyProvider.notifier).state = true;
    try {
      final surahsPerPrayer = ref.read(surahsPerPrayerProvider);
      final next = MonthPlanGenerator.generate(
        month: targetMonth,
        year: targetYear,
        enabledPool: enabled,
        surahsPerPrayer: surahsPerPrayer,
        existingPlan: preprocessedExistingPlan,
      );

      await db.savePlan(next);
      final keyToEntryId = <String, int>{
        for (final entry in enabled) _poolEntryKey(entry): entry.id,
      };
      final assignedEntryIds = <int>{};
      for (final day in next.days) {
        final existingDay = preprocessedExistingPlan?.planForDay(day.day);
        for (final prayer in Prayer.values) {
          final existingSlot = existingDay?.slotFor(prayer);
          final slot = day.slotFor(prayer);
          if (existingSlot != null && existingSlot.locked) {
            continue;
          }
          for (final surah in slot.surahs) {
            final entryId = keyToEntryId[_planSurahKey(surah)];
            if (entryId != null) {
              assignedEntryIds.add(entryId);
            }
          }
        }
      }
      await db.incrementPoolEntryAssignmentCounts(assignedEntryIds);
      ref.invalidate(poolEntriesAsyncProvider);
      ref.invalidate(hifdhFrequencyProvider);
      ref.invalidate(
        monthPlanByYearMonthProvider((year: targetYear, month: targetMonth)),
      );

      if (next.year == clock.year && next.month == clock.month) {
        state = AsyncData(next);
      }

      if (next.year == clock.year && next.month == clock.month) {
        final dim = DateTime(next.year, next.month + 1, 0).day;
        final day = ref.read(selectedPlanDayProvider);
        if (day > dim) {
          ref.read(selectedPlanDayProvider.notifier).setDay(dim);
        }
      }
      await WidgetSyncService.sync(ref);
      return true;
    } finally {
      ref.read(monthPlanRegenerateBusyProvider.notifier).state = false;
    }
  }

  MonthPlan _lockPastDays(MonthPlan plan, int todayDay) {
    final updatedDays = plan.days.map((dayPlan) {
      if (dayPlan.day >= todayDay) return dayPlan;
      var changed = false;
      final nextPrayers = Map<Prayer, PrayerSlot>.from(dayPlan.prayers);
      for (final prayer in Prayer.values) {
        final slot = dayPlan.slotFor(prayer);
        if (!slot.locked) {
          nextPrayers[prayer] = slot.copyWith(locked: true);
          changed = true;
        }
      }
      return changed ? dayPlan.copyWith(prayers: nextPrayers) : dayPlan;
    }).toList();
    return MonthPlan(month: plan.month, year: plan.year, days: updatedDays);
  }

  Future<void> clear() async {
    final db = ref.read(appDatabaseProvider);
    final plan = state.maybeWhen(data: (p) => p, orElse: () => null);
    if (plan != null) {
      await db.deletePlan(plan.year, plan.month);
      ref.invalidate(hifdhFrequencyProvider);
      ref.invalidate(
        monthPlanByYearMonthProvider((year: plan.year, month: plan.month)),
      );
    }
    state = const AsyncData(null);
    await WidgetSyncService.sync(ref);
  }

  Future<void> toggleSlotLock({
    required int year,
    required int month,
    required int day,
    required Prayer prayer,
  }) async {
    final db = ref.read(appDatabaseProvider);
    final current = await db.loadPlan(year, month);
    if (current == null) return;
    final updatedDays = current.days.map((d) {
      if (d.day != day) return d;
      final existingSlot = d.slotFor(prayer);
      final nextPrayers = Map<Prayer, PrayerSlot>.from(d.prayers)
        ..[prayer] = existingSlot.copyWith(locked: !existingSlot.locked);
      return d.copyWith(prayers: nextPrayers);
    }).toList();
    final next = MonthPlan(
      month: current.month,
      year: current.year,
      days: updatedDays,
    );
    await db.savePlan(next);
    ref.invalidate(hifdhFrequencyProvider);
    ref.invalidate(monthPlanByYearMonthProvider((year: year, month: month)));
    final now = DateTime.now();
    if (year == now.year && month == now.month) {
      state = AsyncData(next);
    }
    await WidgetSyncService.sync(ref);
  }

  Future<int> clearLocksForMonth({
    required int year,
    required int month,
  }) async {
    final db = ref.read(appDatabaseProvider);
    final current = await db.loadPlan(year, month);
    if (current == null) return 0;
    var cleared = 0;
    final updatedDays = current.days.map((d) {
      var changed = false;
      final nextPrayers = Map<Prayer, PrayerSlot>.from(d.prayers);
      for (final prayer in Prayer.values) {
        final slot = d.slotFor(prayer);
        if (slot.locked) {
          nextPrayers[prayer] = slot.copyWith(locked: false);
          cleared++;
          changed = true;
        }
      }
      return changed ? d.copyWith(prayers: nextPrayers) : d;
    }).toList();
    if (cleared == 0) return 0;
    final next = MonthPlan(
      month: current.month,
      year: current.year,
      days: updatedDays,
    );
    await db.savePlan(next);
    ref.invalidate(hifdhFrequencyProvider);
    ref.invalidate(monthPlanByYearMonthProvider((year: year, month: month)));
    final now = DateTime.now();
    if (year == now.year && month == now.month) {
      state = AsyncData(next);
    }
    await WidgetSyncService.sync(ref);
    return cleared;
  }
}

final monthPlanProvider = AsyncNotifierProvider<MonthPlanNotifier, MonthPlan?>(
  MonthPlanNotifier.new,
);

String _poolEntryKey(SurahPoolEntry entry) =>
    '${entry.surahId}|${entry.isFullSurah}|${entry.startAyah}|${entry.endAyah}';

String _planSurahKey(PlanSurah surah) =>
    '${surah.surahId}|${surah.isFullSurah}|${surah.startAyah}|${surah.endAyah}';
