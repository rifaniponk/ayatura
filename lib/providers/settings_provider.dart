import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/plan_config.dart';
import '../data/models/prayer.dart';
import '../data/models/prayer_times.dart';
import 'shared_preferences_provider.dart';
import 'widget_sync_provider.dart';

const _kSurahsPerPrayer = 'surahsPerPrayer';

/// Default surahs assigned per prayer slot when generating a plan.
const surahsPerPrayerDefault = 2;

const surahsPerPrayerMin = 1;
const surahsPerPrayerMax = 5;

final surahsPerPrayerProvider = NotifierProvider<SurahsPerPrayerNotifier, int>(
  SurahsPerPrayerNotifier.new,
);

class SurahsPerPrayerNotifier extends Notifier<int> {
  @override
  int build() {
    assert(
      surahsPerPrayerMax <= PlanLimits.maxSurahsPerPrayerSlot,
      'surahsPerPrayerMax ($surahsPerPrayerMax) exceeds the hard slot cap '
      '(${PlanLimits.maxSurahsPerPrayerSlot}). Bump maxSurahsPerPrayerSlot.',
    );
    final prefs = ref.read(sharedPreferencesProvider);
    final stored = prefs.getInt(_kSurahsPerPrayer);
    if (stored == null) return surahsPerPrayerDefault;
    return stored.clamp(surahsPerPrayerMin, surahsPerPrayerMax);
  }

  Future<void> set(int value) async {
    final clamped = value.clamp(surahsPerPrayerMin, surahsPerPrayerMax);
    state = clamped;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_kSurahsPerPrayer, clamped);
  }
}

final prayerTimesProvider = NotifierProvider<PrayerTimesNotifier, PrayerTimes>(
  PrayerTimesNotifier.new,
);

class PrayerTimesNotifier extends Notifier<PrayerTimes> {
  @override
  PrayerTimes build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return PrayerTimes.fromPreferences(prefs);
  }

  Future<void> setPrayerMinutes(Prayer prayer, int totalMinutes) async {
    final clamped = totalMinutes.clamp(0, (24 * 60) - 1);
    final prefs = ref.read(sharedPreferencesProvider);
    switch (prayer) {
      case Prayer.fajr:
        state = state.copyWith(fajrMinutes: clamped);
        await prefs.setInt(PrayerTimes.fajrKey, clamped);
        break;
      case Prayer.dhuhr:
        state = state.copyWith(dhuhrMinutes: clamped);
        await prefs.setInt(PrayerTimes.dhuhrKey, clamped);
        break;
      case Prayer.asr:
        state = state.copyWith(asrMinutes: clamped);
        await prefs.setInt(PrayerTimes.asrKey, clamped);
        break;
      case Prayer.maghrib:
        state = state.copyWith(maghribMinutes: clamped);
        await prefs.setInt(PrayerTimes.maghribKey, clamped);
        break;
      case Prayer.isha:
        state = state.copyWith(ishaMinutes: clamped);
        await prefs.setInt(PrayerTimes.ishaKey, clamped);
        break;
    }
    await syncHomeWidget(ref);
  }
}
