import 'package:flutter_riverpod/flutter_riverpod.dart';

/// True while month-plan regenerate is running.
class MonthPlanRegenerateBusy extends Notifier<bool> {
  @override
  bool build() => false;
}

final monthPlanRegenerateBusyProvider =
    NotifierProvider<MonthPlanRegenerateBusy, bool>(
      MonthPlanRegenerateBusy.new,
    );
