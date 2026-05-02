import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/app_database.dart';
import '../data/models/surah.dart';
import '../data/models/surah_pool_entry.dart';
import '../data/services/surah_seed_service.dart';
import 'database_provider.dart';

/// Runs bundled JSON seed once; lazy until first dependency reads this future.
final seededDatabaseProvider = FutureProvider<AppDatabase>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  await SurahSeedService(db).ensureSeeded();
  return db;
});

/// Master surah list — loads only when watched (after [seededDatabaseProvider]).
final surahsAsyncProvider = FutureProvider<List<Surah>>((ref) async {
  final db = await ref.watch(seededDatabaseProvider.future);
  return db.allSurahs();
});

/// Pool rows — same seed prerequisite; independent future so widgets can watch
/// it only when they need pool data (e.g. after surahs are ready).
final poolEntriesAsyncProvider = FutureProvider<List<SurahPoolEntry>>((
  ref,
) async {
  final db = await ref.watch(seededDatabaseProvider.future);
  return db.allPoolEntries();
});
