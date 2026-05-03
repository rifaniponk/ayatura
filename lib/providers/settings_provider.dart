import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_preferences_provider.dart';

const _kSurahsPerPrayer = 'surahsPerPrayer';

/// Default surahs assigned per prayer slot when generating a plan.
const surahsPerPrayerDefault = 2;

const surahsPerPrayerMin = 1;
const surahsPerPrayerMax = 5;

final surahsPerPrayerProvider =
    NotifierProvider<SurahsPerPrayerNotifier, int>(
  SurahsPerPrayerNotifier.new,
);

class SurahsPerPrayerNotifier extends Notifier<int> {
  @override
  int build() {
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
