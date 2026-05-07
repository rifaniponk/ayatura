import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surah_planner/providers/core/settings_provider.dart';
import 'package:surah_planner/providers/core/shared_preferences_provider.dart';

Future<ProviderContainer> makeContainer({
  Map<String, Object> prefs = const {},
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final instance = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(instance)],
  );
  return container;
}

void main() {
  group('SurahsPerPrayerNotifier', () {
    test('returns default when key is absent', () async {
      final container = await makeContainer();
      addTearDown(container.dispose);
      expect(container.read(surahsPerPrayerProvider), surahsPerPrayerDefault);
    });

    test('returns stored value when key is present', () async {
      final container = await makeContainer(prefs: {'surahsPerPrayer': 4});
      addTearDown(container.dispose);
      expect(container.read(surahsPerPrayerProvider), 4);
    });

    test('clamps stored value below min on read', () async {
      final container = await makeContainer(prefs: {'surahsPerPrayer': 0});
      addTearDown(container.dispose);
      expect(container.read(surahsPerPrayerProvider), surahsPerPrayerMin);
    });

    test('clamps stored value above max on read', () async {
      final container = await makeContainer(prefs: {'surahsPerPrayer': 99});
      addTearDown(container.dispose);
      expect(container.read(surahsPerPrayerProvider), surahsPerPrayerMax);
    });

    test('set() updates state and persists value', () async {
      final container = await makeContainer();
      addTearDown(container.dispose);
      await container.read(surahsPerPrayerProvider.notifier).set(3);
      expect(container.read(surahsPerPrayerProvider), 3);
      final prefs = container.read(sharedPreferencesProvider);
      expect(prefs.getInt('surahsPerPrayer'), 3);
    });

    test('set() clamps value below min', () async {
      final container = await makeContainer();
      addTearDown(container.dispose);
      await container.read(surahsPerPrayerProvider.notifier).set(0);
      expect(container.read(surahsPerPrayerProvider), surahsPerPrayerMin);
    });

    test('set() clamps value above max', () async {
      final container = await makeContainer();
      addTearDown(container.dispose);
      await container.read(surahsPerPrayerProvider.notifier).set(100);
      expect(container.read(surahsPerPrayerProvider), surahsPerPrayerMax);
    });
  });
}
