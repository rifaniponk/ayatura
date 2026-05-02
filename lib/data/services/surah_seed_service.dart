import 'dart:convert';

import '../local/app_database.dart';
import '../models/surah.dart';
import '../surah_fallback_payload.dart';
import 'quran_api_client.dart';

/// Seeds [AppDatabase] on first launch from the Quran.com API, falling back to an in-repo snapshot.
class SurahSeedService {
  SurahSeedService(this._db, {QuranApiClient? apiClient})
    : _api = apiClient ?? QuranApiClient();

  final AppDatabase _db;
  final QuranApiClient _api;

  Future<void> ensureSeeded() async {
    if (await _db.surahRowCount() > 0) return;

    List<Surah> surahs;
    try {
      surahs = await _api.fetchChapters();
      surahs = [...surahs];
    } on Object {
      surahs = _parseSurahsFallbackPayload();
    } finally {
      _api.close();
    }

    await _db.replaceAllSurahs(surahs);
  }

  List<Surah> _parseSurahsFallbackPayload() {
    final map = jsonDecode(kSurahsFallbackPayload) as Map<String, dynamic>;
    final list = map['surahs'] as List<dynamic>;
    return list.map((e) => Surah.fromJson(e as Map<String, dynamic>)).toList();
  }
}
