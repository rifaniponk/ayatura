import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ayatura/data/local/app_database.dart';
import 'package:ayatura/data/models/plan.dart';
import 'package:ayatura/data/models/plan_surah.dart';
import 'package:ayatura/data/models/prayer.dart';

MonthPlan _samplePlan({required int year, required int month}) {
  return MonthPlan(
    month: month,
    year: year,
    days: [
      DayPlan(
        day: 1,
        prayers: {
          Prayer.fajr: PrayerSlot(
            surahs: [PlanSurah(surahId: 1, isFullSurah: true)],
          ),
        },
      ),
    ],
  );
}

void main() {
  group('Month plan persistence (Drift)', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test('savePlan + loadLatestPlan round-trip matches JSON', () async {
      final original = _samplePlan(year: 2026, month: 5);
      await db.savePlan(original);
      final loaded = await db.loadLatestPlan();
      expect(loaded, isNotNull);
      expect(jsonEncode(loaded!.toJson()), jsonEncode(original.toJson()));
    });

    test('savePlan replaces all rows — only the last save survives', () async {
      await db.savePlan(_samplePlan(year: 2026, month: 4));
      await db.savePlan(_samplePlan(year: 2026, month: 6));
      final loaded = await db.loadLatestPlan();
      expect(loaded!.month, 6);
      expect(loaded.year, 2026);
    });

    test(
      'loadLatestPlan returns most recent by year/month when multiple rows exist',
      () async {
        // Insert two rows directly (bypassing savePlan's delete-all) to verify ordering.
        await db
            .into(db.monthPlans)
            .insert(
              MonthPlansCompanion.insert(
                year: 2026,
                month: 3,
                planJson: jsonEncode(
                  _samplePlan(year: 2026, month: 3).toJson(),
                ),
              ),
            );
        await db
            .into(db.monthPlans)
            .insert(
              MonthPlansCompanion.insert(
                year: 2026,
                month: 11,
                planJson: jsonEncode(
                  _samplePlan(year: 2026, month: 11).toJson(),
                ),
              ),
            );
        final loaded = await db.loadLatestPlan();
        expect(loaded!.year, 2026);
        expect(loaded.month, 11);
      },
    );

    test('deletePlan removes stored row', () async {
      final plan = _samplePlan(year: 2026, month: 3);
      await db.savePlan(plan);
      await db.deletePlan(plan.year, plan.month);
      expect(await db.loadLatestPlan(), isNull);
    });

    test('locked slot survives persistence round-trip', () async {
      final plan = MonthPlan(
        month: 8,
        year: 2026,
        days: [
          DayPlan(
            day: 1,
            prayers: {
              Prayer.isha: PrayerSlot(
                locked: true,
                surahs: const [PlanSurah(surahId: 67, isFullSurah: true)],
              ),
            },
          ),
        ],
      );
      await db.savePlan(plan);
      final loaded = await db.loadLatestPlan();
      expect(loaded, isNotNull);
      expect(loaded!.planForDay(1)!.slotFor(Prayer.isha).locked, isTrue);
      expect(
        loaded.planForDay(1)!.slotFor(Prayer.isha).surahs.first.surahId,
        67,
      );
    });
  });
}
