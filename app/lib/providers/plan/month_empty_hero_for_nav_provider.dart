import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'month_plan_provider.dart';
import 'month_screen_provider.dart';

/// True when Month tab would show [MonthEmptyHeroLayout] for the viewed month,
/// excluding loading and hard error states without cached data.
final monthEmptyHeroForNavProvider = Provider<bool>((ref) {
  final viewed = ref.watch(viewedMonthProvider);
  final planAsync = ref.watch(
    monthPlanByYearMonthProvider((year: viewed.year, month: viewed.month)),
  );
  final plan = planAsync.when(
    skipLoadingOnReload: true,
    data: (p) => p,
    loading: () => planAsync.value,
    error: (_, _) => planAsync.value,
  );

  if (planAsync.hasError && plan == null) {
    return false;
  }
  if (planAsync.isLoading && plan == null) {
    return false;
  }

  return plan == null;
});
