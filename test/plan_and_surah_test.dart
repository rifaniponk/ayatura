import 'package:flutter_test/flutter_test.dart';
import 'package:surah_planner/core/plan_config.dart';
import 'package:surah_planner/data/models/plan.dart';
import 'package:surah_planner/data/models/prayer.dart';
import 'package:surah_planner/data/models/surah.dart';

Surah _s(int id) => Surah(id: id, name: 'S$id', arabicName: 'x', ayatCount: 1);

void main() {
  group('Surah', () {
    test('displayName includes ayat range when set', () {
      const s = Surah(
        id: 201,
        name: 'Al-Baqarah',
        arabicName: 'ب',
        ayatCount: 5,
        ayatRange: '1-5',
      );
      expect(s.displayName, 'Al-Baqarah (1-5)');
    });

    test('copyWith replaces enabled immutably', () {
      const s = Surah(
        id: 1,
        name: 'A',
        arabicName: 'ب',
        ayatCount: 1,
        enabled: true,
      );
      final t = s.copyWith(enabled: false);
      expect(s.enabled, true);
      expect(t.enabled, false);
    });

    test('equality uses value fields', () {
      const a = Surah(
        id: 1,
        name: 'A',
        arabicName: 'ب',
        ayatCount: 1,
        enabled: true,
      );
      const b = Surah(
        id: 1,
        name: 'A',
        arabicName: 'ب',
        ayatCount: 1,
        enabled: false,
      );
      expect(a, isNot(equals(b)));
    });
  });

  group('PrayerSlot', () {
    test('rejects more than PlanLimits.maxSurahsPerPrayerSlot surahs', () {
      final surahs = List.generate(PlanLimits.maxSurahsPerPrayerSlot + 1, _s);
      expect(() => PrayerSlot(surahs: surahs), throwsArgumentError);
    });

    test('json round-trip preserves surahs', () {
      final slot = PrayerSlot(surahs: [_s(1), _s(2)], locked: true);
      final json = slot.toJson();
      final back = PrayerSlot.fromJson(json);
      expect(back.surahs.length, 2);
      expect(back.surahs.first.id, 1);
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
              {
                'id': 1,
                'name': 'Al-Fatihah',
                'arabicName': 'الفاتحة',
                'ayatCount': 7,
                'ayatRange': null,
                'enabled': true,
              },
            ],
            'locked': false,
          },
        },
      };
      final day = DayPlan.fromJson(json);
      expect(day.day, 3);
      expect(day.slotFor(Prayer.fajr).surahs.single.id, 1);
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
              Prayer.maghrib: PrayerSlot(surahs: [_s(112)]),
            },
          ),
        ],
      );
      final back = MonthPlan.fromJson(original.toJson());
      expect(back.month, original.month);
      expect(back.year, original.year);
      expect(back.days.single.day, 10);
      expect(back.days.single.slotFor(Prayer.maghrib).surahs.single.id, 112);
    });
  });
}
