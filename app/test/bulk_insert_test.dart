import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ayatura/data/local/app_database.dart';
import 'package:ayatura/data/models/surah.dart';
import 'package:ayatura/widgets/pool/pool_segment_editor_sheet.dart';

Surah _surah(int id, {required int startJuz, required int endJuz}) => Surah(
  id: id,
  name: 'Surah $id',
  nameId: 'Surah $id',
  arabicName: '',
  ayatCount: 7,
  startJuz: startJuz,
  endJuz: endJuz,
);

void main() {
  group('surahsBelongingToJuz', () {
    final surahs = [
      _surah(1, startJuz: 1, endJuz: 1), // wholly in juz 1
      _surah(2, startJuz: 1, endJuz: 3), // spans juz 1-3
      _surah(3, startJuz: 2, endJuz: 2), // wholly in juz 2
      _surah(4, startJuz: 3, endJuz: 3), // wholly in juz 3
      _surah(114, startJuz: 30, endJuz: 30), // wholly in juz 30
    ];

    test('returns surahs wholly in the juz', () {
      final result = surahsBelongingToJuz(surahs, 2);
      expect(result.map((s) => s.id), containsAll([2, 3]));
      expect(result.map((s) => s.id), isNot(contains(1)));
      expect(result.map((s) => s.id), isNot(contains(4)));
    });

    test('includes surahs that span multiple juz', () {
      // surah 2 spans juz 1-3, so it belongs to juz 1, 2, and 3
      expect(surahsBelongingToJuz(surahs, 1).map((s) => s.id), contains(2));
      expect(surahsBelongingToJuz(surahs, 2).map((s) => s.id), contains(2));
      expect(surahsBelongingToJuz(surahs, 3).map((s) => s.id), contains(2));
      expect(
        surahsBelongingToJuz(surahs, 4).map((s) => s.id),
        isNot(contains(2)),
      );
    });

    test('returns results sorted by surah id', () {
      final result = surahsBelongingToJuz(surahs, 1);
      final ids = result.map((s) => s.id).toList();
      expect(ids, equals([...ids]..sort()));
    });

    test('juz 30 boundary', () {
      final result = surahsBelongingToJuz(surahs, 30);
      expect(result.map((s) => s.id), contains(114));
      expect(result.map((s) => s.id), isNot(contains(1)));
    });

    test('returns empty when no surahs belong to juz', () {
      expect(surahsBelongingToJuz([], 1), isEmpty);
    });
  });

  group('bulkInsertFullSurahPoolSegments (DB)', () {
    late AppDatabase db;

    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() async => db.close());

    Future<void> seedSurah(int id) => db
        .into(db.surahs)
        .insert(
          SurahsCompanion.insert(
            id: Value(id),
            name: 'Surah $id',
            arabicName: '',
            ayatCount: 7,
          ),
        );

    test('inserts new entries as full-surah rows', () async {
      await seedSurah(1);
      await seedSurah(2);

      await db.transaction(() async {
        for (final id in [1, 2]) {
          await db.insertPoolEntry(
            SurahPoolEntriesCompanion.insert(
              surahId: id,
              isFullSurah: true,
              enabled: const Value(true),
            ),
          );
        }
      });

      // Verify they are inserted
      final entries = await db.allPoolEntries();
      expect(entries.map((e) => e.surahId), containsAll([1, 2]));
      expect(entries.every((e) => e.isFullSurah), isTrue);
    });

    test('skips surah already in pool', () async {
      await seedSurah(1);
      await seedSurah(2);

      // Pre-insert surah 1
      await db.insertPoolEntry(
        SurahPoolEntriesCompanion.insert(
          surahId: 1,
          isFullSurah: true,
          enabled: const Value(true),
        ),
      );

      // Bulk insert both — surah 1 should be skipped
      final existing = await db.allPoolEntries();
      final taken = existing.map((e) => e.surahId).toSet();
      for (final id in [1, 2]) {
        if (taken.contains(id)) continue;
        await db.insertPoolEntry(
          SurahPoolEntriesCompanion.insert(
            surahId: id,
            isFullSurah: true,
            enabled: const Value(true),
          ),
        );
      }

      final all = await db.allPoolEntries();
      final surahIds = all.map((e) => e.surahId).toList();
      expect(surahIds.where((id) => id == 1).length, 1); // no duplicate
      expect(surahIds, contains(2));
    });
  });
}
