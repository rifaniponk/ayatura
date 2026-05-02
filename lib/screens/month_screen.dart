import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_text_styles.dart';
import '../providers/providers.dart';
import '../widgets/empty_state.dart';
import '../widgets/gradient_app_bar.dart';

/// Month overview — summary list when a plan exists, otherwise placeholder.
class MonthScreen extends ConsumerWidget {
  const MonthScreen({super.key});

  static String _monthYearLabel(DateTime now) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final plan = ref.watch(monthPlanProvider);
    final effective = plan?.effectiveOrNull(now);

    final surahsAsync = ref.watch(surahsAsyncProvider);
    final subtitle = surahsAsync.maybeWhen(
      data: (s) =>
          s.isEmpty ? null : '${_monthYearLabel(now)} · ${s.length} chapters',
      orElse: () => _monthYearLabel(now),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GradientAppBar(title: 'Month', subtitle: subtitle),
        Expanded(
          child: effective == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: EmptyState(
                      variant: EmptyStateVariant.noPlan,
                      onAction: () =>
                          ref.read(navIndexProvider.notifier).state = 0,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                  itemCount: effective.days.length,
                  itemBuilder: (context, i) {
                    final d = effective.days[i];
                    final slots = d.prayers.values.fold<int>(
                      0,
                      (sum, slot) => sum + slot.surahs.length,
                    );
                    return Card(
                      child: ListTile(
                        title: Text(
                          'Day ${d.day}',
                          style: AppTextStyles.cardLabel,
                        ),
                        subtitle: Text(
                          '$slots planned reading(s) across prayers',
                          style: AppTextStyles.meta,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
