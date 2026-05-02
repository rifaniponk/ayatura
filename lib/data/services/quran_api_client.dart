import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/surah.dart';

/// Fetches canonical chapter metadata from [Quran.com API v4](https://api.quran.com/api/v4).
class QuranApiClient {
  QuranApiClient({http.Client? httpClient})
    : _http = httpClient ?? http.Client();

  final http.Client _http;

  static final _chaptersUri = Uri.parse(
    'https://api.quran.com/api/v4/chapters?language=en',
  );

  Future<List<Surah>> fetchChapters() async {
    final response = await _http.get(_chaptersUri);
    if (response.statusCode != 200) {
      throw QuranApiException(
        'Chapters request failed with HTTP ${response.statusCode}',
      );
    }
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! Map<String, dynamic>) {
      throw const QuranApiException('Unexpected JSON root');
    }
    final raw = decoded['chapters'];
    if (raw is! List<dynamic>) {
      throw const QuranApiException('Missing chapters array');
    }
    return raw.map((e) => _chapterToSurah(e as Map<String, dynamic>)).toList();
  }

  Surah _chapterToSurah(Map<String, dynamic> json) {
    return Surah(
      id: json['id'] as int,
      name: json['name_simple'] as String,
      arabicName: json['name_arabic'] as String,
      ayatCount: json['verses_count'] as int,
    );
  }

  void close() => _http.close();
}

class QuranApiException implements Exception {
  const QuranApiException(this.message);
  final String message;

  @override
  String toString() => 'QuranApiException: $message';
}
