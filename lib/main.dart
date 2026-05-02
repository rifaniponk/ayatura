import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'core/theme/app_theme.dart';
import 'data/local/app_database.dart';
import 'data/models/plan.dart';
import 'data/models/prayer.dart';
import 'data/models/surah.dart';
import 'data/models/surah_pool_entry.dart';
import 'data/services/surah_seed_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  await SurahSeedService(db).ensureSeeded();
  runApp(_BootstrapApp(database: db));
}

/// Temporary bootstrap: reads surahs from the local DB after seeding.
class _BootstrapApp extends StatefulWidget {
  const _BootstrapApp({required this.database});

  final AppDatabase database;

  @override
  State<_BootstrapApp> createState() => _BootstrapAppState();
}

class _BootstrapAppState extends State<_BootstrapApp> {
  late final Future<({List<Surah> surahs, List<SurahPoolEntry> pool})>
  _bootstrapFuture = _loadBootstrap();

  Future<({List<Surah> surahs, List<SurahPoolEntry> pool})>
  _loadBootstrap() async {
    final surahs = await widget.database.allSurahs();
    final pool = await widget.database.allPoolEntries();
    return (surahs: surahs, pool: pool);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surah Planner',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FutureBuilder<({List<Surah> surahs, List<SurahPoolEntry> pool})>(
          future: _bootstrapFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final data = snapshot.data!;
            final surahs = data.surahs;
            final pool = data.pool;
            if (surahs.isEmpty) {
              return const Center(child: Text('No surahs loaded'));
            }

            final sampleDay = DayPlan(
              day: 1,
              prayers: {for (final p in Prayer.values) p: PrayerSlot()},
            );
            final fajrLabel = sampleDay.slotFor(Prayer.fajr).surahs.isEmpty
                ? Prayer.fajr.label
                : sampleDay.slotFor(Prayer.fajr).surahs.first.displayName;

            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/background.png', fit: BoxFit.cover),
                Container(color: Colors.black26),
                Center(
                  child: Card(
                    margin: const EdgeInsets.all(24),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/crescent_mark.svg',
                            width: 56,
                            height: 56,
                          ),
                          const SizedBox(height: 12),
                          Image.asset(
                            'assets/images/app_icon.png',
                            width: 72,
                            height: 72,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${surahs.length} Quran chapters loaded '
                            '(expected 114)',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${pool.length} memorization segment(s) in pool '
                            '(not chapters — same surah can appear more than once)',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'First: ${surahs.first.displayName}',
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Last: ${surahs.last.displayName}',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Prayer enum: ${Prayer.values.map((p) => p.shortLabel).join(' · ')}',
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Sample slot for Fajr resolves to: $fajrLabel',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
