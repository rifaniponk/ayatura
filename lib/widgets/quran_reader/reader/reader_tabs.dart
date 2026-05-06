part of '../quran_reader_sheet.dart';

class _ReaderTabs extends StatelessWidget {
  const _ReaderTabs({
    required this.tabController,
    required this.surahs,
    required this.masterById,
    required this.languageCode,
  });

  final TabController tabController;
  final List<PlanSurah> surahs;
  final Map<int, Surah> masterById;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      labelColor: AppColors.green,
      unselectedLabelColor: AppColors.ink3,
      indicatorColor: AppColors.green2,
      dividerColor: Colors.transparent,
      tabs: surahs.map((ps) {
        final master = masterById[ps.surahId];
        final label = master != null
            ? ps.displayLabel(master, languageCode)
            : 'Surah ${ps.surahId}';
        return Tab(text: label);
      }).toList(),
    );
  }
}
