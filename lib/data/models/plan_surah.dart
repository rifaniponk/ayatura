import 'surah.dart';
import 'surah_pool_entry.dart';

/// Snapshot of what to read in a prayer slot (serialized inside [MonthPlan]).
///
/// Carries denormalized names so past plans stay readable if master data changes.
class PlanSurah {
  final int surahId;
  final String name;
  final String arabicName;
  final int ayatCount;
  final bool isFullSurah;
  final int? startAyah;
  final int? endAyah;

  const PlanSurah({
    required this.surahId,
    required this.name,
    required this.arabicName,
    required this.ayatCount,
    required this.isFullSurah,
    this.startAyah,
    this.endAyah,
  });

  factory PlanSurah.fromSurahAndPool(Surah master, SurahPoolEntry entry) {
    return PlanSurah(
      surahId: master.id,
      name: master.name,
      arabicName: master.arabicName,
      ayatCount: master.ayatCount,
      isFullSurah: entry.isFullSurah,
      startAyah: entry.startAyah,
      endAyah: entry.endAyah,
    );
  }

  factory PlanSurah.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('isFullSurah')) {
      return PlanSurah(
        surahId: json['surahId'] as int? ?? json['id'] as int,
        name: json['name'] as String,
        arabicName: json['arabicName'] as String,
        ayatCount: json['ayatCount'] as int,
        isFullSurah: json['isFullSurah'] as bool,
        startAyah: json['startAyah'] as int?,
        endAyah: json['endAyah'] as int?,
      );
    }
    return PlanSurah.fromLegacySurahJson(json);
  }

  /// Maps legacy plan JSON that used [Surah] with optional `ayatRange` string.
  factory PlanSurah.fromLegacySurahJson(Map<String, dynamic> json) {
    final ayatRange = json['ayatRange'] as String?;
    final id = json['id'] as int;
    final name = json['name'] as String;
    final arabicName = json['arabicName'] as String;
    final ayatCount = json['ayatCount'] as int;

    if (ayatRange == null || ayatRange.isEmpty) {
      return PlanSurah(
        surahId: id,
        name: name,
        arabicName: arabicName,
        ayatCount: ayatCount,
        isFullSurah: true,
      );
    }

    final parsed = _parseAyatRange(ayatRange);
    return PlanSurah(
      surahId: id,
      name: name,
      arabicName: arabicName,
      ayatCount: ayatCount,
      isFullSurah: false,
      startAyah: parsed.$1,
      endAyah: parsed.$2,
    );
  }

  /// Best-effort parse for strings like "1-5", "2:255", "284-286".
  static (int?, int?) _parseAyatRange(String raw) {
    final trimmed = raw.trim();
    final colon = trimmed.indexOf(':');
    if (colon >= 0) {
      final tail = trimmed.substring(colon + 1).trim();
      final n = int.tryParse(tail);
      return (n, n);
    }
    final dashIdx = trimmed.indexOf(RegExp(r'[-–—]'));
    if (dashIdx < 0) {
      final n = int.tryParse(trimmed);
      return (n, n);
    }
    final a = int.tryParse(trimmed.substring(0, dashIdx).trim());
    final b = int.tryParse(trimmed.substring(dashIdx + 1).trim());
    return (a, b);
  }

  Map<String, dynamic> toJson() => {
    'surahId': surahId,
    'name': name,
    'arabicName': arabicName,
    'ayatCount': ayatCount,
    'isFullSurah': isFullSurah,
    'startAyah': startAyah,
    'endAyah': endAyah,
  };

  String get displayName {
    if (isFullSurah) return name;
    final a = startAyah;
    final b = endAyah;
    if (a != null && b != null) {
      if (a == b) return '$name ($a)';
      return '$name ($a–$b)';
    }
    return name;
  }

  PlanSurah copyWith({
    int? surahId,
    String? name,
    String? arabicName,
    int? ayatCount,
    bool? isFullSurah,
    int? startAyah,
    int? endAyah,
  }) {
    return PlanSurah(
      surahId: surahId ?? this.surahId,
      name: name ?? this.name,
      arabicName: arabicName ?? this.arabicName,
      ayatCount: ayatCount ?? this.ayatCount,
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
          other.name == name &&
          other.arabicName == arabicName &&
          other.ayatCount == ayatCount &&
          other.isFullSurah == isFullSurah &&
          other.startAyah == startAyah &&
          other.endAyah == endAyah);

  @override
  int get hashCode => Object.hash(
    surahId,
    name,
    arabicName,
    ayatCount,
    isFullSurah,
    startAyah,
    endAyah,
  );
}
