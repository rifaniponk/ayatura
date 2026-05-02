import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../widgets/gradient_app_bar.dart';

/// Preferences and data actions — placeholders until wired to persistence.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _reminders = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const GradientAppBar(title: 'Settings'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Text('Preferences', style: AppTextStyles.sectionHeadingSerif),
              const SizedBox(height: 12),
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: SwitchListTile(
                  title: Text(
                    'Prayer reminders',
                    style: AppTextStyles.cardLabel,
                  ),
                  subtitle: Text(
                    'Notify before each prayer',
                    style: AppTextStyles.meta,
                  ),
                  value: _reminders,
                  activeThumbColor: AppColors.white,
                  activeTrackColor: AppColors.green2,
                  onChanged: (v) => setState(() => _reminders = v),
                ),
              ),
              const SizedBox(height: 28),
              Text('About', style: AppTextStyles.sectionHeadingSerif),
              const SizedBox(height: 12),
              Text(
                'Surah Planner links memorization segments to prayers across '
                'the month. Monthly assignment storage is coming next.',
                style: AppTextStyles.body.copyWith(color: AppColors.ink2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
