import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/core/database_provider.dart';
import '../../providers/core/locale_provider.dart';
import '../../providers/quran/surah_data_providers.dart';
import '../models/day_plan.dart';
import '../models/month_plan.dart';
import '../models/plan_surah.dart';
import '../models/prayer.dart';
import '../models/surah.dart';
import '../local/app_database.dart';

const widgetPayloadKey = 'widget_payload';

const _widgetDayWindow = 7;
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
    final l10n = lookupS(Locale(localeCode));
    final stringsPayload = _widgetUiStrings(l10n);
    final todayPlan = await db.loadPlan(today.year, today.month);
    final todayDayPlan = todayPlan?.planForDay(today.day);

    if (todayPlan == null || todayDayPlan == null) {
      final latest = await db.loadLatestPlan();
      final status = latest == null ? 'no_plan' : 'plan_expired';
      return {
        'generatedAt': now.toIso8601String(),
        'status': status,
        'locale': localeCode,
        'strings': stringsPayload,
      };
    }

    final windowDates = List<DateTime>.generate(
      _widgetDayWindow,
      (i) => today.add(Duration(days: i)),
    );
    final isoDates = windowDates.map(_isoDate).toList(growable: false);
    final prayersByDate = await db.prayerTimesByDates(isoDates);

    final surahById = {for (final surah in surahs) surah.id: surah};
    final locale = localeCode;

    final monthPlanCache = <String, MonthPlan?>{};
    Future<MonthPlan?> monthPlanFor(DateTime d) async {
      final cacheKey = '${d.year}-${d.month}';
      if (monthPlanCache.containsKey(cacheKey)) {
        return monthPlanCache[cacheKey];
      }
      final loaded = await db.loadPlan(d.year, d.month);
      monthPlanCache[cacheKey] = loaded;
      return loaded;
    }

    bool rowPrayersComplete(PrayerTime row) {
      final m = _prayerTimesMap(row);
      for (final prayer in Prayer.values) {
        final v = m[prayer];
        if (v == null || v.trim().isEmpty) {
          return false;
        }
      }
      return true;
    }

    final days = <String, dynamic>{};
    for (var i = 0; i < windowDates.length; i++) {
      final d = windowDates[i];
      final iso = isoDates[i];
      final row = prayersByDate[iso];
      if (row == null || !rowPrayersComplete(row)) {
        continue;
      }
      final prayerTimes = _prayerTimesMap(row);
      final plan = await monthPlanFor(d);
      final dayPlan = plan?.planForDay(d.day);
      days[iso] = {
        'sunrise': row.sunrise,
        'prayerTimes': _prayerTimesJson(prayerTimes),
        'slots': _slotsJson(
          dayPlan: dayPlan,
          surahById: surahById,
          languageCode: locale,
        ),
      };
    }

    return {
      'generatedAt': now.toIso8601String(),
      'status': 'ready',
      'locale': localeCode,
      'strings': stringsPayload,
      'days': days,
    };
  }
}

Map<String, dynamic> _widgetUiStrings(S l10n) {
  return {
    'widgetEmptyNoPlanTitle': l10n.widgetEmptyNoPlanTitle,
    'widgetEmptyNoPlanSubtitle': l10n.widgetEmptyNoPlanSubtitle,
    'widgetEmptyPlanExpiredTitle': l10n.widgetEmptyPlanExpiredTitle,
    'widgetEmptyPlanExpiredSubtitle': l10n.widgetEmptyPlanExpiredSubtitle,
    'widgetEmptyStaleTitle': l10n.widgetEmptyStaleTitle,
    'widgetEmptyStaleSubtitle': l10n.widgetEmptyStaleSubtitle,
    'widgetTomorrowMarker': l10n.widgetTomorrowMarker,
    'prayerLabels': {
      for (final p in Prayer.values) p.name: _prayerDisplayLabel(l10n, p),
    },
  };
}

String _prayerDisplayLabel(S l10n, Prayer prayer) {
  switch (prayer) {
    case Prayer.fajr:
      return l10n.prayerFajr;
    case Prayer.dhuhr:
      return l10n.prayerDhuhr;
    case Prayer.asr:
      return l10n.prayerAsr;
    case Prayer.maghrib:
      return l10n.prayerMaghrib;
    case Prayer.isha:
      return l10n.prayerIsha;
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

Map<Prayer, String> _prayerTimesMap(PrayerTime row) {
  return {
    Prayer.fajr: row.fajr,
    Prayer.dhuhr: row.dhuhr,
    Prayer.asr: row.asr,
    Prayer.maghrib: row.maghrib,
    Prayer.isha: row.isha,
  };
}

String _isoDate(DateTime d) => DateFormat('yyyy-MM-dd').format(d);
