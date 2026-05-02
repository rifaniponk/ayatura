import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Preference key for the Hifdh screen tip — bump `_v2` if copy should show again.
///
/// Kept stable (`prefs.hifdh_intro_tip_dismissed_v1`) so existing installs retain dismissal.
const kDismissibleIntroTipHifdhKey = 'prefs.hifdh_intro_tip_dismissed_v1';

/// Info banner that hides permanently after dismiss; state stored in
/// [SharedPreferences] under [storageKey] (`true` means dismissed).
///
/// Use a **unique** [storageKey] per tip so pages do not share dismissal state.
class DismissibleIntroTip extends StatefulWidget {
  const DismissibleIntroTip({
    super.key,
    required this.storageKey,
    required this.message,
    this.outerPadding = const EdgeInsets.fromLTRB(18, 12, 18, 0),
    this.icon = Icons.info_outline_rounded,
    this.dismissTooltip = 'Dismiss',
    this.onDismissed,
  });

  /// SharedPreferences boolean key; dismissed when value is `true`.
  final String storageKey;

  final String message;

  /// Padding around the banner (outside rounded background).
  final EdgeInsetsGeometry outerPadding;

  final IconData icon;

  final String dismissTooltip;

  /// Called after persistence succeeds and the widget is about to hide.
  final VoidCallback? onDismissed;

  @override
  State<DismissibleIntroTip> createState() => _DismissibleIntroTipState();
}

class _DismissibleIntroTipState extends State<DismissibleIntroTip> {
  bool? _show;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _show = !(prefs.getBool(widget.storageKey) ?? false));
  }

  Future<void> _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(widget.storageKey, true);
    widget.onDismissed?.call();
    if (!mounted) return;
    setState(() => _show = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_show != true) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: widget.outerPadding,
      child: Material(
        color: AppColors.greenOverlay06,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(widget.icon, size: 20, color: scheme.secondary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.message,
                  style: AppTextStyles.smallLabel.copyWith(
                    color: AppColors.ink2,
                    height: 1.35,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                tooltip: widget.dismissTooltip,
                color: AppColors.ink3,
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                padding: EdgeInsets.zero,
                onPressed: _dismiss,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
