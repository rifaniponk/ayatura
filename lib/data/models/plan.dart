import 'package:surah_planner/core/plan_config.dart';

import 'prayer.dart';
import 'surah.dart';

/// Surahs assigned to one prayer slot, capped by [PlanLimits.maxSurahsPerPrayerSlot].
///
/// New assignments should respect that cap; stored rows may contain fewer.
class PrayerSlot {
  final List<Surah> surahs;
  final bool locked;

  const PrayerSlot({this.surahs = const [], this.locked = false});

  PrayerSlot copyWith({List<Surah>? surahs, bool? locked}) {
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
          .map((s) => Surah.fromJson(s as Map<String, dynamic>))
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

  PrayerSlot slotFor(Prayer prayer) => prayers[prayer] ?? const PrayerSlot();

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
    return DayPlan(
      day: json['day'] as int,
      prayers: {
        for (final entry in rawPrayers.entries)
          Prayer.values.firstWhere((p) => p.name == entry.key):
              PrayerSlot.fromJson(entry.value as Map<String, dynamic>),
      },
    );
  }
}

/// The full plan for an entire month.
class MonthPlan {
  final int month; // 1–12
  final int year;
  final List<DayPlan> days;

  const MonthPlan({
    required this.month,
    required this.year,
    required this.days,
  });

  DayPlan? planForDay(int day) {
    try {
      return days.firstWhere((d) => d.day == day);
    } catch (_) {
      return null;
    }
  }

  bool get isStale {
    final now = DateTime.now();
    return now.month != month || now.year != year;
  }

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
