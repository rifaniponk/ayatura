/// Canonical Quran surah metadata (master data, 1–114).
class Surah {
  /// Surah number (1–114).
  final int id;
  final String name;

  /// Indonesian romanization (Quran cetakan Kemenag-style); see [localizedName].
  final String nameId;
  final String arabicName;
  final int ayatCount;

  /// First juz (1–30) where this surah begins — standard Hafs mushaf division.
  final int startJuz;

  /// Last juz (1–30) where this surah ends (same as [startJuz] if wholly in one juz).
  final int endJuz;

  const Surah({
    required this.id,
    required this.name,
    required this.nameId,
    required this.arabicName,
    required this.ayatCount,
    required this.startJuz,
    required this.endJuz,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String;
    return Surah(
      id: json['id'] as int,
      name: name,
      nameId: json['nameId'] as String? ?? name,
      arabicName: json['arabicName'] as String,
      ayatCount: json['ayatCount'] as int,
      startJuz: json['startJuz'] as int,
      endJuz: json['endJuz'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'nameId': nameId,
    'arabicName': arabicName,
    'ayatCount': ayatCount,
    'startJuz': startJuz,
    'endJuz': endJuz,
  };

  /// Short English label for lists (master data has no ayat segment).
  String get displayName => name;

  /// Romanized title for UI: Indonesian mushaf convention vs English [name].
  String localizedName(String languageCode) {
    final primary = languageCode.split(RegExp(r'[-_]')).first.toLowerCase();
    return primary == 'id' ? nameId : name;
  }

  Surah copyWith({
    int? id,
    String? name,
    String? nameId,
    String? arabicName,
    int? ayatCount,
    int? startJuz,
    int? endJuz,
  }) {
    return Surah(
      id: id ?? this.id,
      name: name ?? this.name,
      nameId: nameId ?? this.nameId,
      arabicName: arabicName ?? this.arabicName,
      ayatCount: ayatCount ?? this.ayatCount,
      startJuz: startJuz ?? this.startJuz,
      endJuz: endJuz ?? this.endJuz,
    );
  }

  @override
  String toString() =>
      'Surah($id, $name, ayat: $ayatCount, juz: $startJuz–$endJuz)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Surah &&
          other.id == id &&
          other.name == name &&
          other.nameId == nameId &&
          other.arabicName == arabicName &&
          other.ayatCount == ayatCount &&
          other.startJuz == startJuz &&
          other.endJuz == endJuz);

  @override
  int get hashCode =>
      Object.hash(id, name, nameId, arabicName, ayatCount, startJuz, endJuz);
}
