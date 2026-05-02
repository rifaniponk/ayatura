import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_text_styles.dart';
import '../data/models/surah.dart';
import '../data/models/surah_pool_entry.dart';
import '../providers/providers.dart';
import '../widgets/empty_state.dart';
import '../widgets/gradient_app_bar.dart';

/// Memorization pool — toggle segments on/off (persisted in Drift).
class PoolScreen extends ConsumerWidget {
  const PoolScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poolAsync = ref.watch(poolEntriesAsyncProvider);
    final surahsAsync = ref.watch(surahsAsyncProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GradientAppBar(
          title: 'Pool',
          subtitle: poolAsync.maybeWhen(
            data: (p) => '${p.length} segment(s)',
            orElse: () => null,
          ),
        ),
        Expanded(
          child: switch ((poolAsync, surahsAsync)) {
            (AsyncError(:final error), _) || (_, AsyncError(:final error)) =>
              Center(child: Text('Error: $error')),
            (AsyncData(value: final pool), AsyncData(value: final surahs)) =>
              _PoolBody(pool: pool, surahs: surahs),
            _ => const Center(child: CircularProgressIndicator()),
          },
        ),
      ],
    );
  }
}

class _PoolBody extends ConsumerStatefulWidget {
  const _PoolBody({required this.pool, required this.surahs});

  final List<SurahPoolEntry> pool;
  final List<Surah> surahs;

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

  @override
  Widget build(BuildContext context) {
    final pool = widget.pool;
    final surahs = widget.surahs;

    if (surahs.isEmpty) {
      return const Center(child: Text('No surahs loaded'));
    }
    if (pool.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: EmptyState(
            variant: EmptyStateVariant.emptyPool,
            onAction: null,
          ),
        ),
      );
    }

    final scheme = Theme.of(context).colorScheme;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
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
          child: SwitchListTile.adaptive(
            title: Text(label, style: AppTextStyles.cardLabel),
            subtitle: Text(
              entry.enabled ? 'Included when generating a plan' : 'Skipped',
              style: AppTextStyles.meta,
            ),
            value: entry.enabled,
            onChanged: busy ? null : (v) => _toggle(entry, v),
            secondary: Icon(
              entry.enabled ? Icons.check_circle_rounded : Icons.pause_circle,
              color: entry.enabled
                  ? scheme.secondary
                  : scheme.onSurface.withValues(alpha: 0.4),
              size: 22,
            ),
          ),
        );
      },
    );
  }
}
