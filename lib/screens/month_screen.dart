import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../widgets/empty_state.dart';
import '../widgets/gradient_app_bar.dart';

/// Month overview placeholder until persisted [MonthPlan] exists.
class MonthScreen extends ConsumerWidget {
  const MonthScreen({super.key});

  static String _monthYearLabel() {
    final now = DateTime.now();
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
    final surahsAsync = ref.watch(surahsAsyncProvider);
    final subtitle = surahsAsync.maybeWhen(
      data: (s) =>
          s.isEmpty ? null : '${_monthYearLabel()} · ${s.length} chapters',
      orElse: () => _monthYearLabel(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GradientAppBar(title: 'Month', subtitle: subtitle),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: EmptyState(
                variant: EmptyStateVariant.noPlan,
                onAction: () => ref.read(navIndexProvider.notifier).state = 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
