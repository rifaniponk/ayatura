import '../local/app_database.dart';
import '../models/plan.dart';
import '../models/plan_surah.dart';
import '../models/prayer.dart';
import '../models/prayer_times.dart';
import '../models/surah.dart';
import '../models/widget_payload.dart';

class WidgetPayloadService {
  const WidgetPayloadService(this._db);

  final AppDatabase _db;

  Future<WidgetPayload> build({
    required PrayerTimes prayerTimes,
    DateTime? now,
  }) async {
    final at = now ?? DateTime.now();
    final masterById = {
      for (final surah in await _db.allSurahs()) surah.id: surah,
    };
    final plan = await _db.loadLatestPlan();

    if (plan == null) {
      return WidgetPayload(
        state: 'no_plan',
        generatedAtIso8601: at.toIso8601String(),
      );
    }
    if (plan.isStaleAt(at)) {
      return WidgetPayload(
        state: 'expired',
        generatedAtIso8601: at.toIso8601String(),
      );
    }

    final todayPlan = plan.planForDay(at.day);
    final window = _resolveWindow(at, prayerTimes);
    final nextDate = DateTime(
      at.year,
      at.month,
      at.day + (window.nextIsTomorrow ? 1 : 0),
    );
    final nextDayPlan = window.nextIsTomorrow
        ? _nextDayPlan(plan, at)
        : todayPlan;
    final nextTargetAt = _atMinutes(
      nextDate,
      prayerTimes.minutesFor(window.nextPrayer),
    );

    return WidgetPayload(
      state: 'ready',
      generatedAtIso8601: at.toIso8601String(),
      current: window.currentPrayer == null
          ? null
          : WidgetPrayerBlock(
              prayer: window.currentPrayer!.label,
              time: prayerTimes.formattedFor(window.currentPrayer!),
              surahs: _toRows(
                todayPlan?.slotFor(window.currentPrayer!).surahs ?? const [],
                masterById,
              ),
            ),
      next: WidgetPrayerBlock(
        prayer: window.nextPrayer.label,
        time: prayerTimes.formattedFor(window.nextPrayer),
        countdownMinutes: _safeCountdownMinutes(at, nextTargetAt),
        isTomorrow: window.nextIsTomorrow,
        surahs: _toRows(
          nextDayPlan?.slotFor(window.nextPrayer).surahs ?? const [],
          masterById,
        ),
      ),
    );
  }

  DayPlan? _nextDayPlan(MonthPlan plan, DateTime at) {
    final tomorrow = at.add(const Duration(days: 1));
    if (tomorrow.year != plan.year || tomorrow.month != plan.month) {
      return null;
    }
    return plan.planForDay(tomorrow.day);
  }

  List<WidgetSurahRow> _toRows(
    List<PlanSurah> surahs,
    Map<int, Surah> masterById,
  ) {
    return surahs.take(4).map((surah) {
      final master = masterById[surah.surahId];
      final name = master?.name ?? 'Surah ${surah.surahId}';
      final ayat = _ayatRangeText(surah, master);
      return WidgetSurahRow(name: name, ayat: ayat);
    }).toList();
  }

  String _ayatRangeText(PlanSurah surah, Surah? master) {
    if (surah.isFullSurah) {
      if (master == null) return 'Full surah';
      return '1 - ${master.ayatCount}';
    }
    final start = surah.startAyah;
    final end = surah.endAyah;
    if (start != null && end != null) {
      return '$start - $end';
    }
    return '-';
  }

  int _safeCountdownMinutes(DateTime from, DateTime to) {
    final raw = to.difference(from).inMinutes;
    return raw < 0 ? 0 : raw;
  }

  DateTime _atMinutes(DateTime day, int totalMinutes) {
    return DateTime(
      day.year,
      day.month,
      day.day,
      totalMinutes ~/ 60,
      totalMinutes % 60,
    );
  }

  _Window _resolveWindow(DateTime now, PrayerTimes prayerTimes) {
    final t = now.hour * 60 + now.minute;
    final fajr = prayerTimes.fajrMinutes;
    final dhuhr = prayerTimes.dhuhrMinutes;
    final asr = prayerTimes.asrMinutes;
    final maghrib = prayerTimes.maghribMinutes;
    final isha = prayerTimes.ishaMinutes;

    if (t < fajr) {
      return const _Window(currentPrayer: null, nextPrayer: Prayer.fajr);
    }
    if (t < dhuhr) {
      return const _Window(
        currentPrayer: Prayer.fajr,
        nextPrayer: Prayer.dhuhr,
      );
    }
    if (t < asr) {
      return const _Window(currentPrayer: Prayer.dhuhr, nextPrayer: Prayer.asr);
    }
    if (t < maghrib) {
      return const _Window(
        currentPrayer: Prayer.asr,
        nextPrayer: Prayer.maghrib,
      );
    }
    if (t < isha) {
      return const _Window(
        currentPrayer: Prayer.maghrib,
        nextPrayer: Prayer.isha,
      );
    }
    return const _Window(
      currentPrayer: Prayer.isha,
      nextPrayer: Prayer.fajr,
      nextIsTomorrow: true,
    );
  }
}

class _Window {
  const _Window({
    required this.currentPrayer,
    required this.nextPrayer,
    this.nextIsTomorrow = false,
  });

  final Prayer? currentPrayer;
  final Prayer nextPrayer;
  final bool nextIsTomorrow;
}
