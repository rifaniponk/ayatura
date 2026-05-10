import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/prayer_times_sync_service.dart';
import '../core/database_provider.dart';
import '../quran/surah_data_providers.dart';

final prayerTimesSyncProvider = FutureProvider<PrayerTimesSyncResult?>((
  ref,
) async {
  ref.keepAlive();
  ref.watch(seededDatabaseProvider);
  await ref.read(seededDatabaseProvider.future);
  final db = ref.read(appDatabaseProvider);
  return PrayerTimesSyncService(db).syncAndLoadToday();
});
