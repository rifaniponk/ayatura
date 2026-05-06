import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Current calendar day highlighted on Home (1–31).
class SelectedPlanDayNotifier extends Notifier<int> {
  @override
  int build() => DateTime.now().day;

  void setDay(int value) => state = value;
}

final selectedPlanDayProvider = NotifierProvider<SelectedPlanDayNotifier, int>(
  SelectedPlanDayNotifier.new,
);
