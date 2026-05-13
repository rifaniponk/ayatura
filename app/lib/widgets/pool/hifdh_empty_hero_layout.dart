import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../common/gradient_button.dart';

/// Hifdh list tab empty state: illustration fills remaining viewport height
/// without scrolling, with title, subtitle, and primary action below. Matches
/// [MonthEmptyHeroLayout] and [HomeEmptyHeroLayout] layout strategy.
///
/// Copy and primary button use the same effective horizontal inset as home
/// ([HomeEmptyHeroLayout] inside [HomeBodyState] list padding 16 plus inner 8).
class HifdhEmptyHeroLayout extends StatelessWidget {
  const HifdhEmptyHeroLayout({
    super.key,
    required this.semanticLabel,
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    this.onPrimary,
    this.primaryEnabled = true,
  });

  static const String illustrationAsset = 'assets/images/empty_hifdh.png';

  /// Native pixels of [illustrationAsset].
  static const double _nativeW = 870;
  static const double _nativeH = 900;

  static const EdgeInsets _copyHorizontalMargin = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const EdgeInsets _copyInnerPadding = EdgeInsets.symmetric(
    horizontal: 8,
  );

  final String semanticLabel;
  final String title;
  final String subtitle;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final bool primaryEnabled;

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 50),
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
                                  fit: BoxFit.contain,
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
                padding: _copyHorizontalMargin,
                child: Padding(
                  padding: _copyInnerPadding,
                  child: Text(
                    title,
                    style: AppTextStyles.emptyStateTitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: _copyHorizontalMargin,
                child: Padding(
                  padding: _copyInnerPadding,
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
              ),
              const SizedBox(height: 16),
              Padding(
                padding: _copyHorizontalMargin,
                child: Padding(
                  padding: _copyInnerPadding,
                  child: GradientButton(
                    label: primaryLabel,
                    onPressed: onPrimary,
                    enabled: primaryEnabled,
                    icon: Icons.library_add_rounded,
                  ),
                ),
              ),
              const SizedBox(height: 70),
            ],
          ),
        );
      },
    );
  }
}
