import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'nav_item.dart';

class NavItemWidget extends StatelessWidget {
  const NavItemWidget({super.key, required this.item, required this.isActive});

  final NavItem item;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final duration = disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 180);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedScale(
          scale: isActive ? 1 : 0.94,
          duration: duration,
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: duration,
            curve: Curves.easeOut,
            width: 52,
            height: 32,
            decoration: BoxDecoration(
              gradient: isActive ? AppColors.buttonGradient : null,
              color: isActive ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isActive ? (item.activeIcon ?? item.icon) : item.icon,
              size: 22,
              color: isActive ? AppColors.white : AppColors.bottomNavInactive,
            ),
          ),
        ),
        const SizedBox(height: 3),
        AnimatedDefaultTextStyle(
          duration: duration,
          curve: Curves.easeOut,
          style: AppTextStyles.navLabel.copyWith(
            color: isActive ? AppColors.green : AppColors.bottomNavInactive,
          ),
          child: Text(item.label),
        ),
      ],
    );
  }
}
