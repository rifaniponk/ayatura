import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';

/// Design-system toggle (pill track + thumb). Matches [AppTheme.switchTheme]
/// colors and card radius language; on-state track uses [AppColors.buttonGradient].
///
/// Use anywhere you need a binary switch with consistent branding.
class AppToggle extends StatelessWidget {
  const AppToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.semanticsLabel,
    this.autofocus = false,
    this.focusNode,
  });

  final bool value;

  /// Called with the new value when the user toggles. Null disables interaction.
  final ValueChanged<bool>? onChanged;

  /// Announced by screen readers when not merged into a parent label.
  final String? semanticsLabel;

  final bool autofocus;
  final FocusNode? focusNode;

  static const double trackWidth = 52;
  static const double trackHeight = 30;
  static const double thumbDiameter = 24;
  static const double _thumbInset = 3;
  static const double _minTapExtent = 48;

  double get _thumbLeft =>
      value ? trackWidth - thumbDiameter - _thumbInset : _thumbInset;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;

    final toggle = Opacity(
      opacity: enabled ? 1 : 0.45,
      child: SizedBox(
        width: trackWidth,
        height: _minTapExtent,
        child: Center(
          child: SizedBox(
            width: trackWidth,
            height: trackHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(trackHeight / 2),
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.switchTrackInactive,
                        border: Border.all(
                          color: AppColors.switchTrackInactiveBorder,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      opacity: value ? 1 : 0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: AppColors.buttonGradient,
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    left: _thumbLeft,
                    top: (trackHeight - thumbDiameter) / 2,
                    width: thumbDiameter,
                    height: thumbDiameter,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                        border: Border.all(
                          color: value
                              ? AppColors.gold.withValues(alpha: 0.55)
                              : AppColors.switchTrackInactiveBorder.withValues(
                                  alpha: 0.45,
                                ),
                          width: value ? 1.5 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: value
                                ? AppColors.green.withValues(alpha: 0.38)
                                : Colors.black.withValues(alpha: 0.18),
                            blurRadius: value ? 7 : 4,
                            offset: Offset(0, value ? 2.5 : 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              if (enabled) {
                onChanged!(!value);
              }
              return null;
            },
          ),
        },
        child: Focus(
          focusNode: focusNode,
          autofocus: autofocus,
          child: Semantics(
            toggled: value,
            enabled: enabled,
            label: semanticsLabel,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: enabled ? () => onChanged!(!value) : null,
                borderRadius: BorderRadius.circular(_minTapExtent / 2),
                splashFactory: InkRipple.splashFactory,
                excludeFromSemantics: true,
                child: toggle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
