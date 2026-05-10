import 'prayer.dart';
import 'prayer_slot.dart';

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
