import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_text_styles.dart';
import '../data/models/surah.dart';
import '../data/models/surah_pool_entry.dart';
import '../providers/providers.dart';
import '../widgets/empty_state.dart';
import '../widgets/gradient_app_bar.dart';
import '../widgets/pool_segment_editor_sheet.dart';

/// Hifdh list — surahs / ayat ranges for memorization; add, edit, remove; Drift.
class PoolScreen extends ConsumerStatefulWidget {
  const PoolScreen({super.key});

  @override
  ConsumerState<PoolScreen> createState() => _PoolScreenState();
}

class _PoolScreenState extends ConsumerState<PoolScreen> {
  void _openEditor({SurahPoolEntry? existing}) {
    final surahsAsync = ref.read(surahsAsyncProvider);
    surahsAsync.whenData((surahs) {
      if (surahs.isEmpty || !mounted) return;
      showPoolSegmentEditor(context, surahs: surahs, existing: existing);
    });
  }

  @override
  Widget build(BuildContext context) {
    final poolAsync = ref.watch(poolEntriesAsyncProvider);
    final surahsAsync = ref.watch(surahsAsyncProvider);

    final fab = surahsAsync.maybeWhen(
      data: (surahs) => surahs.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _openEditor,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add'),
            ),
      orElse: () => null,
    );

    // Nested inside AppShell's root Scaffold so the FAB is scoped to this tab
    // only. SnackBars from _PoolBody should use ScaffoldMessenger.of(context)
    // which routes to the nearest ancestor — the inner Scaffold here.
    return Scaffold(
      floatingActionButton: fab,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GradientAppBar(
            title: 'Hifdh',
            subtitle: poolAsync.maybeWhen(
              data: (p) =>
                  p.isEmpty ? 'Nothing listed yet' : '${p.length} added',
              orElse: () => '…',
            ),
            subtitleCaption:
                'Hifdh is Quran memorization. What you list here is used '
                'when you build your monthly plan.',
          ),
          Expanded(
            child: switch ((poolAsync, surahsAsync)) {
              (AsyncError(:final error), _) || (_, AsyncError(:final error)) =>
                Center(child: Text('Error: $error')),
              (AsyncData(value: final pool), AsyncData(value: final surahs)) =>
                _PoolBody(
                  pool: pool,
                  surahs: surahs,
                  onAddSegment: _openEditor,
                  onEditSegment: (e) => _openEditor(existing: e),
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      }
    } finally {
      if (mounted) setState(() => _busyIds.remove(entry.id));
    }
  }

  Future<void> _confirmRemove(SurahPoolEntry entry) async {
    final master = _masterById[entry.surahId];
    final label = master != null
        ? entry.displayLabel(master)
        : 'Surah ${entry.surahId}';

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove from hifdh list?'),
        content: Text(
          '$label will be removed from your hifdh list. '
          'Your current month plan will be cleared until you generate a new one.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    setState(() => _busyIds.add(entry.id));
    try {
      await deletePoolSegment(ref, entry.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not remove: $e')));
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
      return const Center(child: Text('No surahs loaded'));
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
        final label = master != null
            ? entry.displayLabel(master)
            : 'Surah ${entry.surahId}';
        final busy = _busyIds.contains(entry.id);

        return Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 0, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    entry.enabled
                        ? Icons.check_circle_rounded
                        : Icons.pause_circle,
                    color: entry.enabled
                        ? scheme.secondary
                        : scheme.onSurface.withValues(alpha: 0.4),
                    size: 22,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: AppTextStyles.cardLabel),
                      Text(
                        entry.enabled
                            ? 'Included when you generate a plan'
                            : 'Paused — not used in plans',
                        style: AppTextStyles.meta,
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: entry.enabled,
                  onChanged: busy ? null : (v) => _toggle(entry, v),
                ),
                PopupMenuButton<String>(
                  enabled: !busy,
                  onSelected: (value) {
                    if (value == 'edit') widget.onEditSegment(entry);
                    if (value == 'delete') _confirmRemove(entry);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Remove')),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
