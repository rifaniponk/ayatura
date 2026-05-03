import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_text_styles.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../widgets/common/app_dropdown_button.dart';
import '../widgets/common/gradient_app_bar.dart';

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
    final s = S.of(context)!;
    final locale = ref.watch(localeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GradientAppBar(title: s.settingsTitle),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Text(
                s.settingsPreferences,
                style: AppTextStyles.sectionHeadingSerif,
              ),
              const SizedBox(height: 12),
              Card(
                child: SwitchListTile(
                  title: Text(
                    s.settingsPrayerReminders,
                    style: AppTextStyles.cardLabel,
                  ),
                  subtitle: Text(
                    s.settingsPrayerRemindersSubtitle,
                    style: AppTextStyles.meta,
                  ),
                  value: _reminders,
                  onChanged: (v) => setState(() => _reminders = v),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  title: Text(
                    s.settingsLanguage,
                    style: AppTextStyles.cardLabel,
                  ),
                  subtitle: Text(
                    s.settingsLanguageSubtitle,
                    style: AppTextStyles.meta,
                  ),
                  trailing: AppDropdownButton<Locale>(
                    value: locale,
                    isDense: true,
                    items: [
                      DropdownMenuItem(
                        value: const Locale('en'),
                        child: Text(s.langEnglish),
                      ),
                      DropdownMenuItem(
                        value: const Locale('id'),
                        child: Text(s.langIndonesian),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(localeProvider.notifier).setLocale(value);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(s.settingsAbout, style: AppTextStyles.sectionHeadingSerif),
              const SizedBox(height: 12),
              Text(
                s.settingsAboutBody,
                style: AppTextStyles.body.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
