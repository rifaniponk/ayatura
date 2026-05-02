import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_text_styles.dart';
import '../data/models/plan.dart';
import '../data/models/prayer.dart';
import '../data/models/surah.dart';
import '../data/models/surah_pool_entry.dart';
import '../providers/providers.dart';
import '../widgets/empty_state.dart';
import '../widgets/gradient_app_bar.dart';
import '../widgets/gradient_button.dart';
import '../widgets/prayer_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahsAsyncProvider);
    final poolAsync = ref.watch(poolEntriesAsyncProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _HomeGradientAppBar(),
        Expanded(
          child: switch ((surahsAsync, poolAsync)) {
            (AsyncError(:final error), _) || (_, AsyncError(:final error)) =>
              Center(child: Text('Error: $error')),
            (AsyncData(value: final surahs), AsyncData(value: final pool)) =>
              surahs.isEmpty
                  ? const Center(child: Text('No surahs loaded'))
                  : _HomeBody(surahs: surahs, pool: pool),
            _ => const Center(child: CircularProgressIndicator()),
          },
        ),
      ],
    );
  }
}

class _HomeGradientAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  const _HomeGradientAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahsAsyncProvider);
    final subtitle = surahsAsync.maybeWhen(
      data: (surahs) {
        if (surahs.isEmpty) return 'No surahs loaded';
        final poolAsync = ref.watch(poolEntriesAsyncProvider);
        return poolAsync.maybeWhen(
          data: (pool) =>
              '${surahs.length} chapters · ${pool.length} pool segment(s)',
          orElse: () => '${surahs.length} chapters · …',
        );
      },
      orElse: () => null,
    );

    return GradientAppBar(
      title: 'Surah Planner',
      subtitle: subtitle,
      showLogo: true,
    );
  }
}

class _HomeBody extends ConsumerWidget {
  const _HomeBody({required this.surahs, required this.pool});

  final List<Surah> surahs;
  final List<SurahPoolEntry> pool;

  static MonthPlan? _effectivePlan(MonthPlan? plan, DateTime now) {
    if (plan == null) return null;
    if (plan.isStaleAt(now)) return null;
    return plan;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final plan = ref.watch(monthPlanProvider);
    final effective = _effectivePlan(plan, now);
    final selectedDay = ref.watch(selectedPlanDayProvider);
    final enabledSegments = pool.where((e) => e.enabled).toList();
    final enabledCount = enabledSegments.length;
    final masterById = {for (final s in surahs) s.id: s};

    final daysInMonth = effective != null
        ? DateTime(effective.year, effective.month + 1, 0).day
        : DateTime(now.year, now.month + 1, 0).day;

    Future<void> onGenerate() async {
      final ok = await ref.read(monthPlanProvider.notifier).regenerate();
      if (!context.mounted) return;
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Need at least two enabled segments in the pool.'),
          ),
        );
      }
    }

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        if (effective != null) ...[
          _DaySelectorRow(
            selectedDay: selectedDay.clamp(1, daysInMonth),
            daysInMonth: daysInMonth,
            onChanged: (d) =>
                ref.read(selectedPlanDayProvider.notifier).state = d,
          ),
          const SizedBox(height: 16),
          ...Prayer.values.map(
            (prayer) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PrayerCard(
                prayer: prayer,
                slot: effective
                    .planForDay(selectedDay.clamp(1, daysInMonth))!
                    .slotFor(prayer),
                masterBySurahId: masterById,
              ),
            ),
          ),
          const SizedBox(height: 8),
          GradientButton(
            label: 'Regenerate Plan',
            icon: Icons.auto_awesome_rounded,
            onPressed: enabledCount >= 2 ? onGenerate : null,
            enabled: enabledCount >= 2,
          ),
        ] else ...[
          if (enabledCount < 2)
            EmptyState(
              variant: EmptyStateVariant.poolTooSmall,
              onAction: () => ref.read(navIndexProvider.notifier).state = 2,
            )
          else
            EmptyState(variant: EmptyStateVariant.noPlan, onAction: onGenerate),
        ],
      ],
    );
  }
}

class _DaySelectorRow extends StatelessWidget {
  const _DaySelectorRow({
    required this.selectedDay,
    required this.daysInMonth,
    required this.onChanged,
  });

  final int selectedDay;
  final int daysInMonth;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Day', style: AppTextStyles.sectionHeadingSerif),
        const SizedBox(width: 12),
        IconButton.filledTonal(
          onPressed: selectedDay > 1 ? () => onChanged(selectedDay - 1) : null,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: Text(
            '$selectedDay / $daysInMonth',
            textAlign: TextAlign.center,
            style: AppTextStyles.cardLabel,
          ),
        ),
        IconButton.filledTonal(
          onPressed: selectedDay < daysInMonth
              ? () => onChanged(selectedDay + 1)
              : null,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}
