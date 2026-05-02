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
  @override
  List<GeneratedColumn> get $columns => [id, name, arabicName, ayatCount];
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
      arabicName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arabic_name'],
      )!,
      ayatCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayat_count'],
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
  final String arabicName;
  final int ayatCount;
  const SurahRow({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.ayatCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['arabic_name'] = Variable<String>(arabicName);
    map['ayat_count'] = Variable<int>(ayatCount);
    return map;
  }

  SurahsCompanion toCompanion(bool nullToAbsent) {
    return SurahsCompanion(
      id: Value(id),
      name: Value(name),
      arabicName: Value(arabicName),
      ayatCount: Value(ayatCount),
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
      arabicName: serializer.fromJson<String>(json['arabicName']),
      ayatCount: serializer.fromJson<int>(json['ayatCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'arabicName': serializer.toJson<String>(arabicName),
      'ayatCount': serializer.toJson<int>(ayatCount),
    };
  }

  SurahRow copyWith({
    int? id,
    String? name,
    String? arabicName,
    int? ayatCount,
  }) => SurahRow(
    id: id ?? this.id,
    name: name ?? this.name,
    arabicName: arabicName ?? this.arabicName,
    ayatCount: ayatCount ?? this.ayatCount,
  );
  SurahRow copyWithCompanion(SurahsCompanion data) {
    return SurahRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      arabicName: data.arabicName.present
          ? data.arabicName.value
          : this.arabicName,
      ayatCount: data.ayatCount.present ? data.ayatCount.value : this.ayatCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SurahRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('arabicName: $arabicName, ')
          ..write('ayatCount: $ayatCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, arabicName, ayatCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SurahRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.arabicName == this.arabicName &&
          other.ayatCount == this.ayatCount);
}

class SurahsCompanion extends UpdateCompanion<SurahRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> arabicName;
  final Value<int> ayatCount;
  const SurahsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.arabicName = const Value.absent(),
    this.ayatCount = const Value.absent(),
  });
  SurahsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String arabicName,
    required int ayatCount,
  }) : name = Value(name),
       arabicName = Value(arabicName),
       ayatCount = Value(ayatCount);
  static Insertable<SurahRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? arabicName,
    Expression<int>? ayatCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (arabicName != null) 'arabic_name': arabicName,
      if (ayatCount != null) 'ayat_count': ayatCount,
    });
  }

  SurahsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? arabicName,
    Value<int>? ayatCount,
  }) {
    return SurahsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      arabicName: arabicName ?? this.arabicName,
      ayatCount: ayatCount ?? this.ayatCount,
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
    if (arabicName.present) {
      map['arabic_name'] = Variable<String>(arabicName.value);
    }
    if (ayatCount.present) {
      map['ayat_count'] = Variable<int>(ayatCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurahsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('arabicName: $arabicName, ')
          ..write('ayatCount: $ayatCount')
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SurahsTable surahs = $SurahsTable(this);
  late final $SurahPoolEntriesTable surahPoolEntries = $SurahPoolEntriesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    surahs,
    surahPoolEntries,
  ];
}

typedef $$SurahsTableCreateCompanionBuilder =
    SurahsCompanion Function({
      Value<int> id,
      required String name,
      required String arabicName,
      required int ayatCount,
    });
typedef $$SurahsTableUpdateCompanionBuilder =
    SurahsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> arabicName,
      Value<int> ayatCount,
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

  ColumnFilters<String> get arabicName => $composableBuilder(
    column: $table.arabicName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayatCount => $composableBuilder(
    column: $table.ayatCount,
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

  ColumnOrderings<String> get arabicName => $composableBuilder(
    column: $table.arabicName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayatCount => $composableBuilder(
    column: $table.ayatCount,
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

  GeneratedColumn<String> get arabicName => $composableBuilder(
    column: $table.arabicName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ayatCount =>
      $composableBuilder(column: $table.ayatCount, builder: (column) => column);

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
                Value<String> arabicName = const Value.absent(),
                Value<int> ayatCount = const Value.absent(),
              }) => SurahsCompanion(
                id: id,
                name: name,
                arabicName: arabicName,
                ayatCount: ayatCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String arabicName,
                required int ayatCount,
              }) => SurahsCompanion.insert(
                id: id,
                name: name,
                arabicName: arabicName,
                ayatCount: ayatCount,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db, _db.surahs);
  $$SurahPoolEntriesTableTableManager get surahPoolEntries =>
      $$SurahPoolEntriesTableTableManager(_db, _db.surahPoolEntries);
}
