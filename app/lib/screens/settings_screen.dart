import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_text_styles.dart';
import '../l10n/app_localizations.dart';
import '../providers/core/locale_provider.dart';
import '../providers/core/settings_provider.dart';
import '../widgets/common/app_dropdown_button.dart';
import 'about_screen.dart';

/// Preferences and data actions — placeholders until wired to persistence.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final locale = ref.watch(localeProvider);
    final surahsPerPrayer = ref.watch(surahsPerPrayerProvider);
    final lockPastPrayers = ref.watch(lockPastPrayersProvider);

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text(s.settingsPreferences, style: AppTextStyles.sectionHeadingSerif),
        const SizedBox(height: 12),
        Card(
          child: SwitchListTile(
            title: Text(
              s.settingsLockPastPrayers,
              style: AppTextStyles.cardLabel,
            ),
            subtitle: Text(
              s.settingsLockPastPrayersSubtitle,
              style: AppTextStyles.meta,
            ),
            value: lockPastPrayers,
            onChanged: (value) =>
                ref.read(lockPastPrayersProvider.notifier).set(value),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            title: Text(
              s.settingsSurahsPerPrayer,
              style: AppTextStyles.cardLabel,
            ),
            subtitle: Text(
              s.settingsSurahsPerPrayerSubtitle,
              style: AppTextStyles.meta,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_rounded),
                  onPressed: surahsPerPrayer > surahsPerPrayerMin
                      ? () => ref
                            .read(surahsPerPrayerProvider.notifier)
                            .set(surahsPerPrayer - 1)
                      : null,
                ),
                SizedBox(
                  width: 28,
                  child: Text(
                    '$surahsPerPrayer',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.cardLabel,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_rounded),
                  onPressed: surahsPerPrayer < surahsPerPrayerMax
                      ? () => ref
                            .read(surahsPerPrayerProvider.notifier)
                            .set(surahsPerPrayer + 1)
                      : null,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            title: Text(s.settingsLanguage, style: AppTextStyles.cardLabel),
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
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            title: Text(
              s.settingsAboutTileTitle,
              style: AppTextStyles.cardLabel,
            ),
            subtitle: Text(
              s.settingsAboutTileSubtitle,
              style: AppTextStyles.meta,
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const AboutScreen()),
              );
            },
          ),
        ),
      ],
    );
  }
}
