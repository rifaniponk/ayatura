import 'package:flutter/material.dart';

import 'core/plan_config.dart';
import 'core/theme/app_theme.dart';
import 'data/local/app_database.dart';
import 'data/models/plan.dart';
import 'data/models/plan_surah.dart';
import 'data/models/prayer.dart';
import 'data/models/surah.dart';
import 'data/models/surah_pool_entry.dart';
import 'data/services/surah_seed_service.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/empty_state.dart';
import 'widgets/gradient_app_bar.dart';
import 'widgets/prayer_card.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  await SurahSeedService(db).ensureSeeded();
  runApp(_BootstrapApp(database: db));
}

/// Bootstrap: DB seed + smoke-test shared widgets (nav, header, cards).
class _BootstrapApp extends StatefulWidget {
  const _BootstrapApp({required this.database});

  final AppDatabase database;

  @override
  State<_BootstrapApp> createState() => _BootstrapAppState();
}

class _BootstrapAppState extends State<_BootstrapApp> {
  int _navIndex = 0;

  late final Future<({List<Surah> surahs, List<SurahPoolEntry> pool})>
  _bootstrapFuture = _loadBootstrap();

  Future<({List<Surah> surahs, List<SurahPoolEntry> pool})>
  _loadBootstrap() async {
    final surahs = await widget.database.allSurahs();
    final pool = await widget.database.allPoolEntries();
    return (surahs: surahs, pool: pool);
  }

  PrayerSlot _demoSlot(List<SurahPoolEntry> pool) {
    if (pool.isEmpty) return PrayerSlot();
    final mapped = pool
        .take(PlanLimits.maxSurahsPerPrayerSlot)
        .map(PlanSurah.fromSurahPoolEntry)
        .toList();
    return PrayerSlot(surahs: mapped);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surah Planner',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<({List<Surah> surahs, List<SurahPoolEntry> pool})>(
        future: _bootstrapFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          }
          final data = snapshot.data!;
          final surahs = data.surahs;
          final pool = data.pool;
          if (surahs.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('No surahs loaded')),
            );
          }

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
                  surahs.firstWhere(
                    (s) => s.id == fajrSlot.surahs.first.surahId,
                  ),
                );

          return Scaffold(
            appBar: GradientAppBar(
              title: 'Surah Planner',
              subtitle:
                  '${surahs.length} chapters · ${pool.length} pool segment(s)',
              showLogo: true,
            ),
            body: ListView(
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
                const EmptyState(
                  variant: EmptyStateVariant.noPlan,
                  onAction: null,
                ),
              ],
            ),
            bottomNavigationBar: AppBottomNavBar(
              currentIndex: _navIndex,
              onTap: (i) => setState(() => _navIndex = i),
            ),
          );
        },
      ),
    );
  }
}
