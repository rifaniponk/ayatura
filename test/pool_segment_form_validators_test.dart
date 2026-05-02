import 'package:flutter_test/flutter_test.dart';
import 'package:surah_planner/data/models/surah.dart';
import 'package:surah_planner/validators/pool_segment_form_validators.dart';

void main() {
  const alFatiha = Surah(
    id: 1,
    name: 'Al-Fatihah',
    arabicName: 'الفاتحة',
    ayatCount: 7,
  );

  group('PoolSegmentFormValidators', () {
    test('startAyah accepts valid ayah in range', () {
      final v = PoolSegmentFormValidators.startAyah(alFatiha);
      expect(v('3'), isNull);
    });

    test('startAyah rejects out of range', () {
      final v = PoolSegmentFormValidators.startAyah(alFatiha);
      expect(v('0'), isNotNull);
      expect(v('8'), isNotNull);
    });

    test('endAyah rejects when start is greater than end', () {
      final v = PoolSegmentFormValidators.endAyah(alFatiha, () => '5');
      expect(v('3'), isNotNull);
    });

    test('endAyah accepts when start <= end within range', () {
      final v = PoolSegmentFormValidators.endAyah(alFatiha, () => '2');
      expect(v('5'), isNull);
    });
  });
}
