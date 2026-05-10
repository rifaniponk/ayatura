import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/quran_verse.dart';

class QuranVerseService {
  QuranVerseService({http.Client? client}) : _client = client ?? http.Client();

  static const _baseHost = 'api.quran.com';
  static const _basePath = '/api/v4';
  static const _perPage = 50;

  final http.Client _client;
  final Map<String, List<QuranVerse>> _cache = {};

  Future<List<QuranVerse>> fetchVerses({
    required int surahId,
    int? startAyah,
    int? endAyah,
    required int translationId,
  }) async {
    final key = '$surahId:${startAyah ?? ''}:${endAyah ?? ''}:$translationId';
    final cached = _cache[key];
    if (cached != null) return cached;

    final verses = <QuranVerse>[];
    var currentPage = 1;
    var totalPages = 1;
    final hasExplicitRange = startAyah != null && endAyah != null;

    while (currentPage <= totalPages) {
      final query = <String, String>{
        'fields': 'text_uthmani',
        'translations': '$translationId',
        'per_page': '$_perPage',
        'page': '$currentPage',
      };
      // Quran.com v4 expects `from` / `to` on this endpoint.
      if (startAyah != null) query['from'] = '$startAyah';
      if (endAyah != null) query['to'] = '$endAyah';

      final uri = Uri.https(
        _baseHost,
        '$_basePath/verses/by_chapter/$surahId',
        query,
      );
      final response = await _client.get(uri);
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load verses ($surahId): HTTP ${response.statusCode}',
        );
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final pageVerses = (body['verses'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>();

      verses.addAll(
        pageVerses.map((v) {
          final translations =
              (v['translations'] as List<dynamic>? ?? const []);
          final firstTranslation = translations.isEmpty
              ? null
              : translations.first as Map<String, dynamic>;

          return QuranVerse(
            verseNumber: v['verse_number'] as int? ?? 0,
            arabicText: (v['text_uthmani'] as String? ?? '').trim(),
            translation: _stripHtml(firstTranslation?['text'] as String? ?? ''),
          );
        }),
      );

      if (hasExplicitRange) {
        // `from`/`to` can still return chapter-level pagination metadata;
        // keep range requests single-page and trust returned verses.
        totalPages = 1;
      } else {
        final pagination =
            body['pagination'] as Map<String, dynamic>? ?? const {};
        totalPages = pagination['total_pages'] as int? ?? 1;
      }
      currentPage += 1;
    }

    _cache[key] = verses;
    return verses;
  }

  static String _stripHtml(String input) {
    return input.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }
}
