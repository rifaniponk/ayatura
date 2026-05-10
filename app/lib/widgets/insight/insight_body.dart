import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../data/models/hifdh_frequency_item.dart';
import '../../data/models/surah.dart';
import '../../l10n/app_localizations.dart';

class InsightBody extends StatelessWidget {
  const InsightBody({
    super.key,
    required this.frequencies,
    required this.surahs,
  });

  final List<HifdhFrequencyItem> frequencies;
  final List<Surah> surahs;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    final surahById = {for (final surah in surahs) surah.id: surah};

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text(s.insightTitle, style: AppTextStyles.sectionHeadingSerif),
        const SizedBox(height: 8),
        Text(s.insightSubtitle, style: AppTextStyles.subtitle),
        const SizedBox(height: 16),
        if (frequencies.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(s.insightEmpty, style: AppTextStyles.body),
            ),
          )
        else
          ...frequencies.map((item) {
            final surah = surahById[item.entry.surahId];
            if (surah == null) {
              return const SizedBox.shrink();
            }
            final label = item.entry.displayLabel(surah, languageCode);
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text(label, style: AppTextStyles.cardLabel),
                subtitle: Text(
                  s.insightAssignmentCount(item.assignmentCount),
                  style: AppTextStyles.meta,
                ),
                trailing: Text(
                  '${item.assignmentCount}',
                  style: AppTextStyles.sectionHeadingSerif,
                ),
              ),
            );
          }),
      ],
    );
  }
}
