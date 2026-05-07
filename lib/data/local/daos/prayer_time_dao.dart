part of '../app_database.dart';

@DriftAccessor(tables: [PrayerTimes])
class PrayerTimeDao extends DatabaseAccessor<AppDatabase>
    with _$PrayerTimeDaoMixin {
  PrayerTimeDao(super.db);

  Future<Map<String, PrayerTime>> byDates(Iterable<String> dates) async {
    final keys = dates.toSet().toList(growable: false);
    if (keys.isEmpty) return const {};
    final rows = await (select(
      prayerTimes,
    )..where((t) => t.date.isIn(keys))).get();
    return {for (final row in rows) row.date: row};
  }

  Future<PrayerTime?> byDate(String date) {
    return (select(
      prayerTimes,
    )..where((t) => t.date.equals(date))).getSingleOrNull();
  }

  Future<void> upsert(PrayerTimesCompanion row) {
    final now = DateTime.now();
    return into(prayerTimes).insert(
      row.copyWith(createdAt: Value(now), updatedAt: Value(now)),
      onConflict: DoUpdate(
        (old) => row.copyWith(
          createdAt: const Value.absent(),
          updatedAt: Value(DateTime.now()),
        ),
      ),
    );
  }
}
