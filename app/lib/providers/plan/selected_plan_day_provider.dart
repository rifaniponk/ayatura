import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_clock.dart';

/// Current calendar day highlighted on Home (1–31).
class SelectedPlanDayNotifier extends Notifier<int> {
  @override
  int build() => appClockNow().day;

  void setDay(int value) => state = value;

  void resetToToday() => state = appClockNow().day;
}

final selectedPlanDayProvider = NotifierProvider<SelectedPlanDayNotifier, int>(
  SelectedPlanDayNotifier.new,
);
