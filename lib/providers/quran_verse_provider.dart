import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/quran_verse_service.dart';

class QuranVerseRequest {
  const QuranVerseRequest({
    required this.surahId,
    required this.startAyah,
    required this.endAyah,
    required this.translationId,
  });

  final int surahId;
  final int? startAyah;
  final int? endAyah;
  final int translationId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuranVerseRequest &&
          other.surahId == surahId &&
          other.startAyah == startAyah &&
          other.endAyah == endAyah &&
          other.translationId == translationId);

  @override
  int get hashCode => Object.hash(surahId, startAyah, endAyah, translationId);
}

final quranVerseServiceProvider = Provider<QuranVerseService>((ref) {
  ref.keepAlive();
  return QuranVerseService();
});

final quranVersesProvider =
    FutureProvider.family<List<QuranVerse>, QuranVerseRequest>((
      ref,
      req,
    ) async {
      final service = ref.watch(quranVerseServiceProvider);
      return service.fetchVerses(
        surahId: req.surahId,
        startAyah: req.startAyah,
        endAyah: req.endAyah,
        translationId: req.translationId,
      );
    });
