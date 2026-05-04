import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surah_planner/data/local/app_database.dart';
import 'package:surah_planner/data/models/surah.dart';

Surah _surah(int id) => Surah(
  id: id,
  name: 'Surah $id',
  nameId: 'Surah $id ID',
  arabicName: 'Arabic $id',
  ayatCount: 7,
  startJuz: 1,
  endJuz: 1,
);

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() async => db.close());

  // ── SurahDao ──────────────────────────────────────────────────────────────

  group('SurahDao', () {
    test('surahRowCount returns 0 on empty table', () async {
      expect(await db.surahDao.surahRowCount(), 0);
    });

    test('seedMasterSurahsIfEmpty inserts rows when table is empty', () async {
      await db.surahDao.seedMasterSurahsIfEmpty([_surah(1), _surah(2)]);
      expect(await db.surahDao.surahRowCount(), 2);
    });

    test(
      'seedMasterSurahsIfEmpty does not insert again when rows exist',
      () async {
        await db.surahDao.seedMasterSurahsIfEmpty([_surah(1)]);
        await db.surahDao.seedMasterSurahsIfEmpty([_surah(1), _surah(2)]);
        expect(await db.surahDao.surahRowCount(), 1);
      },
    );

    test(
      'seedMasterSurahsIfEmpty updates nameId and juz on existing rows',
      () async {
        await db.surahDao.seedMasterSurahsIfEmpty([
          Surah(
            id: 1,
            name: 'Old',
            nameId: '',
            arabicName: '',
            ayatCount: 7,
            startJuz: 1,
            endJuz: 1,
          ),
        ]);
        final updated = Surah(
          id: 1,
          name: 'Old',
          nameId: 'New ID',
          arabicName: '',
          ayatCount: 7,
          startJuz: 2,
          endJuz: 3,
        );
        await db.surahDao.seedMasterSurahsIfEmpty([updated]);
        final rows = await db.surahDao.allSurahs();
        expect(rows.first.nameId, 'New ID');
        expect(rows.first.startJuz, 2);
        expect(rows.first.endJuz, 3);
      },
    );

    test('allSurahs returns rows ordered by id', () async {
      await db.surahDao.seedMasterSurahsIfEmpty([
        _surah(3),
        _surah(1),
        _surah(2),
      ]);
      final ids = (await db.surahDao.allSurahs()).map((s) => s.id).toList();
      expect(ids, [1, 2, 3]);
    });

    test('_toModel falls back to name when nameId is empty', () async {
      await db
          .into(db.surahs)
          .insert(
            SurahsCompanion.insert(
              id: const Value(10),
              name: 'Al-Fatiha',
              arabicName: 'الفاتحة',
              ayatCount: 7,
            ),
          );
      final rows = await db.surahDao.allSurahs();
      expect(rows.first.nameId, 'Al-Fatiha');
    });
  });

  // ── PoolEntryDao ──────────────────────────────────────────────────────────

  group('PoolEntryDao', () {
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

    test('allPoolEntries returns empty list initially', () async {
      expect(await db.poolEntryDao.allPoolEntries(), isEmpty);
    });

    test('insertPoolEntry and allPoolEntries round-trip', () async {
      await seedSurah(1);
      await db.poolEntryDao.insertPoolEntry(
        SurahPoolEntriesCompanion.insert(surahId: 1, isFullSurah: true),
      );
      final entries = await db.poolEntryDao.allPoolEntries();
      expect(entries, hasLength(1));
      expect(entries.first.surahId, 1);
      expect(entries.first.isFullSurah, isTrue);
      expect(entries.first.enabled, isTrue);
    });

    test('enabledPoolEntries filters out disabled entries', () async {
      await seedSurah(1);
      await seedSurah(2);
      await db.poolEntryDao.insertPoolEntry(
        SurahPoolEntriesCompanion.insert(
          surahId: 1,
          isFullSurah: true,
          enabled: const Value(true),
        ),
      );
      await db.poolEntryDao.insertPoolEntry(
        SurahPoolEntriesCompanion.insert(
          surahId: 2,
          isFullSurah: true,
          enabled: const Value(false),
        ),
      );
      final enabled = await db.poolEntryDao.enabledPoolEntries();
      expect(enabled, hasLength(1));
      expect(enabled.first.surahId, 1);
    });

    test('setPoolEntryEnabled toggles enabled state', () async {
      await seedSurah(1);
      final id = await db.poolEntryDao.insertPoolEntry(
        SurahPoolEntriesCompanion.insert(
          surahId: 1,
          isFullSurah: true,
          enabled: const Value(true),
        ),
      );
      await db.poolEntryDao.setPoolEntryEnabled(id, false);
      final entries = await db.poolEntryDao.allPoolEntries();
      expect(entries.first.enabled, isFalse);
    });

    test('deletePoolEntry removes the row', () async {
      await seedSurah(1);
      final id = await db.poolEntryDao.insertPoolEntry(
        SurahPoolEntriesCompanion.insert(surahId: 1, isFullSurah: true),
      );
      await db.poolEntryDao.deletePoolEntry(id);
      expect(await db.poolEntryDao.allPoolEntries(), isEmpty);
    });

    test('updatePoolEntry persists changes', () async {
      await seedSurah(1);
      final id = await db.poolEntryDao.insertPoolEntry(
        SurahPoolEntriesCompanion.insert(
          surahId: 1,
          isFullSurah: false,
          startAyah: const Value(1),
          endAyah: const Value(5),
        ),
      );
      final rows = await (db.select(
        db.surahPoolEntries,
      )..where((t) => t.id.equals(id))).get();
      await db.poolEntryDao.updatePoolEntry(
        rows.first.copyWith(startAyah: const Value(3), endAyah: const Value(7)),
      );
      final updated = await db.poolEntryDao.allPoolEntries();
      expect(updated.first.startAyah, 3);
      expect(updated.first.endAyah, 7);
    });
  });
}
