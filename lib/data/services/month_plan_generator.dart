import 'dart:math';

import 'package:surah_planner/core/plan_config.dart';

import '../models/plan.dart';
import '../models/plan_surah.dart';
import '../models/prayer.dart';
import '../models/surah_pool_entry.dart';

/// Builds a [MonthPlan] from enabled hifdh-list rows using a round-robin deck.
///
/// The full pool is shuffled once, dealt slot by slot through the month, then
/// reshuffled when exhausted. Every surah appears before any surah repeats.
abstract final class MonthPlanGenerator {
  /// Builds a plan for [month]/[year].
  ///
  /// Slots marked [PrayerSlot.locked] in [existingPlan] for the same
  /// calendar day/prayer are copied verbatim and do not consume deck slots.
  ///
  /// [surahsPerPrayer] is clamped to [PlanLimits.maxSurahsPerPrayerSlot] and
  /// to the enabled pool size for each unlocked slot.
  static MonthPlan generate({
    required int month,
    required int year,
    required List<SurahPoolEntry> enabledPool,
    required int surahsPerPrayer,
    MonthPlan? existingPlan,
  }) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final days = <DayPlan>[];

    if (enabledPool.isEmpty) {
      for (var day = 1; day <= daysInMonth; day++) {
        days.add(
          DayPlan(
            day: day,
            prayers: {for (final p in Prayer.values) p: PrayerSlot()},
          ),
        );
      }
      return MonthPlan(month: month, year: year, days: days);
    }

    final deck = _RoundRobinDeck(entries: enabledPool);
    final perSlot = min(
      surahsPerPrayer.clamp(1, PlanLimits.maxSurahsPerPrayerSlot),
      enabledPool.length,
    );

    for (var day = 1; day <= daysInMonth; day++) {
      final existing = existingPlan?.planForDay(day);
      final prayers = <Prayer, PrayerSlot>{};

      for (final prayer in Prayer.values) {
        final existingSlot = existing?.slotFor(prayer);
        if (existingSlot != null && existingSlot.locked) {
          prayers[prayer] = existingSlot;
        } else {
          prayers[prayer] = PrayerSlot(
            surahs: deck
                .take(perSlot)
                .map(PlanSurah.fromSurahPoolEntry)
                .toList(),
          );
        }
      }
      days.add(DayPlan(day: day, prayers: prayers));
    }

    return MonthPlan(month: month, year: year, days: days);
  }
}

/// Deals through a shuffled pool and reshuffles on exhaustion.
class _RoundRobinDeck {
  _RoundRobinDeck({required List<SurahPoolEntry> entries})
    : _entries = List.from(entries) {
    _reshuffle();
  }

  final List<SurahPoolEntry> _entries;
  final _rng = Random();
  int _cursor = 0;
  late List<SurahPoolEntry> _deck;

  void _reshuffle() {
    _deck = List.from(_entries)..shuffle(_rng);
    _cursor = 0;
  }

  List<SurahPoolEntry> take(int n) {
    final result = <SurahPoolEntry>[];
    while (result.length < n) {
      if (_cursor >= _deck.length) _reshuffle();
      result.add(_deck[_cursor++]);
    }
    return result;
  }
}
