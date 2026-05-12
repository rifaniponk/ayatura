import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../common/gradient_button.dart';

/// Centered empty state used when no monthly plan exists, matching month screen.
class NoPlanEmptyLayout extends StatelessWidget {
  const NoPlanEmptyLayout({
    super.key,
    required this.title,
    required this.subtitle,
    this.createPlanLabel,
    this.onCreatePlan,
    this.createPlanEnabled = true,
  });

  final String title;
  final String subtitle;
  final String? createPlanLabel;
  final VoidCallback? onCreatePlan;
  final bool createPlanEnabled;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.autorenew_rounded,
              size: 48,
              color: AppColors.green.withValues(alpha: 0.45),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.emptyStateTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTextStyles.body.copyWith(
                color: AppColors.ink3,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            if (createPlanLabel != null) ...[
              const SizedBox(height: 24),
              GradientButton(
                label: createPlanLabel!,
                onPressed: onCreatePlan,
                enabled: createPlanEnabled,
                icon: Icons.auto_awesome_rounded,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
