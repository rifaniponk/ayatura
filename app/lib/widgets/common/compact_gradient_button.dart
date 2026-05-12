import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Inline CTA using [AppColors.buttonGradient] (toolbars, tight rows).
class CompactGradientButton extends StatelessWidget {
  const CompactGradientButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.enabled = true,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool enabled;

  static const double _radius = 12;

  @override
  Widget build(BuildContext context) {
    final canTap = enabled && onPressed != null;
    return Opacity(
      opacity: enabled ? 1.0 : 0.45,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canTap ? onPressed : null,
          borderRadius: BorderRadius.circular(_radius),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_radius),
              gradient: enabled
                  ? AppColors.buttonGradient
                  : const LinearGradient(
                      colors: [Color(0xFFAAAAAA), Color(0xFFCCCCCC)],
                    ),
              boxShadow: enabled && canTap
                  ? [
                      BoxShadow(
                        color: AppColors.green.withAlpha(76),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18, color: AppColors.white),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: AppTextStyles.smallLabel.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
