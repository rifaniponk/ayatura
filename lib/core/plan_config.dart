/// Central numeric limits for prayer–surah planning.
///
/// Values are defaults for generation and UI validation. Later this can
/// read from persisted settings (e.g. Drift `app_settings`) without changing
/// the shape of [PlanLimits]—call sites would switch from constants to
/// async lookups when that lands.
abstract final class PlanLimits {
  /// Maximum surahs assignable to a single prayer slot (Fajr, Dhuhr, …).
  ///
  /// Enforced by [PrayerSlot] construction and serde; adjust UI/generation
  /// to match if this value changes.
  static const int maxSurahsPerPrayerSlot = 10;
}
