import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../common/gradient_button.dart';

/// Home empty state: illustration plus copy and actions in a fixed viewport. The
/// illustration scales down with [FittedBox] inside [Expanded] so everything
/// fits the given height without scrolling.
class HomeEmptyHeroLayout extends StatelessWidget {
  const HomeEmptyHeroLayout({
    super.key,
    required this.semanticLabel,
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    required this.onPrimary,
    this.primaryEnabled = true,
    this.secondaryLabel,
    this.onSecondary,
    this.showPrimaryChevron = false,
  });

  static const String illustrationAsset =
      'assets/images/ayatura_ilustrator.png';

  /// Native pixels of [illustrationAsset] (1024×1536).
  static const double _nativeW = 1024;
  static const double _nativeH = 1536;

  final String semanticLabel;
  final String title;
  final String subtitle;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final bool primaryEnabled;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final bool showPrimaryChevron;

  @override
  Widget build(BuildContext context) {
    final Widget? chevron = showPrimaryChevron
        ? Icon(Icons.chevron_right_rounded, color: AppColors.gold, size: 26)
        : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final maxH = constraints.maxHeight;
        if (!maxH.isFinite || maxH <= 0 || !maxW.isFinite || maxW <= 0) {
          return const SizedBox.shrink();
        }

        final screenW = MediaQuery.sizeOf(context).width;

        return SizedBox(
          width: maxW,
          height: maxH,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRect(
                  child: LayoutBuilder(
                    builder: (context, inner) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: (inner.maxWidth - screenW) / 2,
                            width: screenW,
                            top: 0,
                            height: inner.maxHeight,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                width: _nativeW,
                                height: _nativeH,
                                child: Image.asset(
                                  illustrationAsset,
                                  fit: BoxFit.cover,
                                  semanticLabel: semanticLabel,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  title,
                  style: AppTextStyles.emptyStateTitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  subtitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.ink3,
                    fontSize: 13,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.border,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: AppColors.gold,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.border,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GradientButton(
                  label: primaryLabel,
                  onPressed: onPrimary,
                  enabled: primaryEnabled,
                  trailing: chevron,
                ),
              ),
              if (secondaryLabel != null && onSecondary != null) ...[
                const SizedBox(height: 8),
                Center(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: onSecondary,
                    icon: Icon(
                      Icons.menu_book_outlined,
                      color: AppColors.green,
                      size: 20,
                    ),
                    label: Text(
                      secondaryLabel!,
                      style: AppTextStyles.smallLabel.copyWith(
                        color: AppColors.green,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
