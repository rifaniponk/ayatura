import 'package:surah_planner/core/plan_config.dart';

import 'plan_surah.dart';

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
