import 'surah.dart';

/// One row on the user's hifdh list: a full surah or a specific ayat range.
///
/// When [isFullSurah] is true, [startAyah] and [endAyah] are ignored (may be null).
/// When false, both should be set to the inclusive ayat span.
class SurahPoolEntry {
  final int id;
  final int surahId;
  final bool isFullSurah;
  final int? startAyah;
  final int? endAyah;
  final bool enabled;

  const SurahPoolEntry({
    required this.id,
    required this.surahId,
    required this.isFullSurah,
    this.startAyah,
    this.endAyah,
    this.enabled = true,
  });

  factory SurahPoolEntry.fromJson(Map<String, dynamic> json) {
    return SurahPoolEntry(
      id: json['id'] as int,
      surahId: json['surahId'] as int,
      isFullSurah: json['isFullSurah'] as bool,
      startAyah: json['startAyah'] as int?,
      endAyah: json['endAyah'] as int?,
      enabled: json['enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'surahId': surahId,
    'isFullSurah': isFullSurah,
    'startAyah': startAyah,
    'endAyah': endAyah,
    'enabled': enabled,
  };

  String displayLabel(Surah surah, String languageCode) {
    final romaji = surah.localizedName(languageCode);
    if (isFullSurah) return romaji;
    final a = startAyah;
    final b = endAyah;
    if (a != null && b != null) {
      if (a == b) return '$romaji ($a)';
      return '$romaji ($a–$b)';
    }
    return romaji;
  }

  SurahPoolEntry copyWith({
    int? id,
    int? surahId,
    bool? isFullSurah,
    int? startAyah,
    int? endAyah,
    bool? enabled,
  }) {
    return SurahPoolEntry(
      id: id ?? this.id,
      surahId: surahId ?? this.surahId,
      isFullSurah: isFullSurah ?? this.isFullSurah,
      startAyah: startAyah ?? this.startAyah,
      endAyah: endAyah ?? this.endAyah,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SurahPoolEntry &&
          other.id == id &&
          other.surahId == surahId &&
          other.isFullSurah == isFullSurah &&
          other.startAyah == startAyah &&
          other.endAyah == endAyah &&
          other.enabled == enabled);

  @override
  int get hashCode =>
      Object.hash(id, surahId, isFullSurah, startAyah, endAyah, enabled);
}
