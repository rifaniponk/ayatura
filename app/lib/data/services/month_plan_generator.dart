import 'dart:math';

import 'package:ayatura/core/plan_config.dart';

import '../models/plan.dart';
import '../models/plan_surah.dart';
import '../models/prayer.dart';
import '../models/surah_pool_entry.dart';

/// Builds a [MonthPlan] from enabled hifdh-list rows with fair distribution.
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
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final isCurrentMonth = current.month == month && current.year == year;
    final generationStartDay = isCurrentMonth ? current.day : 1;
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

    final lockedKeys = <String>{};
    if (existingPlan != null) {
      for (final day in existingPlan.days) {
        for (final prayer in Prayer.values) {
          final slot = day.slotFor(prayer);
          if (!slot.locked) continue;
          for (final planSurah in slot.surahs) {
            lockedKeys.add(_planSurahKey(planSurah));
          }
        }
      }
    }
    final orderedPool = List<SurahPoolEntry>.from(enabledPool)
      ..sort((a, b) {
        final countCompare = a.assignmentCount.compareTo(b.assignmentCount);
        if (countCompare != 0) return countCompare;
        return a.id.compareTo(b.id);
      });
    final firstCycleEntries = orderedPool
        .where((entry) => !lockedKeys.contains(_poolEntryKey(entry)))
        .toList();
    var queue = firstCycleEntries.isEmpty
        ? List<SurahPoolEntry>.from(orderedPool)
        : List<SurahPoolEntry>.from(firstCycleEntries);
    var firstCycleOnly = firstCycleEntries.isNotEmpty;
    var cursor = 0;
    final perSlot = min(
      surahsPerPrayer.clamp(1, PlanLimits.maxSurahsPerPrayerSlot),
      orderedPool.length,
    );
    final slotsPerDay = Prayer.values.length * perSlot;
    final allowSameDayRepeats = orderedPool.length < slotsPerDay;

    for (var day = 1; day <= daysInMonth; day++) {
      final existing = existingPlan?.planForDay(day);
      if (day < generationStartDay) {
        if (existing != null) {
          days.add(existing);
        } else {
          days.add(
            DayPlan(
              day: day,
              prayers: {for (final p in Prayer.values) p: PrayerSlot()},
            ),
          );
        }
        continue;
      }
      final prayers = <Prayer, PrayerSlot>{};
      final usedToday = <String>{};

      for (final prayer in Prayer.values) {
        final existingSlot = existing?.slotFor(prayer);
        if (existingSlot != null && existingSlot.locked) {
          for (final s in existingSlot.surahs) {
            usedToday.add(_planSurahKey(s));
          }
          prayers[prayer] = existingSlot;
        } else {
          final assigned = <PlanSurah>[];
          for (var i = 0; i < perSlot; i++) {
            var skippedInCurrentQueue = 0;
            while (true) {
              if (cursor >= queue.length) {
                if (firstCycleOnly) {
                  firstCycleOnly = false;
                  queue = List<SurahPoolEntry>.from(orderedPool);
                  cursor = 0;
                  skippedInCurrentQueue = 0;
                } else {
                  cursor = 0;
                }
              }

              final entry = queue[cursor++];
              final key = _poolEntryKey(entry);
              if (!usedToday.contains(key)) {
                usedToday.add(key);
                assigned.add(PlanSurah.fromSurahPoolEntry(entry));
                break;
              }

              skippedInCurrentQueue++;
              if (skippedInCurrentQueue >= queue.length) {
                if (firstCycleOnly) {
                  firstCycleOnly = false;
                  queue = List<SurahPoolEntry>.from(orderedPool);
                  cursor = 0;
                } else if (allowSameDayRepeats) {
                  // Fallback: when all unique entries are already used today,
                  // allow repeats after resetting the day set.
                  usedToday.clear();
                }
                skippedInCurrentQueue = 0;
              }
            }
          }
          prayers[prayer] = PrayerSlot(surahs: assigned);
        }
      }
      days.add(DayPlan(day: day, prayers: prayers));
    }

    return MonthPlan(month: month, year: year, days: days);
  }
}

String _poolEntryKey(SurahPoolEntry entry) =>
    '${entry.surahId}|${entry.isFullSurah}|${entry.startAyah}|${entry.endAyah}';

String _planSurahKey(PlanSurah surah) =>
    '${surah.surahId}|${surah.isFullSurah}|${surah.startAyah}|${surah.endAyah}';
