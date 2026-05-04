import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/plan.dart';
import '../../data/models/prayer.dart';
import '../../data/models/surah.dart';

/// A single prayer slot card (e.g. home timeline).
///
/// [masterBySurahId] maps Quran surah number → canonical [Surah] for labels.
class PrayerCard extends StatelessWidget {
  const PrayerCard({
    super.key,
    required this.prayer,
    required this.slot,
    required this.masterBySurahId,
    this.onTap,
  });

  final Prayer prayer;
  final PrayerSlot slot;
  final Map<int, Surah> masterBySurahId;
  final VoidCallback? onTap;

  String _localizedName(S s) => switch (prayer) {
    Prayer.fajr => s.prayerFajr,
    Prayer.dhuhr => s.prayerDhuhr,
    Prayer.asr => s.prayerAsr,
    Prayer.maghrib => s.prayerMaghrib,
    Prayer.isha => s.prayerIsha,
  };

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: slot.locked
                ? AppColors.goldOverlay30
                : const Color(0x0F0F3D2E),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.green.withAlpha(18),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _localizedName(s).toUpperCase(),
                  style: AppTextStyles.prayerLabel,
                ),
                if (slot.locked) ...[
                  const SizedBox(width: 6),
                  const Text('🔒', style: TextStyle(fontSize: 11)),
                ],
                const Spacer(),
              ],
            ),
            const SizedBox(height: 8),
            if (slot.surahs.isEmpty)
              Text(
                s.prayerNoReadings,
                style: AppTextStyles.meta.copyWith(
                  color: AppColors.ink3,
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              ...slot.surahs.asMap().entries.map((entry) {
                final idx = entry.key;
                final ps = entry.value;
                final master = masterBySurahId[ps.surahId];
                final label = master != null
                    ? ps.displayLabel(master, lang)
                    : 'Surah ${ps.surahId}';
                final verses = master != null ? ps.verseSpan(master) : 0;
                return Padding(
                  padding: EdgeInsets.only(top: idx == 0 ? 0 : 6),
                  child: Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          gradient: AppColors.buttonGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${idx + 1}',
                            style: AppTextStyles.meta.copyWith(
                              color: AppColors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          label,
                          style: AppTextStyles.surahNameCard,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        s.prayerAyatCount(verses),
                        style: AppTextStyles.meta,
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
