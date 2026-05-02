/// A single Quran surah (or a partial ayat range).
///
/// The [id] is the canonical surah number (1–114) for full surahs.
/// For custom ayat ranges the id follows the convention:
///   id = surahNumber * 1000 + rangeIndex   (e.g. 2001 = Al-Baqarah range #1)
class Surah {
  final int id;
  final String name;
  final String arabicName;
  final int ayatCount;

  /// Null for full surahs. e.g. "1–5" for a range.
  final String? ayatRange;

  /// Whether this surah is active in the pool.
  bool enabled;

  Surah({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.ayatCount,
    this.ayatRange,
    this.enabled = true,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      id: json['id'] as int,
      name: json['name'] as String,
      arabicName: json['arabicName'] as String,
      ayatCount: json['ayatCount'] as int,
      ayatRange: json['ayatRange'] as String?,
      enabled: json['enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'arabicName': arabicName,
    'ayatCount': ayatCount,
    'ayatRange': ayatRange,
    'enabled': enabled,
  };

  /// Display name — includes range suffix when present.
  String get displayName => ayatRange != null ? '$name ($ayatRange)' : name;

  Surah copyWith({
    int? id,
    String? name,
    String? arabicName,
    int? ayatCount,
    String? ayatRange,
    bool? enabled,
  }) {
    return Surah(
      id: id ?? this.id,
      name: name ?? this.name,
      arabicName: arabicName ?? this.arabicName,
      ayatCount: ayatCount ?? this.ayatCount,
      ayatRange: ayatRange ?? this.ayatRange,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  String toString() => 'Surah($id, $displayName, ayat: $ayatCount)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Surah && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
