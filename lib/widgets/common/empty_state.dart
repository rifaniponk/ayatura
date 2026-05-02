import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'gradient_button.dart';

/// Three variants of the empty state component.
enum EmptyStateVariant { noPlan, hifdhListTooSmall, hifdhListEmpty }

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.variant, this.onAction});

  final EmptyStateVariant variant;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final spec = _spec(variant);
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

  _EmptyStateSpec _spec(EmptyStateVariant v) {
    switch (v) {
      case EmptyStateVariant.noPlan:
        return const _EmptyStateSpec(
          icon: Icons.auto_awesome_rounded,
          title: 'No plan yet',
          subtitle: 'Generate a plan to assign readings across the month.',
          actionLabel: 'Generate Plan',
        );
      case EmptyStateVariant.hifdhListTooSmall:
        return const _EmptyStateSpec(
          icon: Icons.warning_amber_rounded,
          title: 'Need more for a plan',
          subtitle:
              'Include at least two surahs or ayat ranges in your hifdh list '
              '(with the switch on), then generate a plan.',
          actionLabel: 'Open Hifdh',
        );
      case EmptyStateVariant.hifdhListEmpty:
        return const _EmptyStateSpec(
          icon: Icons.library_add_rounded,
          title: 'Start your hifdh list',
          subtitle:
              'Add full surahs or ayat ranges you are memorizing. '
              'Your monthly plan will draw from this list.',
          actionLabel: 'Add surah or ayat',
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
