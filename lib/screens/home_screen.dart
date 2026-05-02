import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/plan_config.dart';
import '../data/models/plan.dart';
import '../data/models/plan_surah.dart';
import '../data/models/prayer.dart';
import '../data/models/surah.dart';
import '../data/models/surah_pool_entry.dart';
import '../providers/providers.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/empty_state.dart';
import '../widgets/gradient_app_bar.dart';
import '../widgets/prayer_card.dart';

PrayerSlot _demoSlot(List<SurahPoolEntry> pool) {
  if (pool.isEmpty) return PrayerSlot();
  final mapped = pool
      .take(PlanLimits.maxSurahsPerPrayerSlot)
      .map(PlanSurah.fromSurahPoolEntry)
      .toList();
  return PrayerSlot(surahs: mapped);
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahsAsyncProvider);
    final navIndex = ref.watch(navIndexProvider);

    return surahsAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (surahs) {
        if (surahs.isEmpty) {
          return const Scaffold(body: Center(child: Text('No surahs loaded')));
        }

        // Pool provider is watched only after surahs resolve — lazy second hop.
        return Consumer(
          builder: (context, ref, _) {
            final poolAsync = ref.watch(poolEntriesAsyncProvider);
            final subtitle = poolAsync.maybeWhen(
              data: (pool) =>
                  '${surahs.length} chapters · ${pool.length} pool segment(s)',
              orElse: () => '${surahs.length} chapters · …',
            );

            return Scaffold(
              appBar: GradientAppBar(
                title: 'Surah Planner',
                subtitle: subtitle,
                showLogo: true,
              ),
              body: poolAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (pool) => _HomeBody(surahs: surahs, pool: pool),
              ),
              bottomNavigationBar: AppBottomNavBar(
                currentIndex: navIndex,
                onTap: (i) => ref.read(navIndexProvider.notifier).state = i,
              ),
            );
          },
        );
      },
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.surahs, required this.pool});

  final List<Surah> surahs;
  final List<SurahPoolEntry> pool;

  @override
  Widget build(BuildContext context) {
    final masterById = {for (final s in surahs) s.id: s};
    final demoSlot = _demoSlot(pool);

    final sampleDay = DayPlan(
      day: 1,
      prayers: {for (final p in Prayer.values) p: PrayerSlot()},
    );
    final fajrSlot = sampleDay.slotFor(Prayer.fajr);
    final fajrLabel = fajrSlot.surahs.isEmpty
        ? Prayer.fajr.label
        : fajrSlot.surahs.first.displayLabel(
            surahs.firstWhere((s) => s.id == fajrSlot.surahs.first.surahId),
          );

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
