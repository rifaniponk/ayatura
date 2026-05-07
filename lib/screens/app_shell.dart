import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/feature_flags.dart';
import '../l10n/app_localizations.dart';
import '../providers/core/nav_provider.dart';
import '../providers/prayer/prayer_times_provider.dart';
import '../widgets/navigation/bottom_nav_bar.dart';
import '../widgets/navigation/nav_item.dart';
import 'home_screen.dart';
import 'insight_screen.dart';
import 'month_screen.dart';
import 'pool_screen.dart';
import 'settings_screen.dart';

/// Root shell: Home, Month, Hifdh list, Settings + bottom nav.
///
/// Tab widgets manage their own headers and scrollable bodies; state comes
/// from Riverpod ([navIndexProvider], data providers per screen).
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context)!;
    ref.watch(prayerTimesSyncProvider);
    final tabs = <Widget>[
      const HomeScreen(),
      const MonthScreen(),
      const PoolScreen(),
      if (FeatureFlags.insightPage) const InsightScreen(),
      const SettingsScreen(),
    ];
    final navItems = <NavItem>[
      NavItem(icon: Icons.home_rounded, label: s.navHome),
      NavItem(icon: Icons.calendar_month_rounded, label: s.navMonth),
      NavItem(icon: Icons.menu_book_rounded, label: s.navHifdh),
      if (FeatureFlags.insightPage)
        NavItem(icon: Icons.insights_rounded, label: s.navInsight),
      NavItem(
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings,
        label: s.navSettings,
      ),
    ];
    final navIndex = ref.watch(navIndexProvider).clamp(0, tabs.length - 1);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: navIndex, children: tabs),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: navIndex,
        items: navItems,
        onTap: (i) => ref.read(navIndexProvider.notifier).setIndex(i),
      ),
    );
  }
}
