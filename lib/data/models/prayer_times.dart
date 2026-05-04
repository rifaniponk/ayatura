import 'package:shared_preferences/shared_preferences.dart';

import 'prayer.dart';

/// User-configurable daily prayer times in minutes from midnight.
class PrayerTimes {
  const PrayerTimes({
    required this.fajrMinutes,
    required this.dhuhrMinutes,
    required this.asrMinutes,
    required this.maghribMinutes,
    required this.ishaMinutes,
  });

  static const int defaultFajrMinutes = 5 * 60;
  static const int defaultDhuhrMinutes = 12 * 60;
  static const int defaultAsrMinutes = 15 * 60 + 30;
  static const int defaultMaghribMinutes = 18 * 60 + 15;
  static const int defaultIshaMinutes = 19 * 60 + 45;

  static const String fajrKey = 'prayerTimeFajr';
  static const String dhuhrKey = 'prayerTimeDhuhr';
  static const String asrKey = 'prayerTimeAsr';
  static const String maghribKey = 'prayerTimeMaghrib';
  static const String ishaKey = 'prayerTimeIsha';

  final int fajrMinutes;
  final int dhuhrMinutes;
  final int asrMinutes;
  final int maghribMinutes;
  final int ishaMinutes;

  static PrayerTimes fromPreferences(SharedPreferences prefs) {
    return PrayerTimes(
      fajrMinutes: prefs.getInt(fajrKey) ?? defaultFajrMinutes,
      dhuhrMinutes: prefs.getInt(dhuhrKey) ?? defaultDhuhrMinutes,
      asrMinutes: prefs.getInt(asrKey) ?? defaultAsrMinutes,
      maghribMinutes: prefs.getInt(maghribKey) ?? defaultMaghribMinutes,
      ishaMinutes: prefs.getInt(ishaKey) ?? defaultIshaMinutes,
    );
  }

  PrayerTimes copyWith({
    int? fajrMinutes,
    int? dhuhrMinutes,
    int? asrMinutes,
    int? maghribMinutes,
    int? ishaMinutes,
  }) {
    return PrayerTimes(
      fajrMinutes: fajrMinutes ?? this.fajrMinutes,
      dhuhrMinutes: dhuhrMinutes ?? this.dhuhrMinutes,
      asrMinutes: asrMinutes ?? this.asrMinutes,
      maghribMinutes: maghribMinutes ?? this.maghribMinutes,
      ishaMinutes: ishaMinutes ?? this.ishaMinutes,
    );
  }

  int minutesFor(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return fajrMinutes;
      case Prayer.dhuhr:
        return dhuhrMinutes;
      case Prayer.asr:
        return asrMinutes;
      case Prayer.maghrib:
        return maghribMinutes;
      case Prayer.isha:
        return ishaMinutes;
    }
  }

  String formattedFor(Prayer prayer) => formatMinutes(minutesFor(prayer));

  static String formatMinutes(int totalMinutes) {
    final hours = (totalMinutes ~/ 60).toString().padLeft(2, '0');
    final minutes = (totalMinutes % 60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}
