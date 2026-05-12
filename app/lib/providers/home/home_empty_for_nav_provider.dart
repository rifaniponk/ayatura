import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/month_plan.dart';
import '../plan/month_plan_provider.dart';

/// True when Home would show [HomeEmptyHeroLayout] (no usable plan for now),
/// excluding loading and hard error states without cached data.
final homeEmptyHeroForNavProvider = Provider<bool>((ref) {
  final planAsync = ref.watch(monthPlanProvider);
  final MonthPlan? plan = planAsync.when(
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

  final effective = plan?.effectiveOrNull(DateTime.now());
  return effective == null;
});
