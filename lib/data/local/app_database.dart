import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/plan.dart';
import '../models/surah.dart';
import '../models/surah_pool_entry.dart';

part 'app_database.g.dart';

@DataClassName('SurahRow')
class Surahs extends Table {
  IntColumn get id => integer()();

  TextColumn get name => text()();

  TextColumn get nameId => text().withDefault(const Constant(''))();

  TextColumn get arabicName => text()();

  IntColumn get ayatCount => integer()();

  IntColumn get startJuz => integer().withDefault(const Constant(1))();

  IntColumn get endJuz => integer().withDefault(const Constant(1))();

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

@DataClassName('MonthPlanRow')
class MonthPlans extends Table {
  IntColumn get year => integer()();

  IntColumn get month => integer()();

  TextColumn get planJson => text()();

  @override
  Set<Column<Object>>? get primaryKey => {year, month};
}

@DriftDatabase(tables: [Surahs, SurahPoolEntries, MonthPlans])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'surah_planner'));

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(surahPoolEntries);
      }
      if (from < 3) {
        await m.addColumn(surahs, surahs.startJuz);
        await m.addColumn(surahs, surahs.endJuz);
      }
      if (from < 4) {
        await m.addColumn(surahs, surahs.nameId);
      }
      if (from < 5) {
        await m.createTable(monthPlans);
      }
    },
  );

  Future<int> surahRowCount() => surahs.count().getSingle();

  /// Inserts bundled master surahs when the table is empty, then refreshes
  /// `start_juz`, `end_juz`, and `name_id` from [list] for every row (covers app
  /// upgrades that add columns).
  ///
  /// Runs in one transaction; does not touch [surahPoolEntries].
  Future<void> seedMasterSurahsIfEmpty(List<Surah> list) async {
    if (list.isEmpty) return;
    await transaction(() async {
      final n = await surahs.count().getSingle();
      if (n == 0) {
        await batch((b) {
          b.insertAll(surahs, list.map(_surahToCompanion).toList());
        });
      }
      await batch((b) {
        for (final s in list) {
          b.update(
            surahs,
            SurahsCompanion(
              startJuz: Value(s.startJuz),
              endJuz: Value(s.endJuz),
              nameId: Value(s.nameId),
            ),
            where: (t) => t.id.equals(s.id),
          );
        }
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

  /// Loads the most recently stored plan (by calendar year/month).
  Future<MonthPlan?> loadLatestPlan() async {
    final row =
        await (select(monthPlans)
              ..orderBy([
                (t) => OrderingTerm.desc(t.year),
                (t) => OrderingTerm.desc(t.month),
              ])
              ..limit(1))
            .getSingleOrNull();
    if (row == null) return null;
    return MonthPlan.fromJson(jsonDecode(row.planJson) as Map<String, dynamic>);
  }

  /// Persists [plan] as the sole stored row (all other months are removed).
  ///
  /// NOTE: single-plan storage — only one month is kept at a time.
  /// Issue #31 (multi-month navigation) will require changing this to
  /// upsert per (year, month) without deleting other rows.
  Future<void> savePlan(MonthPlan plan) async {
    await transaction(() async {
      await delete(monthPlans).go();
      await into(monthPlans).insert(
        MonthPlansCompanion.insert(
          year: plan.year,
          month: plan.month,
          planJson: jsonEncode(plan.toJson()),
        ),
      );
    });
  }

  Future<void> deletePlan(int year, int month) {
    return (delete(
      monthPlans,
    )..where((t) => t.year.equals(year) & t.month.equals(month))).go();
  }
}

Surah _rowToSurah(SurahRow r) => Surah(
  id: r.id,
  name: r.name,
  nameId: r.nameId.isEmpty ? r.name : r.nameId,
  arabicName: r.arabicName,
  ayatCount: r.ayatCount,
  startJuz: r.startJuz,
  endJuz: r.endJuz,
);

SurahsCompanion _surahToCompanion(Surah s) => SurahsCompanion.insert(
  id: Value(s.id),
  name: s.name,
  nameId: Value(s.nameId),
  arabicName: s.arabicName,
  ayatCount: s.ayatCount,
  startJuz: Value(s.startJuz),
  endJuz: Value(s.endJuz),
);

SurahPoolEntry _poolRowToEntry(SurahPoolEntryRow r) => SurahPoolEntry(
  id: r.id,
  surahId: r.surahId,
  isFullSurah: r.isFullSurah,
  startAyah: r.startAyah,
  endAyah: r.endAyah,
  enabled: r.enabled,
);
