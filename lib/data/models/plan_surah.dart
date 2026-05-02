import 'surah.dart';
import 'surah_pool_entry.dart';

/// Reading assigned to a prayer slot (serialized inside [MonthPlan]).
///
/// Only stores [surahId] and ayah span. Labels come from master [Surah] via
/// [displayLabel] so renames in bundled/DB master data flow through plans.
class PlanSurah {
  final int surahId;
  final bool isFullSurah;
  final int? startAyah;
  final int? endAyah;

  const PlanSurah({
    required this.surahId,
    required this.isFullSurah,
    this.startAyah,
    this.endAyah,
  });

  factory PlanSurah.fromSurahPoolEntry(SurahPoolEntry entry) {
    return PlanSurah(
      surahId: entry.surahId,
      isFullSurah: entry.isFullSurah,
      startAyah: entry.startAyah,
      endAyah: entry.endAyah,
    );
  }

  factory PlanSurah.fromJson(Map<String, dynamic> json) {
    return PlanSurah(
      surahId: json['surahId'] as int,
      isFullSurah: json['isFullSurah'] as bool,
      startAyah: json['startAyah'] as int?,
      endAyah: json['endAyah'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'surahId': surahId,
    'isFullSurah': isFullSurah,
    'startAyah': startAyah,
    'endAyah': endAyah,
  };

  /// Inclusive verse count for this assignment (compact UI, e.g. `12v`).
  int verseSpan(Surah master) {
    if (isFullSurah) return master.ayatCount;
    final a = startAyah;
    final b = endAyah;
    if (a != null && b != null) return b - a + 1;
    return master.ayatCount;
  }

  /// [master] must be the canonical [Surah] for [surahId] (same row as DB/asset).
  String displayLabel(Surah master) {
    if (isFullSurah) return master.displayName;
    final a = startAyah;
    final b = endAyah;
    if (a != null && b != null) {
      if (a == b) return '${master.name} ($a)';
      return '${master.name} ($a–$b)';
    }
    return master.displayName;
  }

  PlanSurah copyWith({
    int? surahId,
    bool? isFullSurah,
    int? startAyah,
    int? endAyah,
  }) {
    return PlanSurah(
      surahId: surahId ?? this.surahId,
      isFullSurah: isFullSurah ?? this.isFullSurah,
      startAyah: startAyah ?? this.startAyah,
      endAyah: endAyah ?? this.endAyah,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanSurah &&
          other.surahId == surahId &&
          other.isFullSurah == isFullSurah &&
          other.startAyah == startAyah &&
          other.endAyah == endAyah);

  @override
  int get hashCode => Object.hash(surahId, isFullSurah, startAyah, endAyah);
}
