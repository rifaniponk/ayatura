import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'compact_outlined_button.dart';

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

  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );

  @override
  Widget build(BuildContext context) {
    final canTap = enabled && onPressed != null;
    final radius = BorderRadius.circular(CompactOutlinedButton.radius);
    final decoration = BoxDecoration(
      borderRadius: radius,
      gradient: enabled
          ? AppColors.buttonGradient
          : const LinearGradient(
              colors: [Color(0xFFAAAAAA), Color(0xFFCCCCCC)],
            ),
    );

    return Opacity(
      opacity: enabled ? 1.0 : 0.45,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
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
        child: ClipRRect(
          borderRadius: radius,
          child: Material(
            color: Colors.transparent,
            child: Ink(
              decoration: decoration,
              child: InkWell(
                onTap: canTap ? onPressed : null,
                customBorder: RoundedRectangleBorder(borderRadius: radius),
                child: Padding(
                  padding: _padding,
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
        ),
      ),
    );
  }
}
