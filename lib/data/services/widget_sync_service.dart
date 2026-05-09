import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../../providers/core/database_provider.dart';
import '../../providers/core/locale_provider.dart';
import '../../providers/quran/surah_data_providers.dart';
import '../models/day_plan.dart';
import '../models/plan_surah.dart';
import '../models/prayer.dart';
import '../models/surah.dart';
import '../local/app_database.dart';

const widgetPayloadKey = 'widget_payload';
const _androidWidgetQualifiedName =
    'com.ponkcoding.surahplanner.widget.SurahPlannerWidgetReceiver';

abstract final class WidgetSyncService {
  static Future<void> syncFromWidgetRef(WidgetRef ref) async {
    try {
      await HomeWidget.setAppGroupId('group.com.ponkcoding.surahplanner');
      final payload = await _buildPayloadFromWidgetRef(ref);
      await HomeWidget.saveWidgetData<String>(
        widgetPayloadKey,
        jsonEncode(payload),
      );
      await HomeWidget.updateWidget(
        iOSName: 'SurahPlannerWidget',
        qualifiedAndroidName: _androidWidgetQualifiedName,
      );
    } catch (error, stackTrace) {
      // Widget sync must never crash user flows.
      debugPrint(
        'WidgetSyncService.syncFromWidgetRef failed: $error\n$stackTrace',
      );
    }
  }

  static Future<void> sync(Ref ref) async {
    try {
      await HomeWidget.setAppGroupId('group.com.ponkcoding.surahplanner');
      final payload = await _buildPayloadFromRef(ref);
      await HomeWidget.saveWidgetData<String>(
        widgetPayloadKey,
        jsonEncode(payload),
      );
      await HomeWidget.updateWidget(
        iOSName: 'SurahPlannerWidget',
        qualifiedAndroidName: _androidWidgetQualifiedName,
      );
    } catch (error, stackTrace) {
      // Widget sync must never crash user flows.
      debugPrint('WidgetSyncService.sync failed: $error\n$stackTrace');
    }
  }

  static Future<Map<String, dynamic>> _buildPayloadFromRef(Ref ref) async {
    await ref.read(seededDatabaseProvider.future);
    final db = ref.read(appDatabaseProvider);
    return _buildPayloadCore(
      db: db,
      localeCode: ref.read(localeProvider).languageCode,
      surahs: await ref.read(surahsAsyncProvider.future),
    );
  }

  static Future<Map<String, dynamic>> _buildPayloadFromWidgetRef(
    WidgetRef ref,
  ) async {
    await ref.read(seededDatabaseProvider.future);
    final db = ref.read(appDatabaseProvider);
    return _buildPayloadCore(
      db: db,
      localeCode: ref.read(localeProvider).languageCode,
      surahs: await ref.read(surahsAsyncProvider.future),
    );
  }

  static Future<Map<String, dynamic>> _buildPayloadCore({
    required AppDatabase db,
    required String localeCode,
    required List<Surah> surahs,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final todayPrayerTimes = await db.prayerTimeByDate(_isoDate(today));
    final tomorrowPrayerTimes = await db.prayerTimeByDate(_isoDate(tomorrow));
    final todayPlan = await db.loadPlan(today.year, today.month);
    final todayDayPlan = todayPlan?.planForDay(today.day);

    if (todayPlan == null || todayDayPlan == null) {
      final latest = await db.loadLatestPlan();
      final status = latest == null ? 'no_plan' : 'plan_expired';
      return {
        'schemaVersion': 1,
        'generatedAt': now.toIso8601String(),
        'status': status,
      };
    }

    final tomorrowPlan = await db.loadPlan(tomorrow.year, tomorrow.month);
    final tomorrowDayPlan = tomorrowPlan?.planForDay(tomorrow.day);
    final surahById = {for (final surah in surahs) surah.id: surah};
    final locale = localeCode;
    final prayerTimes = _prayerTimesMap(todayPrayerTimes);

    final resolved = _resolveCurrentAndNext(
      now: now,
      todayPrayerTimes: todayPrayerTimes,
      tomorrowPrayerTimes: tomorrowPrayerTimes,
      today: todayDayPlan,
      tomorrow: tomorrowDayPlan,
      surahById: surahById,
      languageCode: locale,
    );

    return {
      'schemaVersion': 1,
      'generatedAt': now.toIso8601String(),
      'status': 'ready',
      'todayDate': DateFormat('yyyy-MM-dd').format(today),
      'tomorrowDate': DateFormat('yyyy-MM-dd').format(tomorrow),
      'todaySunrise': todayPrayerTimes?.sunrise,
      'prayerTimes': _prayerTimesJson(prayerTimes),
      'todaySlots': _slotsJson(
        dayPlan: todayDayPlan,
        surahById: surahById,
        languageCode: locale,
      ),
      'tomorrowSlots': _slotsJson(
        dayPlan: tomorrowDayPlan,
        surahById: surahById,
        languageCode: locale,
      ),
      'current': resolved.$1,
      'next': resolved.$2,
    };
  }
}

Map<String, String> _prayerTimesJson(Map<Prayer, String> prayerTimes) {
  return {
    for (final prayer in Prayer.values) prayer.name: prayerTimes[prayer]!,
  };
}

Map<String, dynamic> _slotsJson({
  required DayPlan? dayPlan,
  required Map<int, Surah> surahById,
  required String languageCode,
}) {
  if (dayPlan == null) {
    return {
      for (final prayer in Prayer.values) prayer.name: <Map<String, dynamic>>[],
    };
  }
  return {
    for (final prayer in Prayer.values)
      prayer.name: _surahsJson(
        dayPlan.slotFor(prayer).surahs,
        surahById: surahById,
        languageCode: languageCode,
      ),
  };
}

List<Map<String, dynamic>> _surahsJson(
  List<PlanSurah> surahs, {
  required Map<int, Surah> surahById,
  required String languageCode,
}) {
  return surahs
      .take(4)
      .map((planSurah) {
        final master = surahById[planSurah.surahId];
        if (master == null) {
          return {'name': '#${planSurah.surahId}', 'ayat': ''};
        }
        return {
          'name': master.localizedName(languageCode),
          'ayat': _ayatRange(planSurah, master),
        };
      })
      .toList(growable: false);
}

String _ayatRange(PlanSurah planSurah, Surah master) {
  if (planSurah.isFullSurah) {
    return '1 - ${master.ayatCount}';
  }
  final start = planSurah.startAyah;
  final end = planSurah.endAyah;
  if (start == null || end == null) return '';
  return '$start - $end';
}

(Map<String, dynamic>?, Map<String, dynamic>?) _resolveCurrentAndNext({
  required DateTime now,
  required PrayerTime? todayPrayerTimes,
  required PrayerTime? tomorrowPrayerTimes,
  required DayPlan today,
  required DayPlan? tomorrow,
  required Map<int, Surah> surahById,
  required String languageCode,
}) {
  if (todayPrayerTimes == null) {
    return (null, null);
  }

  final schedule = <Prayer, DateTime?>{
    for (final prayer in Prayer.values)
      prayer: _parseOn(now, _rawPrayerTime(todayPrayerTimes, prayer)),
  };
  if (schedule.values.any((value) => value == null)) {
    return (null, null);
  }

  final parsedSchedule = {
    for (final entry in schedule.entries) entry.key: entry.value!,
  };
  final sunrise = _parseOn(now, todayPrayerTimes.sunrise);
  final tomorrowFajr = tomorrowPrayerTimes == null
      ? null
      : _parseOn(now.add(const Duration(days: 1)), tomorrowPrayerTimes.fajr);
  Prayer? current;
  Prayer? next;
  final fajrAt = parsedSchedule[Prayer.fajr]!;
  if (sunrise != null && !now.isBefore(fajrAt) && now.isBefore(sunrise)) {
    current = Prayer.fajr;
  } else {
    for (final prayer in Prayer.values) {
      final at = parsedSchedule[prayer]!;
      if (at.isAfter(now)) break;
      if (prayer == Prayer.fajr && sunrise != null) continue;
      current = prayer;
    }
  }
  for (final prayer in Prayer.values) {
    final at = parsedSchedule[prayer]!;
    if (at.isAfter(now)) {
      next = prayer;
      break;
    }
  }

  final currentJson = current == null
      ? null
      : _slotJson(
          prayer: current,
          at: parsedSchedule[current]!,
          dayPlan: today,
          surahById: surahById,
          languageCode: languageCode,
          isTomorrow: false,
          countdownMinutes: null,
        );

  final nextPrayer = next ?? Prayer.fajr;
  final nextIsTomorrow = next == null;
  final nextDate = nextIsTomorrow ? tomorrowFajr : parsedSchedule[nextPrayer];
  if (nextDate == null) {
    return (currentJson, null);
  }

  final countdown = nextDate.isBefore(now)
      ? 0
      : nextDate.difference(now).inMinutes;

  final nextJson = _slotJson(
    prayer: nextPrayer,
    at: nextDate,
    dayPlan: nextIsTomorrow ? tomorrow : today,
    surahById: surahById,
    languageCode: languageCode,
    isTomorrow: nextIsTomorrow,
    countdownMinutes: countdown,
  );

  return (currentJson, nextJson);
}

Map<Prayer, String> _prayerTimesMap(PrayerTime? row) {
  if (row == null) {
    return const {};
  }
  return {
    Prayer.fajr: row.fajr,
    Prayer.dhuhr: row.dhuhr,
    Prayer.asr: row.asr,
    Prayer.maghrib: row.maghrib,
    Prayer.isha: row.isha,
  };
}

String _rawPrayerTime(PrayerTime row, Prayer prayer) {
  switch (prayer) {
    case Prayer.fajr:
      return row.fajr;
    case Prayer.dhuhr:
      return row.dhuhr;
    case Prayer.asr:
      return row.asr;
    case Prayer.maghrib:
      return row.maghrib;
    case Prayer.isha:
      return row.isha;
  }
}

Map<String, dynamic> _slotJson({
  required Prayer prayer,
  required DateTime at,
  required DayPlan? dayPlan,
  required Map<int, Surah> surahById,
  required String languageCode,
  required bool isTomorrow,
  required int? countdownMinutes,
}) {
  final surahs = dayPlan == null
      ? const <PlanSurah>[]
      : dayPlan.slotFor(prayer).surahs;
  return {
    'prayer': prayer.name,
    'label': prayer.label,
    'time': DateFormat('HH:mm').format(at),
    'isTomorrow': isTomorrow,
    'countdownMinutes': countdownMinutes,
    'surahs': _surahsJson(
      surahs,
      surahById: surahById,
      languageCode: languageCode,
    ),
  };
}

DateTime? _parseOn(DateTime day, String? hhmm) {
  if (hhmm == null || hhmm.isEmpty) return null;
  final parts = hhmm.split(':');
  if (parts.length < 2) return null;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return null;
  return DateTime(day.year, day.month, day.day, hour, minute);
}

String _isoDate(DateTime d) => DateFormat('yyyy-MM-dd').format(d);
