import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Surah Planner modal alert: matches card radius, border, and typography.
///
/// Prefer [showAppAlertDialog] so the scrim uses [AppColors.overlayDark].
class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
  });

  final Widget title;
  final Widget content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DefaultTextStyle.merge(
                style: AppTextStyles.sectionHeadingSerif.copyWith(fontSize: 18),
                child: title,
              ),
              const SizedBox(height: 12),
              DefaultTextStyle.merge(
                style: AppTextStyles.body,
                child: content,
              ),
              if (actions.isNotEmpty) ...[
                const SizedBox(height: 22),
                Theme(
                  data: Theme.of(context).copyWith(
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.green2,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        textStyle: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 4,
                    runSpacing: 4,
                    children: actions,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows [AppAlertDialog] with the app modal scrim.
///
/// [actions] receives the dialog [BuildContext]; use it with [Navigator.pop]
/// so the correct route is closed.
Future<T?> showAppAlertDialog<T>(
  BuildContext context, {
  required Widget title,
  required Widget content,
  List<Widget> Function(BuildContext dialogContext)? actions,
}) {
  return showDialog<T>(
    context: context,
    barrierColor: AppColors.overlayDark,
    builder: (dialogContext) => AppAlertDialog(
      title: title,
      content: content,
      actions: actions?.call(dialogContext) ?? const [],
    ),
  );
}
