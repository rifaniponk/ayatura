part of '../app_database.dart';

@DriftAccessor(tables: [SurahPoolEntries])
class PoolEntryDao extends DatabaseAccessor<AppDatabase>
    with _$PoolEntryDaoMixin {
  PoolEntryDao(super.db);

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

SurahPoolEntry _poolRowToEntry(SurahPoolEntryRow r) => SurahPoolEntry(
  id: r.id,
  surahId: r.surahId,
  isFullSurah: r.isFullSurah,
  startAyah: r.startAyah,
  endAyah: r.endAyah,
  enabled: r.enabled,
);
