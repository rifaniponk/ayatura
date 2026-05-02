import 'models/surah.dart';

/// Validates pool segment fields before insert/update.
class PoolSegmentValidation {
  PoolSegmentValidation._();

  /// Returns `null` if valid; otherwise a short error message for the UI.
  static String? validate({
    required Surah surah,
    required bool isFullSurah,
    int? startAyah,
    int? endAyah,
  }) {
    if (isFullSurah) return null;
    if (startAyah == null || endAyah == null) {
      return 'Enter both start and end ayah for a partial segment.';
    }
    final max = surah.ayatCount;
    if (startAyah < 1 || endAyah < 1 || startAyah > max || endAyah > max) {
      return 'Ayat must be between 1 and $max.';
    }
    if (startAyah > endAyah) {
      return 'Start ayah cannot be after end ayah.';
    }
    return null;
  }
}
