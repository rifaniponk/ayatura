import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/surah.dart';

part 'app_database.g.dart';

@DataClassName('SurahRow')
class Surahs extends Table {
  IntColumn get id => integer()();

  TextColumn get name => text()();

  TextColumn get arabicName => text()();

  IntColumn get ayatCount => integer()();

  TextColumn get ayatRange => text().nullable()();

  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DriftDatabase(tables: [Surahs])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'surah_planner2.sqlite'));

  @override
  int get schemaVersion => 1;

  Future<int> surahRowCount() => surahs.count().getSingle();

  Future<List<Surah>> allSurahs() async {
    final rows = await (select(
      surahs,
    )..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
    return rows.map(_rowToSurah).toList();
  }

  Future<void> replaceAllSurahs(List<Surah> list) async {
    await transaction(() async {
      await delete(surahs).go();
      await batch((b) {
        b.insertAll(surahs, list.map(_surahToCompanion).toList());
      });
    });
  }
}

Surah _rowToSurah(SurahRow r) => Surah(
  id: r.id,
  name: r.name,
  arabicName: r.arabicName,
  ayatCount: r.ayatCount,
  ayatRange: r.ayatRange,
  enabled: r.enabled,
);

SurahsCompanion _surahToCompanion(Surah s) => SurahsCompanion.insert(
  id: Value(s.id),
  name: s.name,
  arabicName: s.arabicName,
  ayatCount: s.ayatCount,
  ayatRange: Value(s.ayatRange),
  enabled: Value(s.enabled),
);
