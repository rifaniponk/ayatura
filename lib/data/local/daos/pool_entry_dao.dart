part of '../app_database.dart';

@DriftAccessor(tables: [SurahPoolEntries])
class PoolEntryDao extends DatabaseAccessor<AppDatabase>
    with _$PoolEntryDaoMixin {
  PoolEntryDao(super.db);

  Future<List<SurahPoolEntry>> allPoolEntries() async {
    final rows = await (select(
      surahPoolEntries,
    )..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
    return rows.map(_toModel).toList();
  }

  Future<List<SurahPoolEntry>> enabledPoolEntries() async {
    final rows =
        await (select(surahPoolEntries)
              ..where((t) => t.enabled.equals(true))
              ..orderBy([(t) => OrderingTerm.asc(t.id)]))
            .get();
    return rows.map(_toModel).toList();
  }

  Future<int> insertPoolEntry(SurahPoolEntriesCompanion row) {
    final now = DateTime.now();
    return into(
      surahPoolEntries,
    ).insert(row.copyWith(createdAt: Value(now), updatedAt: Value(now)));
  }

  Future<void> updatePoolEntry(int id, SurahPoolEntriesCompanion row) {
    return (update(surahPoolEntries)..where((t) => t.id.equals(id))).write(
      row.copyWith(updatedAt: Value(DateTime.now())),
    );
  }

  Future<void> setPoolEntryEnabled(int id, bool enabled) async {
    await (update(surahPoolEntries)..where((t) => t.id.equals(id))).write(
      SurahPoolEntriesCompanion(
        enabled: Value(enabled),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> deletePoolEntry(int id) {
    return (delete(surahPoolEntries)..where((t) => t.id.equals(id))).go();
  }

  Future<void> incrementAssignmentCounts(Iterable<int> entryIds) async {
    final ids = entryIds.toSet().toList();
    if (ids.isEmpty) return;
    final placeholders = List.filled(ids.length, '?').join(', ');
    await customStatement(
      'UPDATE surah_pool_entries '
      'SET assignment_count = assignment_count + 1, updated_at = unixepoch() '
      'WHERE id IN ($placeholders)',
      ids,
    );
  }

  static SurahPoolEntry _toModel(SurahPoolEntryRow r) => SurahPoolEntry(
    id: r.id,
    surahId: r.surahId,
    isFullSurah: r.isFullSurah,
    startAyah: r.startAyah,
    endAyah: r.endAyah,
    enabled: r.enabled,
    assignmentCount: r.assignmentCount,
  );
}
