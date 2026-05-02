import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../data/models/surah.dart';
import '../data/models/surah_pool_entry.dart';
import '../providers/providers.dart';
import '../widgets/empty_state.dart';
import '../widgets/gradient_app_bar.dart';

/// Memorization pool — read-only list until toggles / add flow land.
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
          child: poolAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (pool) => surahsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (surahs) => _PoolBody(pool: pool, surahs: surahs),
            ),
          ),
        ),
      ],
    );
  }
}

class _PoolBody extends StatelessWidget {
  const _PoolBody({required this.pool, required this.surahs});

  final List<SurahPoolEntry> pool;
  final List<Surah> surahs;

  @override
  Widget build(BuildContext context) {
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

    final masterById = {for (final s in surahs) s.id: s};

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      itemCount: pool.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final entry = pool[i];
        final master = masterById[entry.surahId];
        final label = master != null
            ? entry.displayLabel(master)
            : 'Surah ${entry.surahId}';
        final meta = entry.enabled ? 'Enabled' : 'Disabled';
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTextStyles.cardLabel),
                    const SizedBox(height: 4),
                    Text(meta, style: AppTextStyles.meta),
                  ],
                ),
              ),
              Icon(
                entry.enabled ? Icons.check_circle_rounded : Icons.pause_circle,
                color: entry.enabled ? AppColors.green2 : AppColors.ink3,
                size: 22,
              ),
            ],
          ),
        );
      },
    );
  }
}
