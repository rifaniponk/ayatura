import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../core/theme/app_text_styles.dart';
import '../data/models/surah.dart';
import '../data/models/surah_pool_entry.dart';
import '../providers/providers.dart';
import '../widgets/common/app_alert_dialog.dart';
import '../widgets/common/app_popup_menu_button.dart';
import '../widgets/common/app_toggle.dart';
import '../widgets/pool/hifdh_empty_hero_layout.dart';
import '../widgets/pool/dismissible_intro_tip.dart';
import '../widgets/pool/pool_segment_editor_sheet.dart';
import '../widgets/quran_reader/quran_reader_sheet.dart';

part '../widgets/pool/bulk_skip_banner.dart';
part '../widgets/pool/pool_body.dart';

/// Ayah span for partial-surah pool rows (compact, for trailing list label).
String? _compactAyahRange(SurahPoolEntry e) {
  if (e.isFullSurah) return null;
  final a = e.startAyah;
  final b = e.endAyah;
  if (a == null || b == null) return null;
  if (a == b) return '$a';
  return '$a-$b';
}

/// Hifdh list — surahs / ayat ranges for memorization; add, edit, remove; Drift.
class PoolScreen extends ConsumerStatefulWidget {
  const PoolScreen({super.key});

  @override
  ConsumerState<PoolScreen> createState() => _PoolScreenState();
}

class _PoolScreenState extends ConsumerState<PoolScreen> {
  List<int> _bulkSkippedIds = [];

  Future<void> _openEditor({SurahPoolEntry? existing}) async {
    final surahs = ref.read(surahsAsyncProvider).value;
    if (surahs == null || surahs.isEmpty || !mounted) return;
    final skipped = await showPoolSegmentEditor(
      context,
      surahs: surahs,
      existing: existing,
    );
    if (skipped != null && skipped.isNotEmpty && mounted) {
      setState(() => _bulkSkippedIds = skipped);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final poolAsync = ref.watch(poolEntriesAsyncProvider);
    final surahsAsync = ref.watch(surahsAsyncProvider);

    final fab = switch ((poolAsync, surahsAsync)) {
      (AsyncData(value: final pool), AsyncData(value: final surahs))
          when surahs.isNotEmpty && pool.isNotEmpty =>
        FloatingActionButton.extended(
          onPressed: _openEditor,
          icon: const Icon(Icons.add_rounded),
          label: Text(s.hifdhFabAdd),
        ),
      _ => null,
    };

    // Nested inside AppShell's root Scaffold so the FAB is scoped to this tab
    // only. SnackBars from _PoolBody should use ScaffoldMessenger.of(context)
    // which routes to the nearest ancestor — the inner Scaffold here.
    return Scaffold(
      floatingActionButton: fab,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: switch ((poolAsync, surahsAsync)) {
              (AsyncError(:final error), _) || (_, AsyncError(:final error)) =>
                Center(child: Text(s.errorGeneric('$error'))),
              (AsyncData(value: final pool), AsyncData(value: final surahs)) =>
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (pool.isNotEmpty)
                      DismissibleIntroTip(
                        storageKey: kDismissibleIntroTipHifdhKey,
                        message: s.hifdhIntroBanner,
                        dismissTooltip: s.dismissTooltip,
                      ),
                    if (_bulkSkippedIds.isNotEmpty)
                      _BulkSkipBanner(
                        skippedIds: _bulkSkippedIds,
                        surahs: surahs,
                        lang: Localizations.localeOf(context).languageCode,
                        dismissTooltip: s.dismissTooltip,
                        onDismiss: () => setState(() => _bulkSkippedIds = []),
                      ),
                    Expanded(
                      child: _PoolBody(
                        pool: pool,
                        surahs: surahs,
                        onAddSegment: _openEditor,
                        onEditSegment: (e) => _openEditor(existing: e),
                      ),
                    ),
                  ],
                ),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
    );
  }
}
