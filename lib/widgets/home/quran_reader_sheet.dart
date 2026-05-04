import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/plan.dart';
import '../../data/models/plan_surah.dart';
import '../../data/models/prayer.dart';
import '../../data/models/surah.dart';
import '../../data/services/quran_verse_service.dart';
import '../../providers/providers.dart';

Future<void> showQuranReaderSheet(
  BuildContext context, {
  required Prayer prayer,
  required PrayerSlot slot,
  required Map<int, Surah> masterById,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.92,
      child: _QuranReaderSheet(
        prayer: prayer,
        slot: slot,
        masterById: masterById,
      ),
    ),
  );
}

class _QuranReaderSheet extends ConsumerStatefulWidget {
  const _QuranReaderSheet({
    required this.prayer,
    required this.slot,
    required this.masterById,
  });

  final Prayer prayer;
  final PrayerSlot slot;
  final Map<int, Surah> masterById;

  @override
  ConsumerState<_QuranReaderSheet> createState() => _QuranReaderSheetState();
}

class _QuranReaderSheetState extends ConsumerState<_QuranReaderSheet>
    with SingleTickerProviderStateMixin {
  static const _englishTranslationId = 20;
  static const _indonesianTranslationId = 33;

  late final TabController _tabController;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.slot.surahs.length, vsync: this)
          ..addListener(() {
            if (_tabController.indexIsChanging) return;
            if (_currentTab != _tabController.index) {
              setState(() => _currentTab = _tabController.index);
            }
          });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = ref.watch(localeProvider).languageCode;
    final slot = widget.slot;
    final currentPlanSurah = slot.surahs[_currentTab];

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.ink3.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 12),
          _ReaderHeader(
            prayer: widget.prayer,
            planSurah: currentPlanSurah,
            master: widget.masterById[currentPlanSurah.surahId],
            languageCode: languageCode,
          ),
          if (slot.surahs.length > 1) ...[
            const SizedBox(height: 8),
            _ReaderTabs(
              tabController: _tabController,
              surahs: slot.surahs,
              masterById: widget.masterById,
              languageCode: languageCode,
            ),
          ],
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: slot.surahs
                  .map(
                    (planSurah) => _VersesTab(
                      request: QuranVerseRequest(
                        surahId: planSurah.surahId,
                        startAyah: planSurah.startAyah,
                        endAyah: planSurah.endAyah,
                        translationId: languageCode == 'id'
                            ? _indonesianTranslationId
                            : _englishTranslationId,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ReaderHeader extends StatelessWidget {
  const _ReaderHeader({
    required this.prayer,
    required this.planSurah,
    required this.master,
    required this.languageCode,
  });

  final Prayer prayer;
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
            prayer.label.toUpperCase(),
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

class _VersesTab extends ConsumerWidget {
  const _VersesTab({required this.request});

  final QuranVerseRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = ref.watch(localeProvider).languageCode;
    final asyncVerses = ref.watch(quranVersesProvider(request));
    return asyncVerses.when(
      data: (verses) {
        if (verses.isEmpty) {
          return Center(child: Text(_ReaderCopy.noVerses(languageCode)));
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          itemCount: verses.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) => _AyahTile(verse: verses[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => Center(
        child: TextButton.icon(
          onPressed: () => ref.refresh(quranVersesProvider(request)),
          icon: const Icon(Icons.refresh_rounded),
          label: Text(_ReaderCopy.loadError(languageCode)),
        ),
      ),
    );
  }
}

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

abstract final class _ReaderCopy {
  static bool _isId(String code) => code == 'id';

  static String noVerses(String code) =>
      _isId(code) ? 'Ayat tidak ditemukan.' : 'No verses found.';

  static String loadError(String code) => _isId(code)
      ? 'Tidak bisa memuat ayat. Ketuk untuk mencoba lagi.'
      : 'Could not load verses. Tap to retry.';
}
