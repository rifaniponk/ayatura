import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Preference flag — bump key suffix if copy changes and should show again.
const _kHifdhIntroDismissed = 'prefs.hifdh_intro_tip_dismissed_v1';

/// Short explanation of the Hifdh screen; dismiss persists via [SharedPreferences].
class HifdhIntroTip extends StatefulWidget {
  const HifdhIntroTip({super.key});

  @override
  State<HifdhIntroTip> createState() => _HifdhIntroTipState();
}

class _HifdhIntroTipState extends State<HifdhIntroTip> {
  bool? _show;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _show = !(prefs.getBool(_kHifdhIntroDismissed) ?? false));
  }

  Future<void> _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kHifdhIntroDismissed, true);
    if (!mounted) return;
    setState(() => _show = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_show != true) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
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
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: scheme.secondary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Hifdh is Quran memorization. What you list here is used '
                  'when you build your monthly plan.',
                  style: AppTextStyles.smallLabel.copyWith(
                    color: AppColors.ink2,
                    height: 1.35,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                tooltip: 'Dismiss',
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
