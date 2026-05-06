import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/app_localizations.dart';

part 'nav_item_widget.dart';

/// Bottom navigation: Home, Month, Hifdh (memorization list), Settings.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final items = [
      _NavItem(icon: Icons.home_rounded, label: s.navHome),
      _NavItem(icon: Icons.calendar_month_rounded, label: s.navMonth),
      _NavItem(icon: Icons.menu_book_rounded, label: s.navHifdh),
      _NavItem(
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings,
        label: s.navSettings,
      ),
    ];

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.green.withAlpha(0x12), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.green.withAlpha(20),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final isActive = i == currentIndex;
          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onTap(i),
                customBorder: const RoundedRectangleBorder(),
                child: _NavItemWidget(item: items[i], isActive: isActive),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, this.activeIcon, required this.label});

  final IconData icon;
  final IconData? activeIcon;
  final String label;
}
