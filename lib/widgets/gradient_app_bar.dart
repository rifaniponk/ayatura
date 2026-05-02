import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Gradient header with optional crescent logo + subtitle.
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GradientAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.subtitleCaption,
    this.showLogo = false,
    this.onBack,
  });

  final String title;
  final String? subtitle;

  /// Optional second line under [subtitle] (e.g. short screen description).
  final String? subtitleCaption;
  final bool showLogo;
  final VoidCallback? onBack;

  /// Total bar height below the status bar (content + vertical padding).
  @override
  Size get preferredSize => Size.fromHeight(subtitleCaption != null ? 108 : 80);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (onBack != null) ...[
                  _BackButton(onTap: onBack!),
                  const SizedBox(width: 12),
                ],
                if (showLogo && onBack == null) ...[
                  SvgPicture.asset(
                    'assets/svg/crescent_mark.svg',
                    width: 34,
                    height: 34,
                    colorFilter: const ColorFilter.mode(
                      AppColors.gold,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.appTitle),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: AppTextStyles.meta.copyWith(
                            color: Colors.white54,
                          ),
                        ),
                      if (subtitleCaption != null) ...[
                        SizedBox(height: subtitle != null ? 4 : 6),
                        Text(
                          subtitleCaption!,
                          style: AppTextStyles.meta.copyWith(
                            color: Colors.white54,
                            fontSize: 11,
                            height: 1.35,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Back',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.white14,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.white,
            size: 16,
          ),
        ),
      ),
    );
  }
}
