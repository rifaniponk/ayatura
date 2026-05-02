/// Canonical Quran surah metadata (master data, 1–114).
class Surah {
  /// Surah number (1–114).
  final int id;
  final String name;
  final String arabicName;
  final int ayatCount;

  const Surah({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.ayatCount,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      id: json['id'] as int,
      name: json['name'] as String,
      arabicName: json['arabicName'] as String,
      ayatCount: json['ayatCount'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'arabicName': arabicName,
    'ayatCount': ayatCount,
  };

  /// Short label for lists (master data has no ayat segment).
  String get displayName => name;

  Surah copyWith({
    int? id,
    String? name,
    String? arabicName,
    int? ayatCount,
  }) {
    return Surah(
      id: id ?? this.id,
      name: name ?? this.name,
      arabicName: arabicName ?? this.arabicName,
      ayatCount: ayatCount ?? this.ayatCount,
    );
  }

  @override
  String toString() => 'Surah($id, $name, ayat: $ayatCount)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Surah &&
          other.id == id &&
          other.name == name &&
          other.arabicName == arabicName &&
          other.ayatCount == ayatCount);

  @override
  int get hashCode => Object.hash(id, name, arabicName, ayatCount);
}
