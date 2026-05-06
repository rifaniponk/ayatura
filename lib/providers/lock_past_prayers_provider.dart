import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_preferences_provider.dart';

const _kLockPastPrayers = 'lockPastPrayers';
const lockPastPrayersDefault = true;

class LockPastPrayersNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getBool(_kLockPastPrayers) ?? lockPastPrayersDefault;
  }

  Future<void> set(bool value) async {
    state = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_kLockPastPrayers, value);
  }
}

final lockPastPrayersProvider = NotifierProvider<LockPastPrayersNotifier, bool>(
  LockPastPrayersNotifier.new,
);
