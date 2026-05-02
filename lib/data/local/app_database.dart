import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/surah.dart';
import '../models/surah_pool_entry.dart';

part 'app_database.g.dart';

@DataClassName('SurahRow')
class Surahs extends Table {
  IntColumn get id => integer()();

  TextColumn get name => text()();

  TextColumn get arabicName => text()();

  IntColumn get ayatCount => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DataClassName('SurahPoolEntryRow')
class SurahPoolEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get surahId => integer().references(Surahs, #id)();

  BoolColumn get isFullSurah => boolean()();

  IntColumn get startAyah => integer().nullable()();

  IntColumn get endAyah => integer().nullable()();

  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
}

@DriftDatabase(tables: [Surahs, SurahPoolEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'surah_planner.sqlite'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(surahPoolEntries);
      }
    },
  );

  Future<int> surahRowCount() => surahs.count().getSingle();

  /// Inserts master surahs only when the table is empty (typical first launch).
  ///
  /// Runs the empty-check and inserts in one transaction so a restart never
  /// re-applies seed after data exists, and concurrent callers cannot double-seed.
  /// Does not touch [surahPoolEntries].
  Future<void> seedMasterSurahsIfEmpty(List<Surah> list) async {
    if (list.isEmpty) return;
    await transaction(() async {
      final n = await surahs.count().getSingle();
      if (n > 0) return;
      await batch((b) {
        b.insertAll(surahs, list.map(_surahToCompanion).toList());
      });
    });
  }

  Future<List<Surah>> allSurahs() async {
    final rows = await (select(
      surahs,
    )..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
    return rows.map(_rowToSurah).toList();
  }

  Future<List<SurahPoolEntry>> allPoolEntries() async {
    final rows = await (select(
      surahPoolEntries,
    )..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
    return rows.map(_poolRowToEntry).toList();
  }

  Future<List<SurahPoolEntry>> enabledPoolEntries() async {
    final rows =
        await (select(surahPoolEntries)
              ..where((t) => t.enabled.equals(true))
              ..orderBy([(t) => OrderingTerm.asc(t.id)]))
            .get();
    return rows.map(_poolRowToEntry).toList();
  }

  Future<int> insertPoolEntry(SurahPoolEntriesCompanion row) {
    return into(surahPoolEntries).insert(row);
  }

  Future<void> updatePoolEntry(SurahPoolEntryRow row) {
    return update(surahPoolEntries).replace(row);
  }

  Future<void> setPoolEntryEnabled(int id, bool enabled) async {
    await (update(surahPoolEntries)..where((t) => t.id.equals(id))).write(
      SurahPoolEntriesCompanion(enabled: Value(enabled)),
    );
  }

  Future<int> deletePoolEntry(int id) {
    return (delete(surahPoolEntries)..where((t) => t.id.equals(id))).go();
  }
}

Surah _rowToSurah(SurahRow r) => Surah(
  id: r.id,
  name: r.name,
  arabicName: r.arabicName,
  ayatCount: r.ayatCount,
);

SurahsCompanion _surahToCompanion(Surah s) => SurahsCompanion.insert(
  id: Value(s.id),
  name: s.name,
  arabicName: s.arabicName,
  ayatCount: s.ayatCount,
);

SurahPoolEntry _poolRowToEntry(SurahPoolEntryRow r) => SurahPoolEntry(
  id: r.id,
  surahId: r.surahId,
  isFullSurah: r.isFullSurah,
  startAyah: r.startAyah,
  endAyah: r.endAyah,
  enabled: r.enabled,
);
