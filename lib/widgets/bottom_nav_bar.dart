import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Bottom navigation: Home, Month, Pool, More (Settings).
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.calendar_month_rounded, label: 'Month'),
    _NavItem(icon: Icons.library_books_rounded, label: 'Pool'),
    _NavItem(icon: Icons.more_horiz_rounded, label: 'More'),
  ];

  @override
  Widget build(BuildContext context) {
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
        children: List.generate(_items.length, (i) {
          final isActive = i == currentIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: _NavItemWidget(item: _items[i], isActive: isActive),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class _NavItemWidget extends StatelessWidget {
  const _NavItemWidget({required this.item, required this.isActive});

  final _NavItem item;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: 52,
          height: 32,
          decoration: BoxDecoration(
            gradient: isActive ? AppColors.buttonGradient : null,
            color: isActive ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            item.icon,
            size: 22,
            color: isActive ? AppColors.white : AppColors.bottomNavInactive,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          item.label,
          style: AppTextStyles.navLabel.copyWith(
            color: isActive ? AppColors.green : AppColors.bottomNavInactive,
          ),
        ),
      ],
    );
  }
}
