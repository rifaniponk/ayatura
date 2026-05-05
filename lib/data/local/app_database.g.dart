// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SurahsTable extends Surahs with TableInfo<$SurahsTable, SurahRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameIdMeta = const VerificationMeta('nameId');
  @override
  late final GeneratedColumn<String> nameId = GeneratedColumn<String>(
    'name_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _arabicNameMeta = const VerificationMeta(
    'arabicName',
  );
  @override
  late final GeneratedColumn<String> arabicName = GeneratedColumn<String>(
    'arabic_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayatCountMeta = const VerificationMeta(
    'ayatCount',
  );
  @override
  late final GeneratedColumn<int> ayatCount = GeneratedColumn<int>(
    'ayat_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startJuzMeta = const VerificationMeta(
    'startJuz',
  );
  @override
  late final GeneratedColumn<int> startJuz = GeneratedColumn<int>(
    'start_juz',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _endJuzMeta = const VerificationMeta('endJuz');
  @override
  late final GeneratedColumn<int> endJuz = GeneratedColumn<int>(
    'end_juz',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameId,
    arabicName,
    ayatCount,
    startJuz,
    endJuz,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'surahs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SurahRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_id')) {
      context.handle(
        _nameIdMeta,
        nameId.isAcceptableOrUnknown(data['name_id']!, _nameIdMeta),
      );
    }
    if (data.containsKey('arabic_name')) {
      context.handle(
        _arabicNameMeta,
        arabicName.isAcceptableOrUnknown(data['arabic_name']!, _arabicNameMeta),
      );
    } else if (isInserting) {
      context.missing(_arabicNameMeta);
    }
    if (data.containsKey('ayat_count')) {
      context.handle(
        _ayatCountMeta,
        ayatCount.isAcceptableOrUnknown(data['ayat_count']!, _ayatCountMeta),
      );
    } else if (isInserting) {
      context.missing(_ayatCountMeta);
    }
    if (data.containsKey('start_juz')) {
      context.handle(
        _startJuzMeta,
        startJuz.isAcceptableOrUnknown(data['start_juz']!, _startJuzMeta),
      );
    }
    if (data.containsKey('end_juz')) {
      context.handle(
        _endJuzMeta,
        endJuz.isAcceptableOrUnknown(data['end_juz']!, _endJuzMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SurahRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SurahRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_id'],
      )!,
      arabicName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arabic_name'],
      )!,
      ayatCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayat_count'],
      )!,
      startJuz: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_juz'],
      )!,
      endJuz: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_juz'],
      )!,
    );
  }

  @override
  $SurahsTable createAlias(String alias) {
    return $SurahsTable(attachedDatabase, alias);
  }
}

class SurahRow extends DataClass implements Insertable<SurahRow> {
  final int id;
  final String name;
  final String nameId;
  final String arabicName;
  final int ayatCount;
  final int startJuz;
  final int endJuz;
  const SurahRow({
    required this.id,
    required this.name,
    required this.nameId,
    required this.arabicName,
    required this.ayatCount,
    required this.startJuz,
    required this.endJuz,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['name_id'] = Variable<String>(nameId);
    map['arabic_name'] = Variable<String>(arabicName);
    map['ayat_count'] = Variable<int>(ayatCount);
    map['start_juz'] = Variable<int>(startJuz);
    map['end_juz'] = Variable<int>(endJuz);
    return map;
  }

  SurahsCompanion toCompanion(bool nullToAbsent) {
    return SurahsCompanion(
      id: Value(id),
      name: Value(name),
      nameId: Value(nameId),
      arabicName: Value(arabicName),
      ayatCount: Value(ayatCount),
      startJuz: Value(startJuz),
      endJuz: Value(endJuz),
    );
  }

  factory SurahRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SurahRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameId: serializer.fromJson<String>(json['nameId']),
      arabicName: serializer.fromJson<String>(json['arabicName']),
      ayatCount: serializer.fromJson<int>(json['ayatCount']),
      startJuz: serializer.fromJson<int>(json['startJuz']),
      endJuz: serializer.fromJson<int>(json['endJuz']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nameId': serializer.toJson<String>(nameId),
      'arabicName': serializer.toJson<String>(arabicName),
      'ayatCount': serializer.toJson<int>(ayatCount),
      'startJuz': serializer.toJson<int>(startJuz),
      'endJuz': serializer.toJson<int>(endJuz),
    };
  }

  SurahRow copyWith({
    int? id,
    String? name,
    String? nameId,
    String? arabicName,
    int? ayatCount,
    int? startJuz,
    int? endJuz,
  }) => SurahRow(
    id: id ?? this.id,
    name: name ?? this.name,
    nameId: nameId ?? this.nameId,
    arabicName: arabicName ?? this.arabicName,
    ayatCount: ayatCount ?? this.ayatCount,
    startJuz: startJuz ?? this.startJuz,
    endJuz: endJuz ?? this.endJuz,
  );
  SurahRow copyWithCompanion(SurahsCompanion data) {
    return SurahRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameId: data.nameId.present ? data.nameId.value : this.nameId,
      arabicName: data.arabicName.present
          ? data.arabicName.value
          : this.arabicName,
      ayatCount: data.ayatCount.present ? data.ayatCount.value : this.ayatCount,
      startJuz: data.startJuz.present ? data.startJuz.value : this.startJuz,
      endJuz: data.endJuz.present ? data.endJuz.value : this.endJuz,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SurahRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameId: $nameId, ')
          ..write('arabicName: $arabicName, ')
          ..write('ayatCount: $ayatCount, ')
          ..write('startJuz: $startJuz, ')
          ..write('endJuz: $endJuz')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, nameId, arabicName, ayatCount, startJuz, endJuz);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SurahRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameId == this.nameId &&
          other.arabicName == this.arabicName &&
          other.ayatCount == this.ayatCount &&
          other.startJuz == this.startJuz &&
          other.endJuz == this.endJuz);
}

class SurahsCompanion extends UpdateCompanion<SurahRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> nameId;
  final Value<String> arabicName;
  final Value<int> ayatCount;
  final Value<int> startJuz;
  final Value<int> endJuz;
  const SurahsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameId = const Value.absent(),
    this.arabicName = const Value.absent(),
    this.ayatCount = const Value.absent(),
    this.startJuz = const Value.absent(),
    this.endJuz = const Value.absent(),
  });
  SurahsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.nameId = const Value.absent(),
    required String arabicName,
    required int ayatCount,
    this.startJuz = const Value.absent(),
    this.endJuz = const Value.absent(),
  }) : name = Value(name),
       arabicName = Value(arabicName),
       ayatCount = Value(ayatCount);
  static Insertable<SurahRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nameId,
    Expression<String>? arabicName,
    Expression<int>? ayatCount,
    Expression<int>? startJuz,
    Expression<int>? endJuz,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameId != null) 'name_id': nameId,
      if (arabicName != null) 'arabic_name': arabicName,
      if (ayatCount != null) 'ayat_count': ayatCount,
      if (startJuz != null) 'start_juz': startJuz,
      if (endJuz != null) 'end_juz': endJuz,
    });
  }

  SurahsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? nameId,
    Value<String>? arabicName,
    Value<int>? ayatCount,
    Value<int>? startJuz,
    Value<int>? endJuz,
  }) {
    return SurahsCompanion(
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
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameId.present) {
      map['name_id'] = Variable<String>(nameId.value);
    }
    if (arabicName.present) {
      map['arabic_name'] = Variable<String>(arabicName.value);
    }
    if (ayatCount.present) {
      map['ayat_count'] = Variable<int>(ayatCount.value);
    }
    if (startJuz.present) {
      map['start_juz'] = Variable<int>(startJuz.value);
    }
    if (endJuz.present) {
      map['end_juz'] = Variable<int>(endJuz.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurahsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameId: $nameId, ')
          ..write('arabicName: $arabicName, ')
          ..write('ayatCount: $ayatCount, ')
          ..write('startJuz: $startJuz, ')
          ..write('endJuz: $endJuz')
          ..write(')'))
        .toString();
  }
}

class $SurahPoolEntriesTable extends SurahPoolEntries
    with TableInfo<$SurahPoolEntriesTable, SurahPoolEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurahPoolEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _surahIdMeta = const VerificationMeta(
    'surahId',
  );
  @override
  late final GeneratedColumn<int> surahId = GeneratedColumn<int>(
    'surah_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES surahs (id)',
    ),
  );
  static const VerificationMeta _isFullSurahMeta = const VerificationMeta(
    'isFullSurah',
  );
  @override
  late final GeneratedColumn<bool> isFullSurah = GeneratedColumn<bool>(
    'is_full_surah',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_full_surah" IN (0, 1))',
    ),
  );
  static const VerificationMeta _startAyahMeta = const VerificationMeta(
    'startAyah',
  );
  @override
  late final GeneratedColumn<int> startAyah = GeneratedColumn<int>(
    'start_ayah',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endAyahMeta = const VerificationMeta(
    'endAyah',
  );
  @override
  late final GeneratedColumn<int> endAyah = GeneratedColumn<int>(
    'end_ayah',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surahId,
    isFullSurah,
    startAyah,
    endAyah,
    enabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'surah_pool_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SurahPoolEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_id')) {
      context.handle(
        _surahIdMeta,
        surahId.isAcceptableOrUnknown(data['surah_id']!, _surahIdMeta),
      );
    } else if (isInserting) {
      context.missing(_surahIdMeta);
    }
    if (data.containsKey('is_full_surah')) {
      context.handle(
        _isFullSurahMeta,
        isFullSurah.isAcceptableOrUnknown(
          data['is_full_surah']!,
          _isFullSurahMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isFullSurahMeta);
    }
    if (data.containsKey('start_ayah')) {
      context.handle(
        _startAyahMeta,
        startAyah.isAcceptableOrUnknown(data['start_ayah']!, _startAyahMeta),
      );
    }
    if (data.containsKey('end_ayah')) {
      context.handle(
        _endAyahMeta,
        endAyah.isAcceptableOrUnknown(data['end_ayah']!, _endAyahMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SurahPoolEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SurahPoolEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      surahId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_id'],
      )!,
      isFullSurah: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_full_surah'],
      )!,
      startAyah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_ayah'],
      ),
      endAyah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_ayah'],
      ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $SurahPoolEntriesTable createAlias(String alias) {
    return $SurahPoolEntriesTable(attachedDatabase, alias);
  }
}

class SurahPoolEntryRow extends DataClass
    implements Insertable<SurahPoolEntryRow> {
  final int id;
  final int surahId;
  final bool isFullSurah;
  final int? startAyah;
  final int? endAyah;
  final bool enabled;
  const SurahPoolEntryRow({
    required this.id,
    required this.surahId,
    required this.isFullSurah,
    this.startAyah,
    this.endAyah,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_id'] = Variable<int>(surahId);
    map['is_full_surah'] = Variable<bool>(isFullSurah);
    if (!nullToAbsent || startAyah != null) {
      map['start_ayah'] = Variable<int>(startAyah);
    }
    if (!nullToAbsent || endAyah != null) {
      map['end_ayah'] = Variable<int>(endAyah);
    }
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  SurahPoolEntriesCompanion toCompanion(bool nullToAbsent) {
    return SurahPoolEntriesCompanion(
      id: Value(id),
      surahId: Value(surahId),
      isFullSurah: Value(isFullSurah),
      startAyah: startAyah == null && nullToAbsent
          ? const Value.absent()
          : Value(startAyah),
      endAyah: endAyah == null && nullToAbsent
          ? const Value.absent()
          : Value(endAyah),
      enabled: Value(enabled),
    );
  }

  factory SurahPoolEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SurahPoolEntryRow(
      id: serializer.fromJson<int>(json['id']),
      surahId: serializer.fromJson<int>(json['surahId']),
      isFullSurah: serializer.fromJson<bool>(json['isFullSurah']),
      startAyah: serializer.fromJson<int?>(json['startAyah']),
      endAyah: serializer.fromJson<int?>(json['endAyah']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahId': serializer.toJson<int>(surahId),
      'isFullSurah': serializer.toJson<bool>(isFullSurah),
      'startAyah': serializer.toJson<int?>(startAyah),
      'endAyah': serializer.toJson<int?>(endAyah),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  SurahPoolEntryRow copyWith({
    int? id,
    int? surahId,
    bool? isFullSurah,
    Value<int?> startAyah = const Value.absent(),
    Value<int?> endAyah = const Value.absent(),
    bool? enabled,
  }) => SurahPoolEntryRow(
    id: id ?? this.id,
    surahId: surahId ?? this.surahId,
    isFullSurah: isFullSurah ?? this.isFullSurah,
    startAyah: startAyah.present ? startAyah.value : this.startAyah,
    endAyah: endAyah.present ? endAyah.value : this.endAyah,
    enabled: enabled ?? this.enabled,
  );
  SurahPoolEntryRow copyWithCompanion(SurahPoolEntriesCompanion data) {
    return SurahPoolEntryRow(
      id: data.id.present ? data.id.value : this.id,
      surahId: data.surahId.present ? data.surahId.value : this.surahId,
      isFullSurah: data.isFullSurah.present
          ? data.isFullSurah.value
          : this.isFullSurah,
      startAyah: data.startAyah.present ? data.startAyah.value : this.startAyah,
      endAyah: data.endAyah.present ? data.endAyah.value : this.endAyah,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SurahPoolEntryRow(')
          ..write('id: $id, ')
          ..write('surahId: $surahId, ')
          ..write('isFullSurah: $isFullSurah, ')
          ..write('startAyah: $startAyah, ')
          ..write('endAyah: $endAyah, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, surahId, isFullSurah, startAyah, endAyah, enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SurahPoolEntryRow &&
          other.id == this.id &&
          other.surahId == this.surahId &&
          other.isFullSurah == this.isFullSurah &&
          other.startAyah == this.startAyah &&
          other.endAyah == this.endAyah &&
          other.enabled == this.enabled);
}

class SurahPoolEntriesCompanion extends UpdateCompanion<SurahPoolEntryRow> {
  final Value<int> id;
  final Value<int> surahId;
  final Value<bool> isFullSurah;
  final Value<int?> startAyah;
  final Value<int?> endAyah;
  final Value<bool> enabled;
  const SurahPoolEntriesCompanion({
    this.id = const Value.absent(),
    this.surahId = const Value.absent(),
    this.isFullSurah = const Value.absent(),
    this.startAyah = const Value.absent(),
    this.endAyah = const Value.absent(),
    this.enabled = const Value.absent(),
  });
  SurahPoolEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int surahId,
    required bool isFullSurah,
    this.startAyah = const Value.absent(),
    this.endAyah = const Value.absent(),
    this.enabled = const Value.absent(),
  }) : surahId = Value(surahId),
       isFullSurah = Value(isFullSurah);
  static Insertable<SurahPoolEntryRow> custom({
    Expression<int>? id,
    Expression<int>? surahId,
    Expression<bool>? isFullSurah,
    Expression<int>? startAyah,
    Expression<int>? endAyah,
    Expression<bool>? enabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahId != null) 'surah_id': surahId,
      if (isFullSurah != null) 'is_full_surah': isFullSurah,
      if (startAyah != null) 'start_ayah': startAyah,
      if (endAyah != null) 'end_ayah': endAyah,
      if (enabled != null) 'enabled': enabled,
    });
  }

  SurahPoolEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? surahId,
    Value<bool>? isFullSurah,
    Value<int?>? startAyah,
    Value<int?>? endAyah,
    Value<bool>? enabled,
  }) {
    return SurahPoolEntriesCompanion(
      id: id ?? this.id,
      surahId: surahId ?? this.surahId,
      isFullSurah: isFullSurah ?? this.isFullSurah,
      startAyah: startAyah ?? this.startAyah,
      endAyah: endAyah ?? this.endAyah,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahId.present) {
      map['surah_id'] = Variable<int>(surahId.value);
    }
    if (isFullSurah.present) {
      map['is_full_surah'] = Variable<bool>(isFullSurah.value);
    }
    if (startAyah.present) {
      map['start_ayah'] = Variable<int>(startAyah.value);
    }
    if (endAyah.present) {
      map['end_ayah'] = Variable<int>(endAyah.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurahPoolEntriesCompanion(')
          ..write('id: $id, ')
          ..write('surahId: $surahId, ')
          ..write('isFullSurah: $isFullSurah, ')
          ..write('startAyah: $startAyah, ')
          ..write('endAyah: $endAyah, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }
}

class $MonthPlansTable extends MonthPlans
    with TableInfo<$MonthPlansTable, MonthPlanRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planJsonMeta = const VerificationMeta(
    'planJson',
  );
  @override
  late final GeneratedColumn<String> planJson = GeneratedColumn<String>(
    'plan_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [year, month, planJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'month_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<MonthPlanRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('plan_json')) {
      context.handle(
        _planJsonMeta,
        planJson.isAcceptableOrUnknown(data['plan_json']!, _planJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_planJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {year, month};
  @override
  MonthPlanRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonthPlanRow(
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      planJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_json'],
      )!,
    );
  }

  @override
  $MonthPlansTable createAlias(String alias) {
    return $MonthPlansTable(attachedDatabase, alias);
  }
}

class MonthPlanRow extends DataClass implements Insertable<MonthPlanRow> {
  final int year;
  final int month;
  final String planJson;
  const MonthPlanRow({
    required this.year,
    required this.month,
    required this.planJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['plan_json'] = Variable<String>(planJson);
    return map;
  }

  MonthPlansCompanion toCompanion(bool nullToAbsent) {
    return MonthPlansCompanion(
      year: Value(year),
      month: Value(month),
      planJson: Value(planJson),
    );
  }

  factory MonthPlanRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonthPlanRow(
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      planJson: serializer.fromJson<String>(json['planJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'planJson': serializer.toJson<String>(planJson),
    };
  }

  MonthPlanRow copyWith({int? year, int? month, String? planJson}) =>
      MonthPlanRow(
        year: year ?? this.year,
        month: month ?? this.month,
        planJson: planJson ?? this.planJson,
      );
  MonthPlanRow copyWithCompanion(MonthPlansCompanion data) {
    return MonthPlanRow(
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      planJson: data.planJson.present ? data.planJson.value : this.planJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonthPlanRow(')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('planJson: $planJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(year, month, planJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonthPlanRow &&
          other.year == this.year &&
          other.month == this.month &&
          other.planJson == this.planJson);
}

class MonthPlansCompanion extends UpdateCompanion<MonthPlanRow> {
  final Value<int> year;
  final Value<int> month;
  final Value<String> planJson;
  final Value<int> rowid;
  const MonthPlansCompanion({
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.planJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MonthPlansCompanion.insert({
    required int year,
    required int month,
    required String planJson,
    this.rowid = const Value.absent(),
  }) : year = Value(year),
       month = Value(month),
       planJson = Value(planJson);
  static Insertable<MonthPlanRow> custom({
    Expression<int>? year,
    Expression<int>? month,
    Expression<String>? planJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (planJson != null) 'plan_json': planJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MonthPlansCompanion copyWith({
    Value<int>? year,
    Value<int>? month,
    Value<String>? planJson,
    Value<int>? rowid,
  }) {
    return MonthPlansCompanion(
      year: year ?? this.year,
      month: month ?? this.month,
      planJson: planJson ?? this.planJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (planJson.present) {
      map['plan_json'] = Variable<String>(planJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthPlansCompanion(')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('planJson: $planJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PrayerTimesTable extends PrayerTimes
    with TableInfo<$PrayerTimesTable, PrayerTime> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrayerTimesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fajrMeta = const VerificationMeta('fajr');
  @override
  late final GeneratedColumn<String> fajr = GeneratedColumn<String>(
    'fajr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dhuhrMeta = const VerificationMeta('dhuhr');
  @override
  late final GeneratedColumn<String> dhuhr = GeneratedColumn<String>(
    'dhuhr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _asrMeta = const VerificationMeta('asr');
  @override
  late final GeneratedColumn<String> asr = GeneratedColumn<String>(
    'asr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maghribMeta = const VerificationMeta(
    'maghrib',
  );
  @override
  late final GeneratedColumn<String> maghrib = GeneratedColumn<String>(
    'maghrib',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ishaMeta = const VerificationMeta('isha');
  @override
  late final GeneratedColumn<String> isha = GeneratedColumn<String>(
    'isha',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationNameMeta = const VerificationMeta(
    'locationName',
  );
  @override
  late final GeneratedColumn<String> locationName = GeneratedColumn<String>(
    'location_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    fajr,
    dhuhr,
    asr,
    maghrib,
    isha,
    latitude,
    longitude,
    locationName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prayer_times';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrayerTime> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('fajr')) {
      context.handle(
        _fajrMeta,
        fajr.isAcceptableOrUnknown(data['fajr']!, _fajrMeta),
      );
    } else if (isInserting) {
      context.missing(_fajrMeta);
    }
    if (data.containsKey('dhuhr')) {
      context.handle(
        _dhuhrMeta,
        dhuhr.isAcceptableOrUnknown(data['dhuhr']!, _dhuhrMeta),
      );
    } else if (isInserting) {
      context.missing(_dhuhrMeta);
    }
    if (data.containsKey('asr')) {
      context.handle(
        _asrMeta,
        asr.isAcceptableOrUnknown(data['asr']!, _asrMeta),
      );
    } else if (isInserting) {
      context.missing(_asrMeta);
    }
    if (data.containsKey('maghrib')) {
      context.handle(
        _maghribMeta,
        maghrib.isAcceptableOrUnknown(data['maghrib']!, _maghribMeta),
      );
    } else if (isInserting) {
      context.missing(_maghribMeta);
    }
    if (data.containsKey('isha')) {
      context.handle(
        _ishaMeta,
        isha.isAcceptableOrUnknown(data['isha']!, _ishaMeta),
      );
    } else if (isInserting) {
      context.missing(_ishaMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('location_name')) {
      context.handle(
        _locationNameMeta,
        locationName.isAcceptableOrUnknown(
          data['location_name']!,
          _locationNameMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  PrayerTime map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrayerTime(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      fajr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fajr'],
      )!,
      dhuhr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dhuhr'],
      )!,
      asr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asr'],
      )!,
      maghrib: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}maghrib'],
      )!,
      isha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}isha'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      locationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_name'],
      ),
    );
  }

  @override
  $PrayerTimesTable createAlias(String alias) {
    return $PrayerTimesTable(attachedDatabase, alias);
  }
}

class PrayerTime extends DataClass implements Insertable<PrayerTime> {
  final String date;
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final double latitude;
  final double longitude;
  final String? locationName;
  const PrayerTime({
    required this.date,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.latitude,
    required this.longitude,
    this.locationName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['fajr'] = Variable<String>(fajr);
    map['dhuhr'] = Variable<String>(dhuhr);
    map['asr'] = Variable<String>(asr);
    map['maghrib'] = Variable<String>(maghrib);
    map['isha'] = Variable<String>(isha);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || locationName != null) {
      map['location_name'] = Variable<String>(locationName);
    }
    return map;
  }

  PrayerTimesCompanion toCompanion(bool nullToAbsent) {
    return PrayerTimesCompanion(
      date: Value(date),
      fajr: Value(fajr),
      dhuhr: Value(dhuhr),
      asr: Value(asr),
      maghrib: Value(maghrib),
      isha: Value(isha),
      latitude: Value(latitude),
      longitude: Value(longitude),
      locationName: locationName == null && nullToAbsent
          ? const Value.absent()
          : Value(locationName),
    );
  }

  factory PrayerTime.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrayerTime(
      date: serializer.fromJson<String>(json['date']),
      fajr: serializer.fromJson<String>(json['fajr']),
      dhuhr: serializer.fromJson<String>(json['dhuhr']),
      asr: serializer.fromJson<String>(json['asr']),
      maghrib: serializer.fromJson<String>(json['maghrib']),
      isha: serializer.fromJson<String>(json['isha']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      locationName: serializer.fromJson<String?>(json['locationName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'fajr': serializer.toJson<String>(fajr),
      'dhuhr': serializer.toJson<String>(dhuhr),
      'asr': serializer.toJson<String>(asr),
      'maghrib': serializer.toJson<String>(maghrib),
      'isha': serializer.toJson<String>(isha),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'locationName': serializer.toJson<String?>(locationName),
    };
  }

  PrayerTime copyWith({
    String? date,
    String? fajr,
    String? dhuhr,
    String? asr,
    String? maghrib,
    String? isha,
    double? latitude,
    double? longitude,
    Value<String?> locationName = const Value.absent(),
  }) => PrayerTime(
    date: date ?? this.date,
    fajr: fajr ?? this.fajr,
    dhuhr: dhuhr ?? this.dhuhr,
    asr: asr ?? this.asr,
    maghrib: maghrib ?? this.maghrib,
    isha: isha ?? this.isha,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    locationName: locationName.present ? locationName.value : this.locationName,
  );
  PrayerTime copyWithCompanion(PrayerTimesCompanion data) {
    return PrayerTime(
      date: data.date.present ? data.date.value : this.date,
      fajr: data.fajr.present ? data.fajr.value : this.fajr,
      dhuhr: data.dhuhr.present ? data.dhuhr.value : this.dhuhr,
      asr: data.asr.present ? data.asr.value : this.asr,
      maghrib: data.maghrib.present ? data.maghrib.value : this.maghrib,
      isha: data.isha.present ? data.isha.value : this.isha,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      locationName: data.locationName.present
          ? data.locationName.value
          : this.locationName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrayerTime(')
          ..write('date: $date, ')
          ..write('fajr: $fajr, ')
          ..write('dhuhr: $dhuhr, ')
          ..write('asr: $asr, ')
          ..write('maghrib: $maghrib, ')
          ..write('isha: $isha, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('locationName: $locationName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    date,
    fajr,
    dhuhr,
    asr,
    maghrib,
    isha,
    latitude,
    longitude,
    locationName,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrayerTime &&
          other.date == this.date &&
          other.fajr == this.fajr &&
          other.dhuhr == this.dhuhr &&
          other.asr == this.asr &&
          other.maghrib == this.maghrib &&
          other.isha == this.isha &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.locationName == this.locationName);
}

class PrayerTimesCompanion extends UpdateCompanion<PrayerTime> {
  final Value<String> date;
  final Value<String> fajr;
  final Value<String> dhuhr;
  final Value<String> asr;
  final Value<String> maghrib;
  final Value<String> isha;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String?> locationName;
  final Value<int> rowid;
  const PrayerTimesCompanion({
    this.date = const Value.absent(),
    this.fajr = const Value.absent(),
    this.dhuhr = const Value.absent(),
    this.asr = const Value.absent(),
    this.maghrib = const Value.absent(),
    this.isha = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.locationName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrayerTimesCompanion.insert({
    required String date,
    required String fajr,
    required String dhuhr,
    required String asr,
    required String maghrib,
    required String isha,
    required double latitude,
    required double longitude,
    this.locationName = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       fajr = Value(fajr),
       dhuhr = Value(dhuhr),
       asr = Value(asr),
       maghrib = Value(maghrib),
       isha = Value(isha),
       latitude = Value(latitude),
       longitude = Value(longitude);
  static Insertable<PrayerTime> custom({
    Expression<String>? date,
    Expression<String>? fajr,
    Expression<String>? dhuhr,
    Expression<String>? asr,
    Expression<String>? maghrib,
    Expression<String>? isha,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? locationName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (fajr != null) 'fajr': fajr,
      if (dhuhr != null) 'dhuhr': dhuhr,
      if (asr != null) 'asr': asr,
      if (maghrib != null) 'maghrib': maghrib,
      if (isha != null) 'isha': isha,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (locationName != null) 'location_name': locationName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrayerTimesCompanion copyWith({
    Value<String>? date,
    Value<String>? fajr,
    Value<String>? dhuhr,
    Value<String>? asr,
    Value<String>? maghrib,
    Value<String>? isha,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<String?>? locationName,
    Value<int>? rowid,
  }) {
    return PrayerTimesCompanion(
      date: date ?? this.date,
      fajr: fajr ?? this.fajr,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (fajr.present) {
      map['fajr'] = Variable<String>(fajr.value);
    }
    if (dhuhr.present) {
      map['dhuhr'] = Variable<String>(dhuhr.value);
    }
    if (asr.present) {
      map['asr'] = Variable<String>(asr.value);
    }
    if (maghrib.present) {
      map['maghrib'] = Variable<String>(maghrib.value);
    }
    if (isha.present) {
      map['isha'] = Variable<String>(isha.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (locationName.present) {
      map['location_name'] = Variable<String>(locationName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrayerTimesCompanion(')
          ..write('date: $date, ')
          ..write('fajr: $fajr, ')
          ..write('dhuhr: $dhuhr, ')
          ..write('asr: $asr, ')
          ..write('maghrib: $maghrib, ')
          ..write('isha: $isha, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('locationName: $locationName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SurahsTable surahs = $SurahsTable(this);
  late final $SurahPoolEntriesTable surahPoolEntries = $SurahPoolEntriesTable(
    this,
  );
  late final $MonthPlansTable monthPlans = $MonthPlansTable(this);
  late final $PrayerTimesTable prayerTimes = $PrayerTimesTable(this);
  late final SurahDao surahDao = SurahDao(this as AppDatabase);
  late final PoolEntryDao poolEntryDao = PoolEntryDao(this as AppDatabase);
  late final MonthPlanDao monthPlanDao = MonthPlanDao(this as AppDatabase);
  late final PrayerTimeDao prayerTimeDao = PrayerTimeDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    surahs,
    surahPoolEntries,
    monthPlans,
    prayerTimes,
  ];
}

typedef $$SurahsTableCreateCompanionBuilder =
    SurahsCompanion Function({
      Value<int> id,
      required String name,
      Value<String> nameId,
      required String arabicName,
      required int ayatCount,
      Value<int> startJuz,
      Value<int> endJuz,
    });
typedef $$SurahsTableUpdateCompanionBuilder =
    SurahsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> nameId,
      Value<String> arabicName,
      Value<int> ayatCount,
      Value<int> startJuz,
      Value<int> endJuz,
    });

final class $$SurahsTableReferences
    extends BaseReferences<_$AppDatabase, $SurahsTable, SurahRow> {
  $$SurahsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SurahPoolEntriesTable, List<SurahPoolEntryRow>>
  _surahPoolEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.surahPoolEntries,
    aliasName: $_aliasNameGenerator(db.surahs.id, db.surahPoolEntries.surahId),
  );

  $$SurahPoolEntriesTableProcessedTableManager get surahPoolEntriesRefs {
    final manager = $$SurahPoolEntriesTableTableManager(
      $_db,
      $_db.surahPoolEntries,
    ).filter((f) => f.surahId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _surahPoolEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SurahsTableFilterComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameId => $composableBuilder(
    column: $table.nameId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arabicName => $composableBuilder(
    column: $table.arabicName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayatCount => $composableBuilder(
    column: $table.ayatCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startJuz => $composableBuilder(
    column: $table.startJuz,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endJuz => $composableBuilder(
    column: $table.endJuz,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> surahPoolEntriesRefs(
    Expression<bool> Function($$SurahPoolEntriesTableFilterComposer f) f,
  ) {
    final $$SurahPoolEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.surahPoolEntries,
      getReferencedColumn: (t) => t.surahId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SurahPoolEntriesTableFilterComposer(
            $db: $db,
            $table: $db.surahPoolEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SurahsTableOrderingComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameId => $composableBuilder(
    column: $table.nameId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arabicName => $composableBuilder(
    column: $table.arabicName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayatCount => $composableBuilder(
    column: $table.ayatCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startJuz => $composableBuilder(
    column: $table.startJuz,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endJuz => $composableBuilder(
    column: $table.endJuz,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SurahsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameId =>
      $composableBuilder(column: $table.nameId, builder: (column) => column);

  GeneratedColumn<String> get arabicName => $composableBuilder(
    column: $table.arabicName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ayatCount =>
      $composableBuilder(column: $table.ayatCount, builder: (column) => column);

  GeneratedColumn<int> get startJuz =>
      $composableBuilder(column: $table.startJuz, builder: (column) => column);

  GeneratedColumn<int> get endJuz =>
      $composableBuilder(column: $table.endJuz, builder: (column) => column);

  Expression<T> surahPoolEntriesRefs<T extends Object>(
    Expression<T> Function($$SurahPoolEntriesTableAnnotationComposer a) f,
  ) {
    final $$SurahPoolEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.surahPoolEntries,
      getReferencedColumn: (t) => t.surahId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SurahPoolEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.surahPoolEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SurahsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SurahsTable,
          SurahRow,
          $$SurahsTableFilterComposer,
          $$SurahsTableOrderingComposer,
          $$SurahsTableAnnotationComposer,
          $$SurahsTableCreateCompanionBuilder,
          $$SurahsTableUpdateCompanionBuilder,
          (SurahRow, $$SurahsTableReferences),
          SurahRow,
          PrefetchHooks Function({bool surahPoolEntriesRefs})
        > {
  $$SurahsTableTableManager(_$AppDatabase db, $SurahsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SurahsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SurahsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SurahsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nameId = const Value.absent(),
                Value<String> arabicName = const Value.absent(),
                Value<int> ayatCount = const Value.absent(),
                Value<int> startJuz = const Value.absent(),
                Value<int> endJuz = const Value.absent(),
              }) => SurahsCompanion(
                id: id,
                name: name,
                nameId: nameId,
                arabicName: arabicName,
                ayatCount: ayatCount,
                startJuz: startJuz,
                endJuz: endJuz,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> nameId = const Value.absent(),
                required String arabicName,
                required int ayatCount,
                Value<int> startJuz = const Value.absent(),
                Value<int> endJuz = const Value.absent(),
              }) => SurahsCompanion.insert(
                id: id,
                name: name,
                nameId: nameId,
                arabicName: arabicName,
                ayatCount: ayatCount,
                startJuz: startJuz,
                endJuz: endJuz,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$SurahsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({surahPoolEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (surahPoolEntriesRefs) db.surahPoolEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (surahPoolEntriesRefs)
                    await $_getPrefetchedData<
                      SurahRow,
                      $SurahsTable,
                      SurahPoolEntryRow
                    >(
                      currentTable: table,
                      referencedTable: $$SurahsTableReferences
                          ._surahPoolEntriesRefsTable(db),
                      managerFromTypedResult: (p0) => $$SurahsTableReferences(
                        db,
                        table,
                        p0,
                      ).surahPoolEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.surahId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SurahsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SurahsTable,
      SurahRow,
      $$SurahsTableFilterComposer,
      $$SurahsTableOrderingComposer,
      $$SurahsTableAnnotationComposer,
      $$SurahsTableCreateCompanionBuilder,
      $$SurahsTableUpdateCompanionBuilder,
      (SurahRow, $$SurahsTableReferences),
      SurahRow,
      PrefetchHooks Function({bool surahPoolEntriesRefs})
    >;
typedef $$SurahPoolEntriesTableCreateCompanionBuilder =
    SurahPoolEntriesCompanion Function({
      Value<int> id,
      required int surahId,
      required bool isFullSurah,
      Value<int?> startAyah,
      Value<int?> endAyah,
      Value<bool> enabled,
    });
typedef $$SurahPoolEntriesTableUpdateCompanionBuilder =
    SurahPoolEntriesCompanion Function({
      Value<int> id,
      Value<int> surahId,
      Value<bool> isFullSurah,
      Value<int?> startAyah,
      Value<int?> endAyah,
      Value<bool> enabled,
    });

final class $$SurahPoolEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SurahPoolEntriesTable,
          SurahPoolEntryRow
        > {
  $$SurahPoolEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SurahsTable _surahIdTable(_$AppDatabase db) => db.surahs.createAlias(
    $_aliasNameGenerator(db.surahPoolEntries.surahId, db.surahs.id),
  );

  $$SurahsTableProcessedTableManager get surahId {
    final $_column = $_itemColumn<int>('surah_id')!;

    final manager = $$SurahsTableTableManager(
      $_db,
      $_db.surahs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_surahIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SurahPoolEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SurahPoolEntriesTable> {
  $$SurahPoolEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFullSurah => $composableBuilder(
    column: $table.isFullSurah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startAyah => $composableBuilder(
    column: $table.startAyah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endAyah => $composableBuilder(
    column: $table.endAyah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  $$SurahsTableFilterComposer get surahId {
    final $$SurahsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.surahId,
      referencedTable: $db.surahs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SurahsTableFilterComposer(
            $db: $db,
            $table: $db.surahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SurahPoolEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SurahPoolEntriesTable> {
  $$SurahPoolEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFullSurah => $composableBuilder(
    column: $table.isFullSurah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startAyah => $composableBuilder(
    column: $table.startAyah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endAyah => $composableBuilder(
    column: $table.endAyah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  $$SurahsTableOrderingComposer get surahId {
    final $$SurahsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.surahId,
      referencedTable: $db.surahs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SurahsTableOrderingComposer(
            $db: $db,
            $table: $db.surahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SurahPoolEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SurahPoolEntriesTable> {
  $$SurahPoolEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isFullSurah => $composableBuilder(
    column: $table.isFullSurah,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startAyah =>
      $composableBuilder(column: $table.startAyah, builder: (column) => column);

  GeneratedColumn<int> get endAyah =>
      $composableBuilder(column: $table.endAyah, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  $$SurahsTableAnnotationComposer get surahId {
    final $$SurahsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.surahId,
      referencedTable: $db.surahs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SurahsTableAnnotationComposer(
            $db: $db,
            $table: $db.surahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SurahPoolEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SurahPoolEntriesTable,
          SurahPoolEntryRow,
          $$SurahPoolEntriesTableFilterComposer,
          $$SurahPoolEntriesTableOrderingComposer,
          $$SurahPoolEntriesTableAnnotationComposer,
          $$SurahPoolEntriesTableCreateCompanionBuilder,
          $$SurahPoolEntriesTableUpdateCompanionBuilder,
          (SurahPoolEntryRow, $$SurahPoolEntriesTableReferences),
          SurahPoolEntryRow,
          PrefetchHooks Function({bool surahId})
        > {
  $$SurahPoolEntriesTableTableManager(
    _$AppDatabase db,
    $SurahPoolEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SurahPoolEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SurahPoolEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SurahPoolEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> surahId = const Value.absent(),
                Value<bool> isFullSurah = const Value.absent(),
                Value<int?> startAyah = const Value.absent(),
                Value<int?> endAyah = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
              }) => SurahPoolEntriesCompanion(
                id: id,
                surahId: surahId,
                isFullSurah: isFullSurah,
                startAyah: startAyah,
                endAyah: endAyah,
                enabled: enabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int surahId,
                required bool isFullSurah,
                Value<int?> startAyah = const Value.absent(),
                Value<int?> endAyah = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
              }) => SurahPoolEntriesCompanion.insert(
                id: id,
                surahId: surahId,
                isFullSurah: isFullSurah,
                startAyah: startAyah,
                endAyah: endAyah,
                enabled: enabled,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SurahPoolEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({surahId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (surahId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.surahId,
                                referencedTable:
                                    $$SurahPoolEntriesTableReferences
                                        ._surahIdTable(db),
                                referencedColumn:
                                    $$SurahPoolEntriesTableReferences
                                        ._surahIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SurahPoolEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SurahPoolEntriesTable,
      SurahPoolEntryRow,
      $$SurahPoolEntriesTableFilterComposer,
      $$SurahPoolEntriesTableOrderingComposer,
      $$SurahPoolEntriesTableAnnotationComposer,
      $$SurahPoolEntriesTableCreateCompanionBuilder,
      $$SurahPoolEntriesTableUpdateCompanionBuilder,
      (SurahPoolEntryRow, $$SurahPoolEntriesTableReferences),
      SurahPoolEntryRow,
      PrefetchHooks Function({bool surahId})
    >;
typedef $$MonthPlansTableCreateCompanionBuilder =
    MonthPlansCompanion Function({
      required int year,
      required int month,
      required String planJson,
      Value<int> rowid,
    });
typedef $$MonthPlansTableUpdateCompanionBuilder =
    MonthPlansCompanion Function({
      Value<int> year,
      Value<int> month,
      Value<String> planJson,
      Value<int> rowid,
    });

class $$MonthPlansTableFilterComposer
    extends Composer<_$AppDatabase, $MonthPlansTable> {
  $$MonthPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planJson => $composableBuilder(
    column: $table.planJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MonthPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthPlansTable> {
  $$MonthPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planJson => $composableBuilder(
    column: $table.planJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MonthPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthPlansTable> {
  $$MonthPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<String> get planJson =>
      $composableBuilder(column: $table.planJson, builder: (column) => column);
}

class $$MonthPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MonthPlansTable,
          MonthPlanRow,
          $$MonthPlansTableFilterComposer,
          $$MonthPlansTableOrderingComposer,
          $$MonthPlansTableAnnotationComposer,
          $$MonthPlansTableCreateCompanionBuilder,
          $$MonthPlansTableUpdateCompanionBuilder,
          (
            MonthPlanRow,
            BaseReferences<_$AppDatabase, $MonthPlansTable, MonthPlanRow>,
          ),
          MonthPlanRow,
          PrefetchHooks Function()
        > {
  $$MonthPlansTableTableManager(_$AppDatabase db, $MonthPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonthPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonthPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonthPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> year = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<String> planJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MonthPlansCompanion(
                year: year,
                month: month,
                planJson: planJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int year,
                required int month,
                required String planJson,
                Value<int> rowid = const Value.absent(),
              }) => MonthPlansCompanion.insert(
                year: year,
                month: month,
                planJson: planJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MonthPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MonthPlansTable,
      MonthPlanRow,
      $$MonthPlansTableFilterComposer,
      $$MonthPlansTableOrderingComposer,
      $$MonthPlansTableAnnotationComposer,
      $$MonthPlansTableCreateCompanionBuilder,
      $$MonthPlansTableUpdateCompanionBuilder,
      (
        MonthPlanRow,
        BaseReferences<_$AppDatabase, $MonthPlansTable, MonthPlanRow>,
      ),
      MonthPlanRow,
      PrefetchHooks Function()
    >;
typedef $$PrayerTimesTableCreateCompanionBuilder =
    PrayerTimesCompanion Function({
      required String date,
      required String fajr,
      required String dhuhr,
      required String asr,
      required String maghrib,
      required String isha,
      required double latitude,
      required double longitude,
      Value<String?> locationName,
      Value<int> rowid,
    });
typedef $$PrayerTimesTableUpdateCompanionBuilder =
    PrayerTimesCompanion Function({
      Value<String> date,
      Value<String> fajr,
      Value<String> dhuhr,
      Value<String> asr,
      Value<String> maghrib,
      Value<String> isha,
      Value<double> latitude,
      Value<double> longitude,
      Value<String?> locationName,
      Value<int> rowid,
    });

class $$PrayerTimesTableFilterComposer
    extends Composer<_$AppDatabase, $PrayerTimesTable> {
  $$PrayerTimesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fajr => $composableBuilder(
    column: $table.fajr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dhuhr => $composableBuilder(
    column: $table.dhuhr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get asr => $composableBuilder(
    column: $table.asr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get maghrib => $composableBuilder(
    column: $table.maghrib,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isha => $composableBuilder(
    column: $table.isha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PrayerTimesTableOrderingComposer
    extends Composer<_$AppDatabase, $PrayerTimesTable> {
  $$PrayerTimesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fajr => $composableBuilder(
    column: $table.fajr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dhuhr => $composableBuilder(
    column: $table.dhuhr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get asr => $composableBuilder(
    column: $table.asr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get maghrib => $composableBuilder(
    column: $table.maghrib,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isha => $composableBuilder(
    column: $table.isha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrayerTimesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrayerTimesTable> {
  $$PrayerTimesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get fajr =>
      $composableBuilder(column: $table.fajr, builder: (column) => column);

  GeneratedColumn<String> get dhuhr =>
      $composableBuilder(column: $table.dhuhr, builder: (column) => column);

  GeneratedColumn<String> get asr =>
      $composableBuilder(column: $table.asr, builder: (column) => column);

  GeneratedColumn<String> get maghrib =>
      $composableBuilder(column: $table.maghrib, builder: (column) => column);

  GeneratedColumn<String> get isha =>
      $composableBuilder(column: $table.isha, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => column,
  );
}

class $$PrayerTimesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrayerTimesTable,
          PrayerTime,
          $$PrayerTimesTableFilterComposer,
          $$PrayerTimesTableOrderingComposer,
          $$PrayerTimesTableAnnotationComposer,
          $$PrayerTimesTableCreateCompanionBuilder,
          $$PrayerTimesTableUpdateCompanionBuilder,
          (
            PrayerTime,
            BaseReferences<_$AppDatabase, $PrayerTimesTable, PrayerTime>,
          ),
          PrayerTime,
          PrefetchHooks Function()
        > {
  $$PrayerTimesTableTableManager(_$AppDatabase db, $PrayerTimesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrayerTimesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrayerTimesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrayerTimesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<String> fajr = const Value.absent(),
                Value<String> dhuhr = const Value.absent(),
                Value<String> asr = const Value.absent(),
                Value<String> maghrib = const Value.absent(),
                Value<String> isha = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<String?> locationName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrayerTimesCompanion(
                date: date,
                fajr: fajr,
                dhuhr: dhuhr,
                asr: asr,
                maghrib: maghrib,
                isha: isha,
                latitude: latitude,
                longitude: longitude,
                locationName: locationName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required String fajr,
                required String dhuhr,
                required String asr,
                required String maghrib,
                required String isha,
                required double latitude,
                required double longitude,
                Value<String?> locationName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrayerTimesCompanion.insert(
                date: date,
                fajr: fajr,
                dhuhr: dhuhr,
                asr: asr,
                maghrib: maghrib,
                isha: isha,
                latitude: latitude,
                longitude: longitude,
                locationName: locationName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PrayerTimesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrayerTimesTable,
      PrayerTime,
      $$PrayerTimesTableFilterComposer,
      $$PrayerTimesTableOrderingComposer,
      $$PrayerTimesTableAnnotationComposer,
      $$PrayerTimesTableCreateCompanionBuilder,
      $$PrayerTimesTableUpdateCompanionBuilder,
      (
        PrayerTime,
        BaseReferences<_$AppDatabase, $PrayerTimesTable, PrayerTime>,
      ),
      PrayerTime,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db, _db.surahs);
  $$SurahPoolEntriesTableTableManager get surahPoolEntries =>
      $$SurahPoolEntriesTableTableManager(_db, _db.surahPoolEntries);
  $$MonthPlansTableTableManager get monthPlans =>
      $$MonthPlansTableTableManager(_db, _db.monthPlans);
  $$PrayerTimesTableTableManager get prayerTimes =>
      $$PrayerTimesTableTableManager(_db, _db.prayerTimes);
}

mixin _$SurahDaoMixin on DatabaseAccessor<AppDatabase> {
  $SurahsTable get surahs => attachedDatabase.surahs;
  SurahDaoManager get managers => SurahDaoManager(this);
}

class SurahDaoManager {
  final _$SurahDaoMixin _db;
  SurahDaoManager(this._db);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db.attachedDatabase, _db.surahs);
}

mixin _$PoolEntryDaoMixin on DatabaseAccessor<AppDatabase> {
  $SurahsTable get surahs => attachedDatabase.surahs;
  $SurahPoolEntriesTable get surahPoolEntries =>
      attachedDatabase.surahPoolEntries;
  PoolEntryDaoManager get managers => PoolEntryDaoManager(this);
}

class PoolEntryDaoManager {
  final _$PoolEntryDaoMixin _db;
  PoolEntryDaoManager(this._db);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db.attachedDatabase, _db.surahs);
  $$SurahPoolEntriesTableTableManager get surahPoolEntries =>
      $$SurahPoolEntriesTableTableManager(
        _db.attachedDatabase,
        _db.surahPoolEntries,
      );
}

mixin _$MonthPlanDaoMixin on DatabaseAccessor<AppDatabase> {
  $MonthPlansTable get monthPlans => attachedDatabase.monthPlans;
  MonthPlanDaoManager get managers => MonthPlanDaoManager(this);
}

class MonthPlanDaoManager {
  final _$MonthPlanDaoMixin _db;
  MonthPlanDaoManager(this._db);
  $$MonthPlansTableTableManager get monthPlans =>
      $$MonthPlansTableTableManager(_db.attachedDatabase, _db.monthPlans);
}

mixin _$PrayerTimeDaoMixin on DatabaseAccessor<AppDatabase> {
  $PrayerTimesTable get prayerTimes => attachedDatabase.prayerTimes;
  PrayerTimeDaoManager get managers => PrayerTimeDaoManager(this);
}

class PrayerTimeDaoManager {
  final _$PrayerTimeDaoMixin _db;
  PrayerTimeDaoManager(this._db);
  $$PrayerTimesTableTableManager get prayerTimes =>
      $$PrayerTimesTableTableManager(_db.attachedDatabase, _db.prayerTimes);
}
