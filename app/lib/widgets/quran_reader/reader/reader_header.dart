part of '../quran_reader_sheet.dart';

class _ReaderHeader extends StatelessWidget {
  const _ReaderHeader({
    required this.headerLabel,
    required this.planSurah,
    required this.master,
    required this.languageCode,
  });

  final String headerLabel;
  final PlanSurah planSurah;
  final Surah? master;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final surahLabel = master != null
        ? planSurah.displayLabel(master!, languageCode)
        : 'Surah ${planSurah.surahId}';
    final arabicName = master?.arabicName ?? '';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        gradient: AppColors.sheetGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headerLabel.toUpperCase(),
            style: AppTextStyles.prayerLabel.copyWith(
              color: AppColors.white.withValues(alpha: 0.88),
            ),
          ),
          const SizedBox(height: 4),
          Text(surahLabel, style: AppTextStyles.sheetSurahName),
          if (arabicName.isNotEmpty) ...[
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  arabicName,
                  style: AppTextStyles.arabicSecondary.copyWith(
                    color: AppColors.white.withValues(alpha: 0.92),
                    fontSize: 22,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
