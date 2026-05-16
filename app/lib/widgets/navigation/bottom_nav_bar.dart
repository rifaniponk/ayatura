import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'nav_item.dart';
import 'nav_item_widget.dart';

/// Bottom navigation: Home, Month, Hifdh (memorization list), Settings.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundMatchesBody = false,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavItem> items;

  /// When true, bar uses [AppColors.background] like the scaffold body (Home,
  /// Month, or Hifdh empty hero).
  final bool backgroundMatchesBody;

  @override
  Widget build(BuildContext context) {
    final barColor = backgroundMatchesBody
        ? AppColors.background
        : AppColors.white;

    final bottomInset = math.max(
      MediaQuery.paddingOf(context).bottom,
      MediaQuery.viewPaddingOf(context).bottom,
    );

    return Container(
      decoration: BoxDecoration(
        color: barColor,
        border: backgroundMatchesBody
            ? null
            : Border(
                top: BorderSide(
                  color: AppColors.green.withAlpha(0x12),
                  width: 1,
                ),
              ),
        boxShadow: backgroundMatchesBody
            ? null
            : [
                BoxShadow(
                  color: AppColors.green.withAlpha(20),
                  blurRadius: 24,
                  offset: const Offset(0, -4),
                ),
              ],
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: 72,
        child: Row(
          children: List.generate(items.length, (i) {
            final isActive = i == currentIndex;
            return Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onTap(i),
                  customBorder: const RoundedRectangleBorder(),
                  child: NavItemWidget(item: items[i], isActive: isActive),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
