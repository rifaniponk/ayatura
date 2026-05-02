import 'package:flutter_test/flutter_test.dart';
import 'package:surah_planner/data/models/surah.dart';
import 'package:surah_planner/data/pool_segment_validation.dart';

void main() {
  const alFatiha = Surah(
    id: 1,
    name: 'Al-Fatihah',
    arabicName: 'الفاتحة',
    ayatCount: 7,
  );

  group('PoolSegmentValidation', () {
    test('full surah needs no ayat range', () {
      expect(
        PoolSegmentValidation.validate(surah: alFatiha, isFullSurah: true),
        isNull,
      );
    });

    test('partial requires both ayat', () {
      expect(
        PoolSegmentValidation.validate(
          surah: alFatiha,
          isFullSurah: false,
          startAyah: 1,
        ),
        isNotNull,
      );
    });

    test('partial ayat must be within surah', () {
      expect(
        PoolSegmentValidation.validate(
          surah: alFatiha,
          isFullSurah: false,
          startAyah: 0,
          endAyah: 1,
        ),
        isNotNull,
      );
      expect(
        PoolSegmentValidation.validate(
          surah: alFatiha,
          isFullSurah: false,
          startAyah: 1,
          endAyah: 8,
        ),
        isNotNull,
      );
    });

    test('start cannot exceed end', () {
      expect(
        PoolSegmentValidation.validate(
          surah: alFatiha,
          isFullSurah: false,
          startAyah: 5,
          endAyah: 3,
        ),
        isNotNull,
      );
    });

    test('valid partial span returns null', () {
      expect(
        PoolSegmentValidation.validate(
          surah: alFatiha,
          isFullSurah: false,
          startAyah: 2,
          endAyah: 5,
        ),
        isNull,
      );
    });
  });
}
