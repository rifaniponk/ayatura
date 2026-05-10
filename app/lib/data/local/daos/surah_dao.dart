part of '../app_database.dart';

@DriftAccessor(tables: [Surahs])
class SurahDao extends DatabaseAccessor<AppDatabase> with _$SurahDaoMixin {
  SurahDao(super.db);

  Future<int> surahRowCount() => surahs.count().getSingle();

  /// Inserts bundled master surahs when the table is empty, then refreshes
  /// `start_juz`, `end_juz`, and `name_id` from [list] for every row (covers app
  /// upgrades that add columns).
  ///
  /// Runs in one transaction; does not touch the pool entries table.
  Future<void> seedMasterSurahsIfEmpty(List<Surah> list) async {
    if (list.isEmpty) return;
    final now = DateTime.now();
    await transaction(() async {
      final n = await surahs.count().getSingle();
      if (n == 0) {
        await batch((b) {
          b.insertAll(surahs, list.map((s) => _toCompanion(s, now)).toList());
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
              updatedAt: Value(DateTime.now()),
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
    return rows.map(_toModel).toList();
  }

  static Surah _toModel(SurahRow r) => Surah(
    id: r.id,
    name: r.name,
    nameId: r.nameId.isEmpty ? r.name : r.nameId,
    arabicName: r.arabicName,
    ayatCount: r.ayatCount,
    startJuz: r.startJuz,
    endJuz: r.endJuz,
  );

  static SurahsCompanion _toCompanion(Surah s, DateTime now) =>
      SurahsCompanion.insert(
        id: Value(s.id),
        name: s.name,
        nameId: Value(s.nameId),
        arabicName: s.arabicName,
        ayatCount: s.ayatCount,
        startJuz: Value(s.startJuz),
        endJuz: Value(s.endJuz),
        createdAt: Value(now),
        updatedAt: Value(now),
      );
}
