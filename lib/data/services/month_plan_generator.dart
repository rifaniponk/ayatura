import 'dart:math';

import 'package:surah_planner/core/plan_config.dart';

import '../models/plan.dart';
import '../models/plan_surah.dart';
import '../models/prayer.dart';
import '../models/surah_pool_entry.dart';

/// Deterministic [MonthPlan] from enabled hifdh-list rows.
///
/// Uses a round-robin deck: the full pool is shuffled once, dealt slot by slot,
/// then reshuffled (with a different order) when exhausted. This guarantees
/// every surah appears roughly the same number of times before any repeats.
abstract final class MonthPlanGenerator {
  /// Builds a plan for [month]/[year].
  ///
  /// [salt] differentiates regenerations of the same month — pass a value
  /// derived from [DateTime.now()] in [regenerate()] so each tap produces
  /// a different plan while remaining internally consistent.
  ///
  /// Slots marked [PrayerSlot.locked] in [existingPlan] for the same
  /// calendar day/prayer are copied verbatim and do not consume deck slots.
  static MonthPlan generate({
    required int month,
    required int year,
    required List<SurahPoolEntry> enabledPool,
    MonthPlan? existingPlan,
    int salt = 0,
  }) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final days = <DayPlan>[];

    if (enabledPool.isEmpty) {
      for (var day = 1; day <= daysInMonth; day++) {
        days.add(DayPlan(
          day: day,
          prayers: {for (final p in Prayer.values) p: PrayerSlot()},
        ));
      }
      return MonthPlan(month: month, year: year, days: days);
    }

    final baseSeed = (year * 100000 + month * 1000 + salt) & 0x7FFFFFFF;
    final deck = _RoundRobinDeck(entries: enabledPool, baseSeed: baseSeed);

    for (var day = 1; day <= daysInMonth; day++) {
      final existing = existingPlan?.planForDay(day);
      final prayers = <Prayer, PrayerSlot>{};

      for (final prayer in Prayer.values) {
        final existingSlot = existing?.slotFor(prayer);
        if (existingSlot != null && existingSlot.locked) {
          prayers[prayer] = existingSlot;
        } else {
          final n = min(PlanLimits.maxSurahsPerPrayerSlot, enabledPool.length);
          prayers[prayer] = PrayerSlot(
            surahs: deck.take(n).map(PlanSurah.fromSurahPoolEntry).toList(),
          );
        }
      }
      days.add(DayPlan(day: day, prayers: prayers));
    }

    return MonthPlan(month: month, year: year, days: days);
  }
}

/// Round-robin deck: deals through a shuffled pool, reshuffles on exhaustion.
///
/// Each cycle uses a different shuffle so consecutive passes don't repeat
/// the same order, while remaining fully deterministic for a given [baseSeed].
class _RoundRobinDeck {
  _RoundRobinDeck({
    required List<SurahPoolEntry> entries,
    required int baseSeed,
  })  : _entries = List.from(entries),
        _baseSeed = baseSeed {
    _reshuffle();
  }

  final List<SurahPoolEntry> _entries;
  final int _baseSeed;
  int _cycle = 0;
  int _cursor = 0;
  late List<SurahPoolEntry> _deck;

  void _reshuffle() {
    _deck = List.from(_entries);
    // XOR with a cycle-dependent constant so each pass produces a new order.
    final seed = (_baseSeed ^ (_cycle * 0x9e3779b9)) & 0x7FFFFFFF;
    _deck.shuffle(_XorShift32(seed == 0 ? 1 : seed));
    _cycle++;
    _cursor = 0;
  }

  /// Returns [n] entries, reshuffling the deck whenever it runs out.
  List<SurahPoolEntry> take(int n) {
    final result = <SurahPoolEntry>[];
    while (result.length < n) {
      if (_cursor >= _deck.length) _reshuffle();
      result.add(_deck[_cursor++]);
    }
    return result;
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
