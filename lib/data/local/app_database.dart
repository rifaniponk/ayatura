import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/plan.dart';
import '../models/surah.dart';
import '../models/surah_pool_entry.dart';

import 'tables/month_plans_table.dart';
import 'tables/pool_entries_table.dart';
import 'tables/surahs_table.dart';

part 'daos/surah_dao.dart';
part 'daos/pool_entry_dao.dart';
part 'daos/month_plan_dao.dart';
part 'app_database.g.dart';

@DriftDatabase(
  tables: [Surahs, SurahPoolEntries, MonthPlans],
  daos: [SurahDao, PoolEntryDao, MonthPlanDao],
)
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

  Future<int> surahRowCount() => surahDao.surahRowCount();

  Future<void> seedMasterSurahsIfEmpty(List<Surah> list) =>
      surahDao.seedMasterSurahsIfEmpty(list);

  Future<List<Surah>> allSurahs() => surahDao.allSurahs();

  Future<List<SurahPoolEntry>> allPoolEntries() =>
      poolEntryDao.allPoolEntries();

  Future<List<SurahPoolEntry>> enabledPoolEntries() =>
      poolEntryDao.enabledPoolEntries();

  Future<int> insertPoolEntry(SurahPoolEntriesCompanion row) =>
      poolEntryDao.insertPoolEntry(row);

  Future<void> updatePoolEntry(SurahPoolEntryRow row) =>
      poolEntryDao.updatePoolEntry(row);

  Future<void> setPoolEntryEnabled(int id, bool enabled) =>
      poolEntryDao.setPoolEntryEnabled(id, enabled);

  Future<int> deletePoolEntry(int id) => poolEntryDao.deletePoolEntry(id);

  Future<MonthPlan?> loadLatestPlan() => monthPlanDao.loadLatestPlan();

  Future<void> savePlan(MonthPlan plan) => monthPlanDao.savePlan(plan);

  Future<void> deletePlan(int year, int month) =>
      monthPlanDao.deletePlan(year, month);
}
