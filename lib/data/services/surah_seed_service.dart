import 'dart:convert';

import 'package:flutter/services.dart';

import '../local/app_database.dart';
import '../models/surah.dart';

/// Seeds [AppDatabase] on first launch from bundled [surahs.json].
class SurahSeedService {
  SurahSeedService(this._db);

  final AppDatabase _db;

  static const _assetPath = 'assets/data/surahs.json';

  Future<void> ensureSeeded() async {
    final raw = await rootBundle.loadString(_assetPath);
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final list = map['surahs'] as List<dynamic>;
    final surahs = list
        .map((e) => Surah.fromJson(e as Map<String, dynamic>))
        .toList();

    await _db.seedMasterSurahsIfEmpty(surahs);
  }
}
