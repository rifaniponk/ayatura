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

    final lockedKeys = <_PoolEntryKey>{};
    if (existingPlan != null) {
      for (final day in existingPlan.days) {
        for (final prayer in Prayer.values) {
          final slot = day.slotFor(prayer);
          if (!slot.locked) continue;
          for (final planSurah in slot.surahs) {
            lockedKeys.add(
              _PoolEntryKey(
                surahId: planSurah.surahId,
                isFullSurah: planSurah.isFullSurah,
                startAyah: planSurah.startAyah,
                endAyah: planSurah.endAyah,
              ),
            );
          }
        }
      }
    }
    final firstCycleEntries = enabledPool
        .where((e) => !lockedKeys.contains(_PoolEntryKey.fromPoolEntry(e)))
        .toList();
    final deck = _RoundRobinDeck(
      entries: enabledPool,
      firstCycleEntries: firstCycleEntries,
    );
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
  _RoundRobinDeck({
    required List<SurahPoolEntry> entries,
    required List<SurahPoolEntry> firstCycleEntries,
  }) : _entries = List.from(entries),
       _firstCycleEntries = List.from(firstCycleEntries) {
    _reshuffle();
  }

  final List<SurahPoolEntry> _entries;
  final List<SurahPoolEntry> _firstCycleEntries;
  final _rng = Random();
  int _cursor = 0;
  late List<SurahPoolEntry> _deck;
  late bool _firstCycleOnly;

  void _reshuffle() {
    _firstCycleOnly = _firstCycleEntries.isNotEmpty;
    _deck = List.from(_firstCycleOnly ? _firstCycleEntries : _entries)
      ..shuffle(_rng);
    _cursor = 0;
  }

  List<SurahPoolEntry> take(int n) {
    final result = <SurahPoolEntry>[];
    while (result.length < n) {
      if (_cursor >= _deck.length) {
        if (_firstCycleOnly) {
          _firstCycleOnly = false;
          _deck = List.from(_entries)..shuffle(_rng);
          _cursor = 0;
        } else {
          _deck = List.from(_entries)..shuffle(_rng);
          _cursor = 0;
        }
      }
      result.add(_deck[_cursor++]);
    }
    return result;
  }
}

class _PoolEntryKey {
  const _PoolEntryKey({
    required this.surahId,
    required this.isFullSurah,
    required this.startAyah,
    required this.endAyah,
  });

  factory _PoolEntryKey.fromPoolEntry(SurahPoolEntry entry) {
    return _PoolEntryKey(
      surahId: entry.surahId,
      isFullSurah: entry.isFullSurah,
      startAyah: entry.startAyah,
      endAyah: entry.endAyah,
    );
  }

  final int surahId;
  final bool isFullSurah;
  final int? startAyah;
  final int? endAyah;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _PoolEntryKey &&
          surahId == other.surahId &&
          isFullSurah == other.isFullSurah &&
          startAyah == other.startAyah &&
          endAyah == other.endAyah;

  @override
  int get hashCode => Object.hash(surahId, isFullSurah, startAyah, endAyah);
}
