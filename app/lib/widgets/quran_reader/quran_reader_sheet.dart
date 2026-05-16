import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/plan_surah.dart';
import '../../data/models/prayer.dart';
import '../../data/models/prayer_slot.dart';
import '../../data/models/surah_pool_entry.dart';
import '../../data/models/quran_verse.dart';
import '../../data/models/surah.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';

part 'reader/ayah_tile.dart';
part 'reader/reader_header.dart';
part 'reader/reader_tabs.dart';
part 'reader/verses_tab.dart';

String localizedPrayerName(S s, Prayer prayer) => switch (prayer) {
  Prayer.fajr => s.prayerFajr,
  Prayer.dhuhr => s.prayerDhuhr,
  Prayer.asr => s.prayerAsr,
  Prayer.maghrib => s.prayerMaghrib,
  Prayer.isha => s.prayerIsha,
};

Future<void> showQuranReaderSheet(
  BuildContext context, {
  required String headerLabel,
  required List<PlanSurah> surahs,
  required Map<int, Surah> masterById,
}) {
  if (surahs.isEmpty) return Future.value();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.92,
      child: _QuranReaderSheet(
        headerLabel: headerLabel,
        surahs: surahs,
        masterById: masterById,
      ),
    ),
  );
}

Future<void> showQuranReaderForPrayerSlot(
  BuildContext context, {
  required Prayer prayer,
  required PrayerSlot slot,
  required Map<int, Surah> masterById,
}) {
  final s = S.of(context)!;
  return showQuranReaderSheet(
    context,
    headerLabel: localizedPrayerName(s, prayer),
    surahs: slot.surahs,
    masterById: masterById,
  );
}

Future<void> showQuranReaderForPoolEntry(
  BuildContext context, {
  required SurahPoolEntry entry,
  required Map<int, Surah> masterById,
}) {
  final s = S.of(context)!;
  return showQuranReaderSheet(
    context,
    headerLabel: s.hifdhScreenTitle,
    surahs: [PlanSurah.fromSurahPoolEntry(entry)],
    masterById: masterById,
  );
}

class _QuranReaderSheet extends ConsumerStatefulWidget {
  const _QuranReaderSheet({
    required this.headerLabel,
    required this.surahs,
    required this.masterById,
  });

  final String headerLabel;
  final List<PlanSurah> surahs;
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
    _tabController = TabController(length: widget.surahs.length, vsync: this)
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
    final s = S.of(context)!;
    final languageCode = ref.watch(localeProvider).languageCode;
    final surahs = widget.surahs;
    final currentPlanSurah = surahs[_currentTab];

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
            headerLabel: widget.headerLabel,
            planSurah: currentPlanSurah,
            master: widget.masterById[currentPlanSurah.surahId],
            languageCode: languageCode,
          ),
          if (surahs.length > 1) ...[
            const SizedBox(height: 8),
            _ReaderTabs(
              tabController: _tabController,
              surahs: surahs,
              masterById: widget.masterById,
              languageCode: languageCode,
            ),
          ],
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: surahs
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Text(
              s.readerSourceAttribution,
              textAlign: TextAlign.center,
              style: AppTextStyles.meta.copyWith(
                color: AppColors.ink3,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
