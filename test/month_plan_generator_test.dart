import 'package:flutter_test/flutter_test.dart';
import 'package:surah_planner/data/models/plan.dart';
import 'package:surah_planner/data/models/plan_surah.dart';
import 'package:surah_planner/data/models/prayer.dart';
import 'package:surah_planner/data/models/surah_pool_entry.dart';
import 'package:surah_planner/data/services/month_plan_generator.dart';

SurahPoolEntry _entry(int id, int surahId) =>
    SurahPoolEntry(id: id, surahId: surahId, isFullSurah: true);

SurahPoolEntry _countedEntry(int id, int surahId, int assignmentCount) =>
    SurahPoolEntry(
      id: id,
      surahId: surahId,
      isFullSurah: true,
      assignmentCount: assignmentCount,
    );

void main() {
  final testNow = DateTime(2026, 1, 15);

  group('MonthPlanGenerator', () {
    test('all pool entries appear before any repeats (round-robin)', () {
      final pool = [_entry(1, 1), _entry(2, 2), _entry(3, 3), _entry(4, 4)];
      final plan = MonthPlanGenerator.generate(
        month: 6,
        year: 2026,
        enabledPool: pool,
        surahsPerPrayer: 4,
        now: testNow,
      );

      // Collect surahIds dealt sequentially across all slots.
      final dealt = <int>[];
      for (final day in plan.days) {
        for (final prayer in Prayer.values) {
          dealt.addAll(day.slotFor(prayer).surahs.map((s) => s.surahId));
        }
      }

      // Within the first full cycle (pool.length slots of 1 each = 4 surahs
      // taken 1-by-1), every surah must appear before any repeats.
      // Here surahsPerPrayer >= pool.length so each slot gets all 4.
      // Verify the first two full cycles: each set of 4 contains every surahId.
      final poolIds = pool.map((e) => e.surahId).toSet();
      expect(dealt.take(poolIds.length).toSet(), equals(poolIds));
      expect(
        dealt.skip(poolIds.length).take(poolIds.length).toSet(),
        equals(poolIds),
      );
    });

    test('least-assigned entries are prioritized first', () {
      final pool = [
        _countedEntry(1, 1, 5),
        _countedEntry(2, 2, 0),
        _countedEntry(3, 3, 2),
      ];
      final plan = MonthPlanGenerator.generate(
        month: 6,
        year: 2026,
        enabledPool: pool,
        surahsPerPrayer: 1,
        now: DateTime(2026, 6, 1),
      );

      final firstSlot = plan.planForDay(1)!.slotFor(Prayer.fajr).surahs.single;
      expect(firstSlot.surahId, 2);
    });

    test('new least-assigned entry appears at most once per day', () {
      final pool = [
        _countedEntry(1, 1, 0),
        _countedEntry(2, 2, 10),
        _countedEntry(3, 3, 10),
        _countedEntry(4, 4, 10),
        _countedEntry(5, 5, 10),
        _countedEntry(6, 6, 10),
      ];
      final plan = MonthPlanGenerator.generate(
        month: 6,
        year: 2026,
        enabledPool: pool,
        surahsPerPrayer: 1,
        now: DateTime(2026, 6, 1),
      );

      final day1 = plan.planForDay(1)!;
      final occurrencesInDay1 = Prayer.values
          .map((p) => day1.slotFor(p).surahs.single.surahId)
          .where((surahId) => surahId == 1)
          .length;
      expect(occurrencesInDay1, 1);
    });

    test('does not repeat the same surah on the same day', () {
      final pool = [
        _entry(1, 1),
        _entry(2, 2),
        _entry(3, 3),
        _entry(4, 4),
        _entry(5, 5),
      ];
      final plan = MonthPlanGenerator.generate(
        month: 6,
        year: 2026,
        enabledPool: pool,
        surahsPerPrayer: 1,
        now: DateTime(2026, 6, 1),
      );

      final day1 = plan.planForDay(1)!;
      final daySurahIds = <int>{
        for (final prayer in Prayer.values)
          day1.slotFor(prayer).surahs.single.surahId,
      };
      expect(daySurahIds.length, Prayer.values.length);
    });

    test('allows same-day repeats when pool is smaller than day slots', () {
      final pool = [_entry(1, 1), _entry(2, 2)];
      final plan = MonthPlanGenerator.generate(
        month: 6,
        year: 2026,
        enabledPool: pool,
        surahsPerPrayer: 1,
        now: DateTime(2026, 6, 1),
      );

      final day1 = plan.planForDay(1)!;
      final daySurahIds = [
        for (final prayer in Prayer.values)
          day1.slotFor(prayer).surahs.single.surahId,
      ];
      expect(daySurahIds.toSet().length, lessThan(Prayer.values.length));
    });

    test('allows one same-day repeat when pool has 4 entries', () {
      final pool = [_entry(1, 1), _entry(2, 2), _entry(3, 3), _entry(4, 4)];
      final plan = MonthPlanGenerator.generate(
        month: 6,
        year: 2026,
        enabledPool: pool,
        surahsPerPrayer: 1,
        now: DateTime(2026, 6, 1),
      );

      final day1 = plan.planForDay(1)!;
      final daySurahIds = [
        for (final prayer in Prayer.values)
          day1.slotFor(prayer).surahs.single.surahId,
      ];
      expect(daySurahIds.toSet().length, 4);
    });

    test('empty pool yields empty slots', () {
      final plan = MonthPlanGenerator.generate(
        month: 2,
        year: 2026,
        enabledPool: [],
        surahsPerPrayer: 2,
        now: testNow,
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
        surahsPerPrayer: 2,
        now: testNow,
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
        surahsPerPrayer: 2,
        now: testNow,
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
        surahsPerPrayer: 2,
        existingPlan: existing,
        now: testNow,
      );

      expect(second.planForDay(1)!.slotFor(Prayer.fajr).locked, true);
      expect(
        second.planForDay(1)!.slotFor(Prayer.fajr).surahs,
        lockedFajr.surahs,
      );
    });

    test('first deck cycle excludes surahs currently locked somewhere', () {
      final pool = [_entry(1, 1), _entry(2, 2), _entry(3, 3)];
      final existing = MonthPlan(
        month: 7,
        year: 2026,
        days: [
          DayPlan(
            day: 1,
            prayers: {
              Prayer.fajr: PrayerSlot(
                locked: true,
                surahs: const [PlanSurah(surahId: 1, isFullSurah: true)],
              ),
              for (final p in Prayer.values.where((p) => p != Prayer.fajr))
                p: PrayerSlot(),
            },
          ),
        ],
      );

      final plan = MonthPlanGenerator.generate(
        month: 7,
        year: 2026,
        enabledPool: pool,
        surahsPerPrayer: 1,
        existingPlan: existing,
        now: testNow,
      );

      final dealt = <int>[];
      for (final day in plan.days) {
        for (final prayer in Prayer.values) {
          if (day.day == 1 && prayer == Prayer.fajr) {
            continue;
          }
          final slot = day.slotFor(prayer);
          if (slot.surahs.isNotEmpty) {
            dealt.add(slot.surahs.first.surahId);
          }
        }
      }
      final firstCycle = dealt.take(2).toSet();
      expect(firstCycle, equals({2, 3}));
    });

    test('surahsPerPrayer caps slot size at requested count', () {
      final pool = [
        _entry(1, 1),
        _entry(2, 2),
        _entry(3, 3),
        _entry(4, 4),
        _entry(5, 5),
        _entry(6, 6),
      ];
      final plan = MonthPlanGenerator.generate(
        month: 4,
        year: 2026,
        enabledPool: pool,
        surahsPerPrayer: 2,
        now: testNow,
      );
      for (final day in plan.days) {
        for (final prayer in Prayer.values) {
          final slot = day.slotFor(prayer);
          expect(slot.surahs.length, 2);
        }
      }
    });

    test('surahsPerPrayer clamps to pool size when pool is smaller', () {
      final pool = [_entry(1, 1), _entry(2, 2)];
      final plan = MonthPlanGenerator.generate(
        month: 5,
        year: 2026,
        enabledPool: pool,
        surahsPerPrayer: 4,
        now: testNow,
      );
      for (final day in plan.days) {
        for (final prayer in Prayer.values) {
          expect(day.slotFor(prayer).surahs.length, 2);
        }
      }
    });

    test('current month generates new slots starting from today', () {
      final plan = MonthPlanGenerator.generate(
        month: 5,
        year: 2026,
        enabledPool: [_entry(1, 1), _entry(2, 2)],
        surahsPerPrayer: 1,
        now: DateTime(2026, 5, 6),
      );

      expect(plan.planForDay(5)!.slotFor(Prayer.fajr).surahs, isEmpty);
      expect(plan.planForDay(6)!.slotFor(Prayer.fajr).surahs, isNotEmpty);
    });

    test('current month preserves existing past-day unlocked slots', () {
      final existing = MonthPlan(
        month: 5,
        year: 2026,
        days: [
          DayPlan(
            day: 1,
            prayers: {
              Prayer.fajr: PrayerSlot(
                surahs: const [PlanSurah(surahId: 99, isFullSurah: true)],
              ),
              for (final p in Prayer.values.where((p) => p != Prayer.fajr))
                p: PrayerSlot(),
            },
          ),
        ],
      );

      final plan = MonthPlanGenerator.generate(
        month: 5,
        year: 2026,
        enabledPool: [_entry(1, 1), _entry(2, 2)],
        surahsPerPrayer: 1,
        existingPlan: existing,
        now: DateTime(2026, 5, 6),
      );

      final day1Fajr = plan.planForDay(1)!.slotFor(Prayer.fajr);
      expect(day1Fajr.locked, false);
      expect(day1Fajr.surahs.single.surahId, 99);
    });

    test('future month generation starts from day 1', () {
      final plan = MonthPlanGenerator.generate(
        month: 7,
        year: 2026,
        enabledPool: [_entry(1, 1), _entry(2, 2), _entry(3, 3), _entry(4, 4)],
        surahsPerPrayer: 1,
        now: DateTime(2026, 6, 15),
      );

      expect(plan.planForDay(1)!.slotFor(Prayer.fajr).surahs, isNotEmpty);
    });
  });
}
