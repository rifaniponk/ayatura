import 'package:surah_planner/core/plan_config.dart';

import 'plan_surah.dart';
import 'prayer.dart';

/// Planned readings for one prayer slot, capped by [PlanLimits.maxSurahsPerPrayerSlot].
class PrayerSlot {
  final List<PlanSurah> surahs;
  final bool locked;

  PrayerSlot({List<PlanSurah> surahs = const [], this.locked = false})
    : surahs = List.unmodifiable(_validateSurahs(surahs));

  static List<PlanSurah> _validateSurahs(List<PlanSurah> surahs) {
    if (surahs.length > PlanLimits.maxSurahsPerPrayerSlot) {
      throw ArgumentError.value(
        surahs.length,
        'surahs.length',
        'must be <= ${PlanLimits.maxSurahsPerPrayerSlot}',
      );
    }
    return surahs;
  }

  PrayerSlot copyWith({List<PlanSurah>? surahs, bool? locked}) {
    return PrayerSlot(
      surahs: surahs ?? this.surahs,
      locked: locked ?? this.locked,
    );
  }

  Map<String, dynamic> toJson() => {
    'surahs': surahs.map((s) => s.toJson()).toList(),
    'locked': locked,
  };

  factory PrayerSlot.fromJson(Map<String, dynamic> json) {
    return PrayerSlot(
      surahs: (json['surahs'] as List<dynamic>)
          .map((s) => PlanSurah.fromJson(s as Map<String, dynamic>))
          .toList(),
      locked: json['locked'] as bool? ?? false,
    );
  }
}

/// All 5 prayer slots for a single day.
class DayPlan {
  /// Day-of-month (1–31).
  final int day;
  final Map<Prayer, PrayerSlot> prayers;

  const DayPlan({required this.day, required this.prayers});

  PrayerSlot slotFor(Prayer prayer) => prayers[prayer] ?? PrayerSlot();

  DayPlan copyWith({int? day, Map<Prayer, PrayerSlot>? prayers}) {
    return DayPlan(day: day ?? this.day, prayers: prayers ?? this.prayers);
  }

  Map<String, dynamic> toJson() => {
    'day': day,
    'prayers': prayers.map(
      (prayer, slot) => MapEntry(prayer.name, slot.toJson()),
    ),
  };

  factory DayPlan.fromJson(Map<String, dynamic> json) {
    final rawPrayers = json['prayers'] as Map<String, dynamic>;
    final prayers = <Prayer, PrayerSlot>{};
    for (final entry in rawPrayers.entries) {
      prayers[Prayer.values.byName(entry.key)] = PrayerSlot.fromJson(
        entry.value as Map<String, dynamic>,
      );
    }
    return DayPlan(day: json['day'] as int, prayers: prayers);
  }
}

/// The full plan for an entire month.
class MonthPlan {
  /// Calendar month (1–12).
  final int month;
  final int year;
  final List<DayPlan> days;

  const MonthPlan({
    required this.month,
    required this.year,
    required this.days,
  });

  DayPlan? planForDay(int day) {
    for (final d in days) {
      if (d.day == day) return d;
    }
    return null;
  }

  /// Whether this plan is for a month/year before [at]'s calendar month.
  bool isStaleAt(DateTime at) => at.month != month || at.year != year;

  /// Returns `this` if not stale at [now], otherwise `null`.
  MonthPlan? effectiveOrNull(DateTime now) => isStaleAt(now) ? null : this;

  Map<String, dynamic> toJson() => {
    'month': month,
    'year': year,
    'days': days.map((d) => d.toJson()).toList(),
  };

  factory MonthPlan.fromJson(Map<String, dynamic> json) {
    return MonthPlan(
      month: json['month'] as int,
      year: json['year'] as int,
      days: (json['days'] as List<dynamic>)
          .map((d) => DayPlan.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }
}
