import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/app_localizations.dart';
import 'gradient_button.dart';

/// Variants of the hifdh list empty state component.
enum EmptyStateVariant { hifdhListTooSmall, hifdhListEmpty }

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.variant, this.onAction});

  final EmptyStateVariant variant;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final spec = _spec(context, variant);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        color: AppColors.greenOverlay06,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.greenOverlay06,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(spec.icon, size: 32, color: AppColors.green),
          ),
          const SizedBox(height: 16),
          Text(spec.title, style: AppTextStyles.emptyStateTitle),
          const SizedBox(height: 8),
          SizedBox(
            width: 220,
            child: Text(
              spec.subtitle,
              style: AppTextStyles.body.copyWith(
                color: AppColors.ink3,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (spec.actionLabel != null) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: GradientButton(
                label: spec.actionLabel!,
                onPressed: onAction,
              ),
            ),
          ],
        ],
      ),
    );
  }

  _EmptyStateSpec _spec(BuildContext context, EmptyStateVariant v) {
    final s = S.of(context)!;
    switch (v) {
      case EmptyStateVariant.hifdhListTooSmall:
        return _EmptyStateSpec(
          icon: Icons.warning_amber_rounded,
          title: s.emptyPoolTooSmallTitle,
          subtitle: s.emptyPoolTooSmallSubtitle,
          actionLabel: s.emptyPoolTooSmallAction,
        );
      case EmptyStateVariant.hifdhListEmpty:
        return _EmptyStateSpec(
          icon: Icons.library_add_rounded,
          title: s.emptyHifdhListTitle,
          subtitle: s.emptyHifdhListSubtitle,
          actionLabel: s.emptyHifdhListAction,
        );
    }
  }
}

class _EmptyStateSpec {
  const _EmptyStateSpec({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
}
