/// Central numeric limits for prayer–surah planning.
abstract final class PlanLimits {
  /// Hard safety cap on surahs per prayer slot (Fajr, Dhuhr, …).
  ///
  /// [PrayerSlot] construction and serde reject more than this many entries.
  /// It is not the user-facing knob: the **surahs per prayer** preference
  /// (`surahsPerPrayerProvider`) is the everyday target and must stay
  /// ≤ this value. Generation uses `min(surahsPerPrayer, maxSurahsPerPrayerSlot,
  /// poolLength)` so raising the UI maximum above [maxSurahsPerPrayerSlot]
  /// requires bumping this constant too.
  static const int maxSurahsPerPrayerSlot = 10;
}
