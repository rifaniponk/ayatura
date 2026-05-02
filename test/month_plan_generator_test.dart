import 'package:flutter_test/flutter_test.dart';
import 'package:surah_planner/data/models/plan.dart';
import 'package:surah_planner/data/models/prayer.dart';
import 'package:surah_planner/data/models/surah_pool_entry.dart';
import 'package:surah_planner/data/services/month_plan_generator.dart';

SurahPoolEntry _entry(int id, int surahId) =>
    SurahPoolEntry(id: id, surahId: surahId, isFullSurah: true);

void main() {
  group('MonthPlanGenerator', () {
    test('same inputs produce identical plans', () {
      final pool = [_entry(1, 1), _entry(2, 2)];
      final a = MonthPlanGenerator.generate(
        month: 6,
        year: 2026,
        enabledPool: pool,
      );
      final b = MonthPlanGenerator.generate(
        month: 6,
        year: 2026,
        enabledPool: pool,
      );
      expect(a.toJson(), b.toJson());
    });

    test('empty pool yields empty slots', () {
      final plan = MonthPlanGenerator.generate(
        month: 2,
        year: 2026,
        enabledPool: [],
      );
      expect(plan.days.length, 28);
      final slot = plan.planForDay(1)!.slotFor(Prayer.fajr);
      expect(slot.surahs, isEmpty);
    });

    test('single enabled segment fills one PlanSurah per unlocked slot', () {
      final pool = [_entry(1, 5)];
      final plan = MonthPlanGenerator.generate(
        month: 1,
        year: 2026,
        enabledPool: pool,
      );
      final slot = plan.planForDay(15)!.slotFor(Prayer.asr);
      expect(slot.surahs.single.surahId, 5);
    });

    test('preserves locked slots from existing plan', () {
      final pool = [_entry(1, 1), _entry(2, 2)];
      final first = MonthPlanGenerator.generate(
        month: 3,
        year: 2026,
        enabledPool: pool,
      );
      final day1 = first.planForDay(1)!;
      final lockedFajr = day1.slotFor(Prayer.fajr).copyWith(locked: true);
      final patchedPrayers = Map<Prayer, PrayerSlot>.from(day1.prayers)
        ..[Prayer.fajr] = lockedFajr;
      final patchedDay = DayPlan(day: 1, prayers: patchedPrayers);
      final patchedDays = first.days
          .map((d) => d.day == 1 ? patchedDay : d)
          .toList();
      final existing = MonthPlan(month: 3, year: 2026, days: patchedDays);

      final second = MonthPlanGenerator.generate(
        month: 3,
        year: 2026,
        enabledPool: pool,
        existingPlan: existing,
      );

      expect(second.planForDay(1)!.slotFor(Prayer.fajr).locked, true);
      expect(
        second.planForDay(1)!.slotFor(Prayer.fajr).surahs,
        lockedFajr.surahs,
      );
    });
  });
}
