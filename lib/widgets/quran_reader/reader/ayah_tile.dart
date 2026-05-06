part of '../quran_reader_sheet.dart';

class _AyahTile extends StatelessWidget {
  const _AyahTile({required this.verse});

  final QuranVerse verse;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.greenOverlay06),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  gradient: AppColors.buttonGradient,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${verse.verseNumber}',
                  style: AppTextStyles.meta.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              verse.arabicText,
              textAlign: TextAlign.right,
              style: AppTextStyles.arabicBody.copyWith(
                color: AppColors.ink,
                fontSize: 30,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            verse.translation,
            style: AppTextStyles.body.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
