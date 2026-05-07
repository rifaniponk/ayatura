import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/surah.dart';
import '../../data/models/surah_pool_entry.dart';
import '../../data/services/surah_seed_service.dart';
import '../core/database_provider.dart';

/// Ensures bundled JSON seed ran; lazy until first read of this future.
///
/// Does not return [AppDatabase] — callers use [appDatabaseProvider] for the DB.
final seededDatabaseProvider = FutureProvider<void>((ref) async {
  ref.keepAlive();
  final db = ref.read(appDatabaseProvider);
  await SurahSeedService(db).ensureSeeded();
});

/// Master surah list — loads only when watched (after seed completes).
final surahsAsyncProvider = FutureProvider<List<Surah>>((ref) async {
  ref.keepAlive();
  ref.watch(seededDatabaseProvider);
  await ref.read(seededDatabaseProvider.future);
  final db = ref.read(appDatabaseProvider);
  return db.allSurahs();
});

/// Hifdh-list rows — same seed prerequisite; independent future so widgets
/// can watch it only when they need list data (e.g. after surahs are ready).
final poolEntriesAsyncProvider = FutureProvider<List<SurahPoolEntry>>((
  ref,
) async {
  ref.keepAlive();
  ref.watch(seededDatabaseProvider);
  await ref.read(seededDatabaseProvider.future);
  final db = ref.read(appDatabaseProvider);
  return db.allPoolEntries();
});
