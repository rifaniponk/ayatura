import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../core/theme/app_text_styles.dart';
import '../l10n/app_localizations.dart';
import '../providers/providers.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/gradient_app_bar.dart';

/// Month overview — summary list when a plan exists, otherwise placeholder.
class MonthScreen extends ConsumerWidget {
  const MonthScreen({super.key});

  static String _monthYearLabel(BuildContext context, DateTime now) {
    final locale = Localizations.localeOf(context).languageCode;
    final monthName = DateFormat('MMMM', locale).format(now);
    return '$monthName ${now.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context)!;
    final now = DateTime.now();
    final plan = ref.watch(monthPlanProvider);
    final effective = plan?.effectiveOrNull(now);

    final surahsAsync = ref.watch(surahsAsyncProvider);
    final subtitle = surahsAsync.maybeWhen(
      data: (list) => list.isEmpty
          ? null
          : s.monthSubtitle(_monthYearLabel(context, now), list.length),
      orElse: () => _monthYearLabel(context, now),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GradientAppBar(title: s.monthScreenTitle, subtitle: subtitle),
        Expanded(
          child: effective == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: EmptyState(
                      variant: EmptyStateVariant.noPlan,
                      onAction: () =>
                          ref.read(navIndexProvider.notifier).setIndex(0),
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
                          s.monthDayTitle(d.day),
                          style: AppTextStyles.cardLabel,
                        ),
                        subtitle: Text(
                          s.monthDayReadings(slots),
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
