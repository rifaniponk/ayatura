import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../quran/surah_data_providers.dart';

/// True when the Hifdh tab would show [HifdhEmptyHeroLayout] (pool loaded and
/// empty, surahs available), excluding loading and error without cached data.
final poolEmptyHeroForNavProvider = Provider<bool>((ref) {
  final poolAsync = ref.watch(poolEntriesAsyncProvider);
  final surahsAsync = ref.watch(surahsAsyncProvider);
  final pool = poolAsync.maybeWhen(data: (p) => p, orElse: () => null);
  final surahs = surahsAsync.maybeWhen(data: (s) => s, orElse: () => null);

  if (poolAsync.hasError && pool == null) {
    return false;
  }
  if (surahsAsync.hasError && surahs == null) {
    return false;
  }
  if (poolAsync.isLoading && pool == null) {
    return false;
  }
  if (surahsAsync.isLoading && surahs == null) {
    return false;
  }
  if (pool == null || surahs == null) {
    return false;
  }
  if (surahs.isEmpty) {
    return false;
  }
  return pool.isEmpty;
});
