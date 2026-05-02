import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/app_database.dart';
import '../data/models/surah_pool_entry.dart';
import 'database_provider.dart';
import 'month_plan_provider.dart';
import 'surah_data_providers.dart';

void _invalidatePoolAndPlan(WidgetRef ref) {
  ref.invalidate(poolEntriesAsyncProvider);
  ref.invalidate(monthPlanProvider);
}

/// Persists pool segment enabled flag and refreshes pool data.
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
}

Future<void> insertPoolSegment({
  required WidgetRef ref,
  required int surahId,
  required bool isFullSurah,
  int? startAyah,
  int? endAyah,
  bool enabled = true,
}) async {
  final db = ref.read(appDatabaseProvider);
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
}

Future<void> deletePoolSegment(WidgetRef ref, int entryId) async {
  final db = ref.read(appDatabaseProvider);
  await db.deletePoolEntry(entryId);
  _invalidatePoolAndPlan(ref);
}
