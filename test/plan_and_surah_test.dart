import 'package:flutter_test/flutter_test.dart';
import 'package:surah_planner/core/plan_config.dart';
import 'package:surah_planner/data/models/plan.dart';
import 'package:surah_planner/data/models/plan_surah.dart';
import 'package:surah_planner/data/models/prayer.dart';
import 'package:surah_planner/data/models/surah.dart';
import 'package:surah_planner/data/models/surah_pool_entry.dart';

Surah _surah(int id) =>
    Surah(id: id, name: 'S$id', arabicName: 'x', ayatCount: 10);

PlanSurah _planFull(int id) => PlanSurah(surahId: id, isFullSurah: true);

PlanSurah _planPartial(int id, int start, int end) =>
    PlanSurah(surahId: id, isFullSurah: false, startAyah: start, endAyah: end);

void main() {
  group('Surah', () {
    test('displayName is the surah name', () {
      const s = Surah(
        id: 2,
        name: 'Al-Baqarah',
        arabicName: 'ب',
        ayatCount: 286,
      );
      expect(s.displayName, 'Al-Baqarah');
    });

    test('copyWith replaces fields immutably', () {
      const s = Surah(id: 1, name: 'A', arabicName: 'ب', ayatCount: 7);
      final t = s.copyWith(name: 'B');
      expect(s.name, 'A');
      expect(t.name, 'B');
    });

    test('equality uses value fields', () {
      const a = Surah(id: 1, name: 'A', arabicName: 'ب', ayatCount: 7);
      const b = Surah(id: 1, name: 'A', arabicName: 'ب', ayatCount: 8);
      expect(a, isNot(equals(b)));
    });
  });

  group('PlanSurah', () {
    test('displayLabel uses master name; ayat span when partial', () {
      final p = _planPartial(2, 1, 5);
      expect(p.displayLabel(_surah(2)), 'S2 (1–5)');
    });

    test('fromJson stores ids and segment only', () {
      final p = PlanSurah.fromJson({
        'surahId': 2,
        'isFullSurah': false,
        'startAyah': 255,
        'endAyah': 255,
      });
      const master = Surah(
        id: 2,
        name: 'Al-Baqarah',
        arabicName: 'ب',
        ayatCount: 286,
      );
      expect(p.displayLabel(master), 'Al-Baqarah (255)');
    });

    test('fromSurahPoolEntry copies segment fields', () {
      const entry = SurahPoolEntry(
        id: 9,
        surahId: 3,
        isFullSurah: false,
        startAyah: 10,
        endAyah: 20,
      );
      final p = PlanSurah.fromSurahPoolEntry(entry);
      expect(p.surahId, 3);
      expect(p.isFullSurah, false);
      expect(p.startAyah, 10);
      expect(p.endAyah, 20);
    });
  });

  group('SurahPoolEntry', () {
    test('displayLabel respects full vs partial', () {
      const master = Surah(
        id: 2,
        name: 'Al-Baqarah',
        arabicName: 'ب',
        ayatCount: 286,
      );
      const full = SurahPoolEntry(id: 1, surahId: 2, isFullSurah: true);
      expect(full.displayLabel(master), 'Al-Baqarah');
      const partial = SurahPoolEntry(
        id: 2,
        surahId: 2,
        isFullSurah: false,
        startAyah: 1,
        endAyah: 5,
      );
      expect(partial.displayLabel(master), 'Al-Baqarah (1–5)');
    });

    test('copyWith toggles enabled', () {
      const e = SurahPoolEntry(
        id: 1,
        surahId: 1,
        isFullSurah: true,
        enabled: true,
      );
      final d = e.copyWith(enabled: false);
      expect(e.enabled, true);
      expect(d.enabled, false);
    });
  });

  group('PrayerSlot', () {
    test('rejects more than PlanLimits.maxSurahsPerPrayerSlot surahs', () {
      final surahs = List.generate(
        PlanLimits.maxSurahsPerPrayerSlot + 1,
        _planFull,
      );
      expect(() => PrayerSlot(surahs: surahs), throwsArgumentError);
    });

    test('json round-trip preserves surahs', () {
      final slot = PrayerSlot(
        surahs: [_planFull(1), _planFull(2)],
        locked: true,
      );
      final json = slot.toJson();
      final back = PrayerSlot.fromJson(json);
      expect(back.surahs.length, 2);
      expect(back.surahs.first.surahId, 1);
      expect(back.locked, true);
    });
  });

  group('DayPlan', () {
    test('fromJson uses Prayer.values.byName for keys', () {
      final json = {
        'day': 3,
        'prayers': {
          'fajr': {
            'surahs': [
              {'surahId': 1, 'isFullSurah': true},
            ],
            'locked': false,
          },
        },
      };
      final day = DayPlan.fromJson(json);
      expect(day.day, 3);
      expect(day.slotFor(Prayer.fajr).surahs.single.surahId, 1);
    });

    test('fromJson throws on unknown prayer key', () {
      final json = {
        'day': 1,
        'prayers': {
          'notAPrayer': {'surahs': <dynamic>[], 'locked': false},
        },
      };
      expect(() => DayPlan.fromJson(json), throwsArgumentError);
    });
  });

  group('MonthPlan', () {
    test('planForDay returns null when missing', () {
      final plan = MonthPlan(
        month: 5,
        year: 2026,
        days: [DayPlan(day: 1, prayers: {})],
      );
      expect(plan.planForDay(99), isNull);
      expect(plan.planForDay(1), isNotNull);
    });

    test('isStaleAt compares to given instant', () {
      final plan = MonthPlan(month: 4, year: 2026, days: const []);
      expect(plan.isStaleAt(DateTime(2026, 4, 1)), false);
      expect(plan.isStaleAt(DateTime(2026, 5, 1)), true);
    });

    test('json round-trip', () {
      final original = MonthPlan(
        month: 6,
        year: 2026,
        days: [
          DayPlan(
            day: 10,
            prayers: {
              Prayer.maghrib: PrayerSlot(surahs: [_planFull(112)]),
            },
          ),
        ],
      );
      final back = MonthPlan.fromJson(original.toJson());
      expect(back.month, original.month);
      expect(back.year, original.year);
      expect(back.days.single.day, 10);
      expect(
        back.days.single.slotFor(Prayer.maghrib).surahs.single.surahId,
        112,
      );
    });
  });
}
