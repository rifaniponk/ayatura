import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/hifdh_frequency_item.dart';
import '../core/database_provider.dart';
import '../quran/surah_data_providers.dart';

final hifdhFrequencyProvider = FutureProvider<List<HifdhFrequencyItem>>((
  ref,
) async {
  final db = ref.read(appDatabaseProvider);
  final poolEntries = await ref.watch(poolEntriesAsyncProvider.future);
  await ref.watch(surahsAsyncProvider.future);
  final allPlans = await db.loadAllPlans();

  final counts =
      <({int surahId, bool isFullSurah, int? startAyah, int? endAyah}), int>{};
  for (final plan in allPlans) {
    for (final day in plan.days) {
      for (final slot in day.prayers.values) {
        for (final surah in slot.surahs) {
          final key = (
            surahId: surah.surahId,
            isFullSurah: surah.isFullSurah,
            startAyah: surah.startAyah,
            endAyah: surah.endAyah,
          );
          counts[key] = (counts[key] ?? 0) + 1;
        }
      }
    }
  }

  final items = poolEntries.where((entry) => entry.enabled).map((entry) {
    final key = (
      surahId: entry.surahId,
      isFullSurah: entry.isFullSurah,
      startAyah: entry.startAyah,
      endAyah: entry.endAyah,
    );
    return HifdhFrequencyItem(entry: entry, assignmentCount: counts[key] ?? 0);
  }).toList();

  items.sort((a, b) {
    final compareCount = b.assignmentCount.compareTo(a.assignmentCount);
    if (compareCount != 0) return compareCount;
    return a.entry.surahId.compareTo(b.entry.surahId);
  });
  return items;
});
