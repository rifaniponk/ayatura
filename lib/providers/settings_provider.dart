import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/plan_config.dart';
import 'shared_preferences_provider.dart';

const _kSurahsPerPrayer = 'surahsPerPrayer';
const _kLockPastPrayers = 'lockPastPrayers';

/// Default surahs assigned per prayer slot when generating a plan.
const surahsPerPrayerDefault = 2;
const lockPastPrayersDefault = true;

const surahsPerPrayerMin = 1;
const surahsPerPrayerMax = 5;

final surahsPerPrayerProvider = NotifierProvider<SurahsPerPrayerNotifier, int>(
  SurahsPerPrayerNotifier.new,
);
final lockPastPrayersProvider = NotifierProvider<LockPastPrayersNotifier, bool>(
  LockPastPrayersNotifier.new,
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

class LockPastPrayersNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getBool(_kLockPastPrayers) ?? lockPastPrayersDefault;
  }

  Future<void> set(bool value) async {
    state = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_kLockPastPrayers, value);
  }
}
