import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/nav_provider.dart';
import '../providers/prayer_times_provider.dart';
import '../widgets/navigation/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'month_screen.dart';
import 'pool_screen.dart';
import 'settings_screen.dart';

/// Root shell: Home, Month, Hifdh list, Settings + bottom nav.
///
/// Tab widgets manage their own headers and scrollable bodies; state comes
/// from Riverpod ([navIndexProvider], data providers per screen).
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  static const List<Widget> _tabs = [
    HomeScreen(),
    MonthScreen(),
    PoolScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(prayerTimesSyncProvider);
    final navIndex = ref
        .watch(navIndexProvider)
        .clamp(0, AppShell._tabs.length - 1);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: navIndex, children: AppShell._tabs),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: navIndex,
        onTap: (i) => ref.read(navIndexProvider.notifier).setIndex(i),
      ),
    );
  }
}
