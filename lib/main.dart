import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'data/models/plan.dart';
import 'data/models/prayer.dart';
import 'data/models/surah.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _BootstrapApp());
}

/// Temporary bootstrap: loads bundled assets and exercises domain models.
class _BootstrapApp extends StatelessWidget {
  const _BootstrapApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surah Planner',
      home: Scaffold(
        body: FutureBuilder<String>(
          future: rootBundle.loadString('assets/data/surahs.json'),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final raw = snapshot.data!;
            final map = jsonDecode(raw) as Map<String, dynamic>;
            final list = map['surahs'] as List<dynamic>;
            final surahs = list
                .map((e) => Surah.fromJson(e as Map<String, dynamic>))
                .toList();

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
                            '${surahs.length} Surah models',
                            style: Theme.of(context).textTheme.titleLarge,
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
