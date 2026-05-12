import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../data/local/app_database.dart';
import '../data/services/prayer_times_sync_service.dart';
import '../data/services/widget_sync_service.dart';
import '../l10n/app_localizations.dart';
import '../data/models/plan.dart';
import '../data/models/prayer.dart';
import '../data/models/surah.dart';
import '../data/models/surah_pool_entry.dart';
import '../providers/providers.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/month/no_plan_empty_layout.dart';
import '../widgets/quran_reader/quran_reader_sheet.dart';
import '../widgets/prayer/prayer_card.dart';

part '../widgets/home/home_body.dart';
part '../widgets/home/home_body_state.dart';
part '../widgets/home/prayer_card_state.dart';
part '../widgets/home/prayer_card_status.dart';
part '../widgets/home/week_strip.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahsAsyncProvider);
    final poolAsync = ref.watch(poolEntriesAsyncProvider);

    final s = S.of(context)!;
    return switch ((surahsAsync, poolAsync)) {
      (AsyncError(:final error), _) || (_, AsyncError(:final error)) => Center(
        child: Text(s.errorGeneric('$error')),
      ),
      (AsyncData(value: final surahs), AsyncData(value: final pool)) =>
        surahs.isEmpty
            ? Center(child: Text(s.noSurahsLoaded))
            : _HomeBody(surahs: surahs, pool: pool),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
