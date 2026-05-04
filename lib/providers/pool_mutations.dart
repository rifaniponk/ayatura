import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/app_database.dart';
import '../data/models/surah_pool_entry.dart';
import 'database_provider.dart';
import 'month_plan_provider.dart';
import 'surah_data_providers.dart';
import 'widget_sync_provider.dart';

void _invalidatePoolAndPlan(WidgetRef ref) {
  ref.invalidate(poolEntriesAsyncProvider);
  ref.invalidate(monthPlanProvider);
}

/// Returns the existing pool entry that exactly matches the given criteria, or null.
///
/// Two entries are duplicates when they share the same [surahId], [isFullSurah]
/// flag, and (for partial rows) the same [startAyah] and [endAyah].
SurahPoolEntry? findDuplicate(
  List<SurahPoolEntry> existing, {
  required int surahId,
  required bool isFullSurah,
  int? startAyah,
  int? endAyah,
}) {
  for (final e in existing) {
    if (e.surahId != surahId) continue;
    if (e.isFullSurah != isFullSurah) continue;
    if (!isFullSurah && (e.startAyah != startAyah || e.endAyah != endAyah)) {
      continue;
    }
    return e;
  }
  return null;
}

/// Persists whether a hifdh-list row is included and refreshes list data.
///
/// Does not clear [monthPlanProvider] — toggling inclusion alone keeps an
/// existing plan readable until the user regenerates.
Future<void> setPoolEntryEnabled(
  WidgetRef ref,
  SurahPoolEntry entry,
  bool enabled,
) async {
  final db = ref.read(appDatabaseProvider);
  await db.setPoolEntryEnabled(entry.id, enabled);
  ref.invalidate(poolEntriesAsyncProvider);
  await syncHomeWidget(ref);
}

/// Inserts a single pool entry. Returns `true` on success, `false` if an
/// exact duplicate already exists (same surah, same isFullSurah, same range).
Future<bool> insertPoolSegment({
  required WidgetRef ref,
  required int surahId,
  required bool isFullSurah,
  int? startAyah,
  int? endAyah,
  bool enabled = true,
}) async {
  assert(
    isFullSurah || (startAyah != null && endAyah != null),
    'startAyah and endAyah are required for partial (ayat range) rows',
  );
  final db = ref.read(appDatabaseProvider);
  final existing = await db.allPoolEntries();
  if (findDuplicate(
        existing,
        surahId: surahId,
        isFullSurah: isFullSurah,
        startAyah: startAyah,
        endAyah: endAyah,
      ) !=
      null) {
    return false;
  }
  await db.insertPoolEntry(
    SurahPoolEntriesCompanion.insert(
      surahId: surahId,
      isFullSurah: isFullSurah,
      startAyah: isFullSurah ? const Value.absent() : Value(startAyah),
      endAyah: isFullSurah ? const Value.absent() : Value(endAyah),
      enabled: Value(enabled),
    ),
  );
  _invalidatePoolAndPlan(ref);
  await syncHomeWidget(ref);
  return true;
}

Future<void> replacePoolSegment({
  required WidgetRef ref,
  required SurahPoolEntry entry,
}) async {
  final db = ref.read(appDatabaseProvider);
  await db.updatePoolEntry(
    SurahPoolEntryRow(
      id: entry.id,
      surahId: entry.surahId,
      isFullSurah: entry.isFullSurah,
      startAyah: entry.startAyah,
      endAyah: entry.endAyah,
      enabled: entry.enabled,
    ),
  );
  _invalidatePoolAndPlan(ref);
  await syncHomeWidget(ref);
}

Future<void> deletePoolSegment(WidgetRef ref, int entryId) async {
  final db = ref.read(appDatabaseProvider);
  await db.deletePoolEntry(entryId);
  _invalidatePoolAndPlan(ref);
  await syncHomeWidget(ref);
}

/// Inserts many full-surah hifdh rows in one transaction.
///
/// Skips surah IDs that already have any pool row (full or partial) — these
/// are shown as "already added" in the bulk UI and should never appear in the
/// [surahIds] list. Returns the IDs of any entries that were skipped anyway
/// (e.g. due to a race condition between UI load and submit).
Future<List<int>> bulkInsertFullSurahPoolSegments({
  required WidgetRef ref,
  required Iterable<int> surahIds,
}) async {
  final uniqueIds = surahIds.toSet().toList();
  if (uniqueIds.isEmpty) return [];

  final db = ref.read(appDatabaseProvider);
  final existing = await db.allPoolEntries();
  final taken = existing.map((e) => e.surahId).toSet();

  final skipped = <int>[];
  var insertedAny = false;
  await db.transaction(() async {
    for (final sid in uniqueIds) {
      if (taken.contains(sid)) {
        skipped.add(sid);
        continue;
      }
      await db.insertPoolEntry(
        SurahPoolEntriesCompanion.insert(
          surahId: sid,
          isFullSurah: true,
          enabled: Value(true),
        ),
      );
      taken.add(sid);
      insertedAny = true;
    }
  });

  if (insertedAny) {
    _invalidatePoolAndPlan(ref);
    await syncHomeWidget(ref);
  }
  return skipped;
}
