part of '../../screens/home_screen.dart';

class _PrayerCardState {
  const _PrayerCardState({
    required this.referenceNow,
    required this.times,
    required this.currentPrayer,
    required this.upcomingPrayer,
    required this.tomorrowFajr,
    required this.sunrise,
  });

  final DateTime referenceNow;
  final Map<Prayer, DateTime> times;
  final Prayer? currentPrayer;
  final Prayer? upcomingPrayer;
  final DateTime? tomorrowFajr;
  final DateTime? sunrise;

  static _PrayerCardState from({
    required DateTime now,
    PrayerTime? todayRow,
    PrayerTime? tomorrowRow,
  }) {
    if (todayRow == null) {
      return _PrayerCardState(
        referenceNow: DateTime.fromMillisecondsSinceEpoch(0),
        times: {},
        currentPrayer: null,
        upcomingPrayer: null,
        tomorrowFajr: null,
        sunrise: null,
      );
    }
    final parsed = <Prayer, DateTime>{};
    DateTime? parseOn(DateTime day, String hhmm) {
      final chunks = hhmm.split(':');
      if (chunks.length < 2) return null;
      final h = int.tryParse(chunks[0]);
      final m = int.tryParse(chunks[1]);
      if (h == null || m == null) return null;
      return DateTime(day.year, day.month, day.day, h, m);
    }

    void add(Prayer prayer, String hhmm) {
      final parsedAt = parseOn(now, hhmm);
      if (parsedAt == null) return;
      parsed[prayer] = parsedAt;
    }

    add(Prayer.fajr, todayRow.fajr);
    add(Prayer.dhuhr, todayRow.dhuhr);
    add(Prayer.asr, todayRow.asr);
    add(Prayer.maghrib, todayRow.maghrib);
    add(Prayer.isha, todayRow.isha);
    final sunriseRaw = todayRow.sunrise;
    final sunriseAt = sunriseRaw != null && sunriseRaw.isNotEmpty
        ? parseOn(now, sunriseRaw)
        : null;
    final fajrAt = parsed[Prayer.fajr];
    Prayer? current;
    if (fajrAt != null &&
        sunriseAt != null &&
        !now.isBefore(fajrAt) &&
        now.isBefore(sunriseAt)) {
      current = Prayer.fajr;
    } else {
      for (final prayer in Prayer.values) {
        final at = parsed[prayer];
        if (at == null) continue;
        if (at.isAfter(now)) break;
        if (prayer == Prayer.fajr && sunriseAt != null) continue;
        current = prayer;
      }
    }
    Prayer? upcoming;
    for (final prayer in Prayer.values) {
      final at = parsed[prayer];
      if (at == null) continue;
      if (at.isAfter(now)) {
        upcoming = prayer;
        break;
      }
    }
    return _PrayerCardState(
      referenceNow: now,
      times: parsed,
      currentPrayer: current,
      upcomingPrayer: upcoming,
      tomorrowFajr: tomorrowRow == null
          ? null
          : parseOn(now.add(const Duration(days: 1)), tomorrowRow.fajr),
      sunrise: sunriseAt,
    );
  }

  _PrayerCardStatus statusFor(Prayer prayer, S s) {
    if (times.isEmpty) return const _PrayerCardStatus();
    if (prayer == currentPrayer) {
      final currentAt = times[prayer];
      final nextAt = nextTimeAfterCurrent();
      final progress = (currentAt != null && nextAt != null)
          ? _windowProgress(currentAt, nextAt)
          : null;
      final trailing = _countdownTo(nextAt);
      return _PrayerCardStatus(
        badge: s.homeNowPrayingBadge,
        subtitle: displayTimeFor(prayer) == null
            ? null
            : s.homePrayerStartedAt(displayTimeFor(prayer)!),
        progress: progress,
        progressLeft: null,
        progressRight: trailing == null
            ? null
            : s.homePrayerUntilNext(trailing),
        highlight: PrayerCardHighlight.current,
      );
    }
    if (prayer == upcomingPrayer) {
      return _PrayerCardStatus(
        badge: s.homeUpNextBadge,
        trailing: _countdownTo(times[prayer]),
        highlight: PrayerCardHighlight.upcoming,
      );
    }
    final isPast = _isPastPrayer(prayer);
    return _PrayerCardStatus(
      highlight: isPast ? PrayerCardHighlight.past : PrayerCardHighlight.normal,
    );
  }

  bool _isPastPrayer(Prayer prayer) {
    final at = times[prayer];
    if (at == null) return false;
    if (prayer == Prayer.fajr) {
      if (sunrise != null) {
        if (referenceNow.isBefore(at)) return false;
        return !referenceNow.isBefore(sunrise!);
      }
      if (currentPrayer != null) {
        return at.isBefore(times[currentPrayer!]!);
      }
      return referenceNow.isAfter(at);
    }
    if (currentPrayer != null) {
      return at.isBefore(times[currentPrayer!]!);
    }
    return false;
  }

  String? displayTimeFor(Prayer prayer) {
    final at = times[prayer];
    if (at == null) return null;
    return DateFormat('HH:mm').format(at);
  }

  DateTime? nextTimeAfterCurrent() {
    if (currentPrayer == null) return null;
    if (currentPrayer == Prayer.fajr &&
        sunrise != null &&
        referenceNow.isBefore(sunrise!)) {
      return sunrise;
    }
    if (upcomingPrayer != null) return times[upcomingPrayer!];
    return tomorrowFajr;
  }

  double _windowProgress(DateTime start, DateTime end) {
    final totalMs = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    if (totalMs <= 0) return 0;
    final nowMs = referenceNow.millisecondsSinceEpoch;
    final elapsed = (nowMs - start.millisecondsSinceEpoch).clamp(0, totalMs);
    return elapsed / totalMs;
  }

  String? _countdownTo(DateTime? at) {
    if (at == null) return null;
    var diff = at.difference(referenceNow);
    if (diff.isNegative) return null;
    final hours = diff.inHours;
    diff -= Duration(hours: hours);
    final minutes = diff.inMinutes;
    if (hours > 0) return '${hours}H ${minutes}M';
    if (minutes <= 0) return null;
    return '${minutes}M';
  }
}
