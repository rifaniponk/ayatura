import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/plan_config.dart';
import '../data/models/plan.dart';
import '../data/models/plan_surah.dart';
import '../data/models/prayer.dart';
import '../data/models/surah.dart';
import '../data/models/surah_pool_entry.dart';
import '../providers/providers.dart';
import '../widgets/empty_state.dart';
import '../widgets/gradient_app_bar.dart';
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

/// Reactive header: subtitle waits on pool only once surahs have loaded.
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

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.surahs, required this.pool});

  final List<Surah> surahs;
  final List<SurahPoolEntry> pool;

  static PrayerSlot _demoSlot(List<SurahPoolEntry> pool) {
    if (pool.isEmpty) return PrayerSlot();
    final mapped = pool
        .take(PlanLimits.maxSurahsPerPrayerSlot)
        .map(PlanSurah.fromSurahPoolEntry)
        .toList();
    return PrayerSlot(surahs: mapped);
  }

  @override
  Widget build(BuildContext context) {
    final masterById = {for (final s in surahs) s.id: s};
    final demoSlot = _demoSlot(pool);

    final sampleDay = DayPlan(
      day: 1,
      prayers: {for (final p in Prayer.values) p: PrayerSlot()},
    );
    final fajrSlot = sampleDay.slotFor(Prayer.fajr);
    final firstPlan = fajrSlot.surahs.firstOrNull;
    final master = firstPlan == null
        ? null
        : surahs.firstWhereOrNull((s) => s.id == firstPlan.surahId);
    final fajrLabel = firstPlan == null
        ? Prayer.fajr.label
        : master != null
        ? firstPlan.displayLabel(master)
        : 'Surah ${firstPlan.surahId}';

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        PrayerCard(
          prayer: Prayer.fajr,
          slot: demoSlot,
          masterBySurahId: masterById,
        ),
        const SizedBox(height: 16),
        Text(
          'Slot demo uses up to ${PlanLimits.maxSurahsPerPrayerSlot} '
          'pool segment(s). Empty slot label check: $fajrLabel',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 24),
        const EmptyState(variant: EmptyStateVariant.noPlan, onAction: null),
      ],
    );
  }
}
