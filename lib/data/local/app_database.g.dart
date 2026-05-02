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
  static const VerificationMeta _ayatRangeMeta = const VerificationMeta(
    'ayatRange',
  );
  @override
  late final GeneratedColumn<String> ayatRange = GeneratedColumn<String>(
    'ayat_range',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
    name,
    arabicName,
    ayatCount,
    ayatRange,
    enabled,
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
    if (data.containsKey('ayat_range')) {
      context.handle(
        _ayatRangeMeta,
        ayatRange.isAcceptableOrUnknown(data['ayat_range']!, _ayatRangeMeta),
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
      ayatRange: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ayat_range'],
      ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
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
  final String? ayatRange;
  final bool enabled;
  const SurahRow({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.ayatCount,
    this.ayatRange,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['arabic_name'] = Variable<String>(arabicName);
    map['ayat_count'] = Variable<int>(ayatCount);
    if (!nullToAbsent || ayatRange != null) {
      map['ayat_range'] = Variable<String>(ayatRange);
    }
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  SurahsCompanion toCompanion(bool nullToAbsent) {
    return SurahsCompanion(
      id: Value(id),
      name: Value(name),
      arabicName: Value(arabicName),
      ayatCount: Value(ayatCount),
      ayatRange: ayatRange == null && nullToAbsent
          ? const Value.absent()
          : Value(ayatRange),
      enabled: Value(enabled),
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
      ayatRange: serializer.fromJson<String?>(json['ayatRange']),
      enabled: serializer.fromJson<bool>(json['enabled']),
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
      'ayatRange': serializer.toJson<String?>(ayatRange),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  SurahRow copyWith({
    int? id,
    String? name,
    String? arabicName,
    int? ayatCount,
    Value<String?> ayatRange = const Value.absent(),
    bool? enabled,
  }) => SurahRow(
    id: id ?? this.id,
    name: name ?? this.name,
    arabicName: arabicName ?? this.arabicName,
    ayatCount: ayatCount ?? this.ayatCount,
    ayatRange: ayatRange.present ? ayatRange.value : this.ayatRange,
    enabled: enabled ?? this.enabled,
  );
  SurahRow copyWithCompanion(SurahsCompanion data) {
    return SurahRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      arabicName: data.arabicName.present
          ? data.arabicName.value
          : this.arabicName,
      ayatCount: data.ayatCount.present ? data.ayatCount.value : this.ayatCount,
      ayatRange: data.ayatRange.present ? data.ayatRange.value : this.ayatRange,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SurahRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('arabicName: $arabicName, ')
          ..write('ayatCount: $ayatCount, ')
          ..write('ayatRange: $ayatRange, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, arabicName, ayatCount, ayatRange, enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SurahRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.arabicName == this.arabicName &&
          other.ayatCount == this.ayatCount &&
          other.ayatRange == this.ayatRange &&
          other.enabled == this.enabled);
}

class SurahsCompanion extends UpdateCompanion<SurahRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> arabicName;
  final Value<int> ayatCount;
  final Value<String?> ayatRange;
  final Value<bool> enabled;
  const SurahsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.arabicName = const Value.absent(),
    this.ayatCount = const Value.absent(),
    this.ayatRange = const Value.absent(),
    this.enabled = const Value.absent(),
  });
  SurahsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String arabicName,
    required int ayatCount,
    this.ayatRange = const Value.absent(),
    this.enabled = const Value.absent(),
  }) : name = Value(name),
       arabicName = Value(arabicName),
       ayatCount = Value(ayatCount);
  static Insertable<SurahRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? arabicName,
    Expression<int>? ayatCount,
    Expression<String>? ayatRange,
    Expression<bool>? enabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (arabicName != null) 'arabic_name': arabicName,
      if (ayatCount != null) 'ayat_count': ayatCount,
      if (ayatRange != null) 'ayat_range': ayatRange,
      if (enabled != null) 'enabled': enabled,
    });
  }

  SurahsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? arabicName,
    Value<int>? ayatCount,
    Value<String?>? ayatRange,
    Value<bool>? enabled,
  }) {
    return SurahsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      arabicName: arabicName ?? this.arabicName,
      ayatCount: ayatCount ?? this.ayatCount,
      ayatRange: ayatRange ?? this.ayatRange,
      enabled: enabled ?? this.enabled,
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
    if (ayatRange.present) {
      map['ayat_range'] = Variable<String>(ayatRange.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurahsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('arabicName: $arabicName, ')
          ..write('ayatCount: $ayatCount, ')
          ..write('ayatRange: $ayatRange, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SurahsTable surahs = $SurahsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [surahs];
}

typedef $$SurahsTableCreateCompanionBuilder =
    SurahsCompanion Function({
      Value<int> id,
      required String name,
      required String arabicName,
      required int ayatCount,
      Value<String?> ayatRange,
      Value<bool> enabled,
    });
typedef $$SurahsTableUpdateCompanionBuilder =
    SurahsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> arabicName,
      Value<int> ayatCount,
      Value<String?> ayatRange,
      Value<bool> enabled,
    });

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

  ColumnFilters<String> get ayatRange => $composableBuilder(
    column: $table.ayatRange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );
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

  ColumnOrderings<String> get ayatRange => $composableBuilder(
    column: $table.ayatRange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
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

  GeneratedColumn<String> get ayatRange =>
      $composableBuilder(column: $table.ayatRange, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);
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
          (SurahRow, BaseReferences<_$AppDatabase, $SurahsTable, SurahRow>),
          SurahRow,
          PrefetchHooks Function()
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
                Value<String?> ayatRange = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
              }) => SurahsCompanion(
                id: id,
                name: name,
                arabicName: arabicName,
                ayatCount: ayatCount,
                ayatRange: ayatRange,
                enabled: enabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String arabicName,
                required int ayatCount,
                Value<String?> ayatRange = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
              }) => SurahsCompanion.insert(
                id: id,
                name: name,
                arabicName: arabicName,
                ayatCount: ayatCount,
                ayatRange: ayatRange,
                enabled: enabled,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
      (SurahRow, BaseReferences<_$AppDatabase, $SurahsTable, SurahRow>),
      SurahRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db, _db.surahs);
}
