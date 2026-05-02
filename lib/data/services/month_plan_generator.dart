import 'dart:math';

import 'package:surah_planner/core/plan_config.dart';

import '../models/plan.dart';
import '../models/plan_surah.dart';
import '../models/prayer.dart';
import '../models/surah_pool_entry.dart';

/// Deterministic [MonthPlan] from enabled pool segments (XorShift per slot).
abstract final class MonthPlanGenerator {
  /// Builds a plan for [month]/[year]. Slots marked [PrayerSlot.locked] in
  /// [existingPlan] for the same calendar day/prayer are copied verbatim.
  static MonthPlan generate({
    required int month,
    required int year,
    required List<SurahPoolEntry> enabledPool,
    MonthPlan? existingPlan,
  }) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final days = <DayPlan>[];

    for (var day = 1; day <= daysInMonth; day++) {
      final existing = existingPlan?.planForDay(day);
      final prayers = <Prayer, PrayerSlot>{};

      for (final prayer in Prayer.values) {
        final existingSlot = existing?.slotFor(prayer);
        if (existingSlot != null && existingSlot.locked) {
          prayers[prayer] = existingSlot;
        } else {
          prayers[prayer] = _randomSlot(
            enabled: enabledPool,
            seed: _seed(year, month, day, prayer.index),
          );
        }
      }
      days.add(DayPlan(day: day, prayers: prayers));
    }

    return MonthPlan(month: month, year: year, days: days);
  }

  static PrayerSlot _randomSlot({
    required List<SurahPoolEntry> enabled,
    required int seed,
  }) {
    if (enabled.isEmpty) return PrayerSlot();
    if (enabled.length == 1) {
      return PrayerSlot(surahs: [PlanSurah.fromSurahPoolEntry(enabled.first)]);
    }

    final rng = _XorShift32(seed);
    final copy = List<SurahPoolEntry>.from(enabled);
    copy.shuffle(rng);
    final n = min(PlanLimits.maxSurahsPerPrayerSlot, copy.length);
    return PrayerSlot(
      surahs: copy.take(n).map(PlanSurah.fromSurahPoolEntry).toList(),
    );
  }

  static int _seed(int year, int month, int day, int prayerIdx) {
    return year * 100000 + month * 1000 + day * 10 + prayerIdx;
  }
}

/// XorShift32 implementing [Random] for [List.shuffle].
final class _XorShift32 implements Random {
  _XorShift32(int seed) : _state = seed == 0 ? 1 : seed & 0xFFFFFFFF;

  int _state;

  int _next() {
    _state ^= (_state << 13) & 0xFFFFFFFF;
    _state ^= _state >> 17;
    _state ^= (_state << 5) & 0xFFFFFFFF;
    _state &= 0xFFFFFFFF;
    return _state;
  }

  @override
  int nextInt(int max) => _next() % max;

  @override
  double nextDouble() => _next() / 0xFFFFFFFF;

  @override
  bool nextBool() => _next() % 2 == 0;
}
