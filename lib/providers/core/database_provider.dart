import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/app_database.dart';

/// Opens the DB on first read; closes when the root [ProviderScope] is disposed.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  ref.keepAlive();
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
