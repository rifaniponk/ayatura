import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Outlined companion to [CompactGradientButton] for paired toolbar actions.
class CompactOutlinedButton extends StatelessWidget {
  const CompactOutlinedButton({
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

  static const double radius = 12;

  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );

  @override
  Widget build(BuildContext context) {
    final canTap = enabled && onPressed != null;
    return Opacity(
      opacity: enabled ? 1.0 : 0.45,
      child: OutlinedButton.icon(
        onPressed: canTap ? onPressed : null,
        icon: Icon(icon, size: 18, color: AppColors.green),
        label: Text(
          label,
          style: AppTextStyles.smallLabel.copyWith(
            color: AppColors.green,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.green,
          side: const BorderSide(color: AppColors.green2),
          padding: _padding,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
    );
  }
}
