/// Canonical Quran surah metadata (master data, 1–114).
class Surah {
  /// Surah number (1–114).
  final int id;
  final String name;
  final String arabicName;
  final int ayatCount;

  /// First juz (1–30) where this surah begins — standard Hafs mushaf division.
  final int startJuz;

  /// Last juz (1–30) where this surah ends (same as [startJuz] if wholly in one juz).
  final int endJuz;

  const Surah({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.ayatCount,
    required this.startJuz,
    required this.endJuz,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      id: json['id'] as int,
      name: json['name'] as String,
      arabicName: json['arabicName'] as String,
      ayatCount: json['ayatCount'] as int,
      startJuz: json['startJuz'] as int,
      endJuz: json['endJuz'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'arabicName': arabicName,
    'ayatCount': ayatCount,
    'startJuz': startJuz,
    'endJuz': endJuz,
  };

  /// Short label for lists (master data has no ayat segment).
  String get displayName => name;

  Surah copyWith({
    int? id,
    String? name,
    String? arabicName,
    int? ayatCount,
    int? startJuz,
    int? endJuz,
  }) {
    return Surah(
      id: id ?? this.id,
      name: name ?? this.name,
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
          other.arabicName == arabicName &&
          other.ayatCount == ayatCount &&
          other.startJuz == startJuz &&
          other.endJuz == endJuz);

  @override
  int get hashCode =>
      Object.hash(id, name, arabicName, ayatCount, startJuz, endJuz);
}
