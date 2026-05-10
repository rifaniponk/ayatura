part of 'day_plan_card.dart';

class _CompactPrayerRow extends StatelessWidget {
  const _CompactPrayerRow({
    required this.prayer,
    required this.slot,
    required this.s,
    required this.lang,
    required this.masterBySurahId,
    required this.onToggleLock,
    required this.onTap,
  });

  final Prayer prayer;
  final PrayerSlot slot;
  final S s;
  final String lang;
  final Map<int, Surah> masterBySurahId;
  final VoidCallback onToggleLock;
  final VoidCallback onTap;

  static String _segment(PlanSurah ps, Surah? m, String lang, S s) {
    final name = m?.localizedName(lang) ?? 'Surah ${ps.surahId}';
    if (ps.isFullSurah) return name;
    final a = ps.startAyah;
    final b = ps.endAyah;
    if (a != null && b != null) {
      if (a == b) return '$name $a';
      return '$name ${s.monthAyatRange(a, b)}';
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    final line = slot.surahs.isEmpty
        ? s.monthPrayerEmpty
        : slot.surahs
              .map((ps) => _segment(ps, masterBySurahId[ps.surahId], lang, s))
              .join(' · ');

    final valueStyle = slot.surahs.isEmpty
        ? AppTextStyles.meta.copyWith(
            fontSize: 12,
            color: AppColors.ink3,
            fontStyle: FontStyle.italic,
            height: 1.25,
          )
        : AppTextStyles.surahNameCard.copyWith(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            height: 1.25,
            color: AppColors.ink,
          );

    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: slot.surahs.isEmpty ? null : onTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: _kPrayerColWidth,
                      child: Text(
                        prayer.shortLabel,
                        style: AppTextStyles.prayerLabel.copyWith(
                          fontSize: 10.5,
                          letterSpacing: 0.6,
                          height: 1.2,
                          color: AppColors.green,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(line, style: valueStyle, softWrap: true),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 24,
            height: 24,
            child: IconButton(
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints.tightFor(width: 24, height: 24),
              style: IconButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: const Size(24, 24),
                maximumSize: const Size(24, 24),
                padding: EdgeInsets.zero,
              ),
              padding: EdgeInsets.zero,
              icon: Icon(
                slot.locked ? Icons.lock_rounded : Icons.lock_open_rounded,
                size: 16,
                color: slot.locked ? AppColors.gold : AppColors.ink3,
              ),
              tooltip: slot.locked ? s.unlockSlotTooltip : s.lockSlotTooltip,
              onPressed: onToggleLock,
            ),
          ),
        ],
      ),
    );
  }
}
