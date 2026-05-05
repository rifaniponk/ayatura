import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_text_styles.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/package_info_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/common/app_dropdown_button.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
              const SizedBox(height: 32),
              ref
                      .watch(packageInfoProvider)
                      .whenData(
                        (info) => Text(
                          'v${info.version} (${info.buildNumber})',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.meta.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.35),
                          ),
                        ),
                      ) ??
                  const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}
