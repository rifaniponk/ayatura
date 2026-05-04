import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_text_styles.dart';
import '../data/models/prayer.dart';
import '../data/models/prayer_times.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/common/app_dropdown_button.dart';
import '../widgets/common/gradient_app_bar.dart';

/// Preferences and data actions — placeholders until wired to persistence.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _formatMinutes(int totalMinutes) {
    return PrayerTimes.formatMinutes(totalMinutes);
  }

  Future<void> _pickPrayerTime(Prayer prayer, int currentMinutes) async {
    final initial = TimeOfDay(
      hour: currentMinutes ~/ 60,
      minute: currentMinutes % 60,
    );
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;
    final totalMinutes = (picked.hour * 60) + picked.minute;
    await ref
        .read(prayerTimesProvider.notifier)
        .setPrayerMinutes(prayer, totalMinutes);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final locale = ref.watch(localeProvider);
    final surahsPerPrayer = ref.watch(surahsPerPrayerProvider);
    final prayerTimes = ref.watch(prayerTimesProvider);

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
              Text(
                'Prayer Times (Widget v1)',
                style: AppTextStyles.sectionHeadingSerif,
              ),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Fajr', style: AppTextStyles.cardLabel),
                      subtitle: Text(
                        _formatMinutes(prayerTimes.fajrMinutes),
                        style: AppTextStyles.meta,
                      ),
                      trailing: const Icon(Icons.schedule_rounded),
                      onTap: () =>
                          _pickPrayerTime(Prayer.fajr, prayerTimes.fajrMinutes),
                    ),
                    ListTile(
                      title: const Text(
                        'Dhuhr',
                        style: AppTextStyles.cardLabel,
                      ),
                      subtitle: Text(
                        _formatMinutes(prayerTimes.dhuhrMinutes),
                        style: AppTextStyles.meta,
                      ),
                      trailing: const Icon(Icons.schedule_rounded),
                      onTap: () => _pickPrayerTime(
                        Prayer.dhuhr,
                        prayerTimes.dhuhrMinutes,
                      ),
                    ),
                    ListTile(
                      title: const Text('Asr', style: AppTextStyles.cardLabel),
                      subtitle: Text(
                        _formatMinutes(prayerTimes.asrMinutes),
                        style: AppTextStyles.meta,
                      ),
                      trailing: const Icon(Icons.schedule_rounded),
                      onTap: () =>
                          _pickPrayerTime(Prayer.asr, prayerTimes.asrMinutes),
                    ),
                    ListTile(
                      title: const Text(
                        'Maghrib',
                        style: AppTextStyles.cardLabel,
                      ),
                      subtitle: Text(
                        _formatMinutes(prayerTimes.maghribMinutes),
                        style: AppTextStyles.meta,
                      ),
                      trailing: const Icon(Icons.schedule_rounded),
                      onTap: () => _pickPrayerTime(
                        Prayer.maghrib,
                        prayerTimes.maghribMinutes,
                      ),
                    ),
                    ListTile(
                      title: const Text('Isha', style: AppTextStyles.cardLabel),
                      subtitle: Text(
                        _formatMinutes(prayerTimes.ishaMinutes),
                        style: AppTextStyles.meta,
                      ),
                      trailing: const Icon(Icons.schedule_rounded),
                      onTap: () =>
                          _pickPrayerTime(Prayer.isha, prayerTimes.ishaMinutes),
                    ),
                  ],
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
