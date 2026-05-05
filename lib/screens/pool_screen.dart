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
import '../widgets/common/empty_state.dart';
import '../widgets/pool/dismissible_intro_tip.dart';
import '../widgets/pool/pool_segment_editor_sheet.dart';

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

class _PoolBody extends ConsumerStatefulWidget {
  const _PoolBody({
    required this.pool,
    required this.surahs,
    required this.onAddSegment,
    required this.onEditSegment,
  });

  final List<SurahPoolEntry> pool;
  final List<Surah> surahs;
  final VoidCallback onAddSegment;
  final void Function(SurahPoolEntry entry) onEditSegment;

  @override
  ConsumerState<_PoolBody> createState() => _PoolBodyState();
}

class _PoolBodyState extends ConsumerState<_PoolBody> {
  final Set<int> _busyIds = {};
  late Map<int, Surah> _masterById;

  @override
  void initState() {
    super.initState();
    _masterById = {for (final s in widget.surahs) s.id: s};
  }

  @override
  void didUpdateWidget(_PoolBody old) {
    super.didUpdateWidget(old);
    if (old.surahs != widget.surahs) {
      _masterById = {for (final s in widget.surahs) s.id: s};
    }
  }

  Future<void> _toggle(SurahPoolEntry entry, bool enabled) async {
    setState(() => _busyIds.add(entry.id));
    try {
      await setPoolEntryEnabled(ref, entry, enabled);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context)!.hifdhToggleErrorSnackbar('$e')),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busyIds.remove(entry.id));
    }
  }

  Future<void> _confirmRemove(SurahPoolEntry entry) async {
    final master = _masterById[entry.surahId];
    final lang = Localizations.localeOf(context).languageCode;
    final label = master != null
        ? entry.displayLabel(master, lang)
        : 'Surah ${entry.surahId}';

    final ok = await showAppAlertDialog<bool>(
      context,
      title: Text(S.of(context)!.hifdhRemoveDialogTitle),
      content: Text(S.of(context)!.hifdhRemoveDialogContent(label)),
      actions: (dialogContext) {
        final loc = S.of(dialogContext)!;
        final scheme = Theme.of(dialogContext).colorScheme;
        return [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(loc.dialogCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: scheme.error),
            child: Text(loc.dialogRemove),
          ),
        ];
      },
    );
    if (ok != true || !mounted) return;

    setState(() => _busyIds.add(entry.id));
    try {
      await deletePoolSegment(ref, entry.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context)!.hifdhRemoveErrorSnackbar('$e')),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busyIds.remove(entry.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pool = widget.pool;
    final surahs = widget.surahs;

    if (surahs.isEmpty) {
      return Center(child: Text(S.of(context)!.noSurahsLoaded));
    }
    if (pool.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: EmptyState(
            variant: EmptyStateVariant.hifdhListEmpty,
            onAction: widget.onAddSegment,
          ),
        ),
      );
    }

    final scheme = Theme.of(context).colorScheme;

    return ListView.separated(
      // Extra bottom padding clears the FAB: extended FAB height (56) + margin × 2.
      padding: const EdgeInsets.fromLTRB(
        18,
        12,
        18,
        kFloatingActionButtonMargin * 2 + 56,
      ),
      itemCount: pool.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final entry = pool[i];
        final master = _masterById[entry.surahId];
        final lang = Localizations.localeOf(context).languageCode;
        final latinName =
            master?.localizedName(lang) ?? 'Surah ${entry.surahId}';
        final ayahRange = _compactAyahRange(entry);
        final busy = _busyIds.contains(entry.id);
        final paused = !entry.enabled;

        final nameAlpha = paused ? 0.52 : 1.0;
        final parenAlpha = paused ? 0.38 : 0.42;
        final arabicAlpha = paused ? 0.55 : 0.88;
        final ayahAlpha = paused ? 0.38 : 0.52;

        return Card(
          clipBehavior: Clip.antiAlias,
          color: paused
              ? Color.lerp(AppColors.white, AppColors.ink3, 0.11)!
              : AppColors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 0, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppToggle(
                  value: entry.enabled,
                  onChanged: busy ? null : (v) => _toggle(entry, v),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: latinName,
                                  style: AppTextStyles.cardLabel.copyWith(
                                    color: scheme.onSurface.withValues(
                                      alpha: nameAlpha,
                                    ),
                                  ),
                                ),
                                if (master != null) ...[
                                  TextSpan(
                                    text: ' (',
                                    style: AppTextStyles.cardLabel.copyWith(
                                      color: scheme.onSurface.withValues(
                                        alpha: parenAlpha,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                    text: master.arabicName,
                                    style: AppTextStyles.arabicSecondary
                                        .copyWith(
                                          fontSize: 15,
                                          height: 1.25,
                                          color: scheme.onSurface.withValues(
                                            alpha: arabicAlpha,
                                          ),
                                        ),
                                  ),
                                  TextSpan(
                                    text: ')',
                                    style: AppTextStyles.cardLabel.copyWith(
                                      color: scheme.onSurface.withValues(
                                        alpha: parenAlpha,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (ayahRange != null) ...[
                          const SizedBox(width: 14),
                          Text(
                            ayahRange,
                            style: AppTextStyles.smallLabel.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                              color: scheme.onSurface.withValues(
                                alpha: ayahAlpha,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                AppPopupMenuButton<String>(
                  enabled: !busy,
                  onSelected: (value) {
                    if (value == 'edit') {
                      widget.onEditSegment(entry);
                    }
                    if (value == 'delete') {
                      _confirmRemove(entry);
                    }
                  },
                  itemBuilder: (ctx) {
                    final loc = S.of(ctx)!;
                    return [
                      AppPopupMenuItem(
                        value: 'edit',
                        child: Text(loc.hifdhMenuEdit),
                      ),
                      AppPopupMenuItem(
                        value: 'delete',
                        destructive: true,
                        child: Text(loc.hifdhMenuRemove),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Transient error banner shown after a bulk insert skips already-existing entries.
///
/// Not persisted — dismissed by tapping the close icon and cleared when the
/// pool screen is rebuilt from a clean state.
class _BulkSkipBanner extends StatelessWidget {
  const _BulkSkipBanner({
    required this.skippedIds,
    required this.surahs,
    required this.lang,
    required this.onDismiss,
    this.dismissTooltip,
  });

  final List<int> skippedIds;
  final List<Surah> surahs;
  final String lang;
  final VoidCallback onDismiss;
  final String? dismissTooltip;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final masterById = {for (final su in surahs) su.id: su};

    final String message;
    if (skippedIds.length == 1) {
      final master = masterById[skippedIds.first];
      final label = master?.localizedName(lang) ?? 'Surah ${skippedIds.first}';
      message = s.hifdhBulkSkippedOne(label);
    } else {
      message = s.hifdhBulkSkippedMany(skippedIds.length);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      child: Material(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 20,
                  color: scheme.onErrorContainer,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.smallLabel.copyWith(
                    color: scheme.onErrorContainer,
                    height: 1.35,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                tooltip: dismissTooltip ?? s.dismissTooltip,
                color: scheme.onErrorContainer,
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                padding: EdgeInsets.zero,
                onPressed: onDismiss,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
