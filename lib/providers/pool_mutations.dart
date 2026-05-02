import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/surah_pool_entry.dart';
import 'database_provider.dart';
import 'surah_data_providers.dart';

/// Persists pool segment enabled flag and refreshes [poolEntriesAsyncProvider].
Future<void> setPoolEntryEnabled(
  WidgetRef ref,
  SurahPoolEntry entry,
  bool enabled,
) async {
  final db = ref.read(appDatabaseProvider);
  await db.setPoolEntryEnabled(entry.id, enabled);
  ref.invalidate(poolEntriesAsyncProvider);
}
