import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_text_styles.dart';
import '../l10n/app_localizations.dart';
import '../data/models/plan.dart';
import '../data/models/prayer.dart';
import '../data/models/surah.dart';
import '../data/models/surah_pool_entry.dart';
import '../providers/providers.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/gradient_app_bar.dart';
import '../widgets/common/gradient_button.dart';
import '../widgets/home/quran_reader_sheet.dart';
import '../widgets/prayer/prayer_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context)!;
    final surahsAsync = ref.watch(surahsAsyncProvider);
    final poolAsync = ref.watch(poolEntriesAsyncProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _HomeGradientAppBar(),
        Expanded(
          child: switch ((surahsAsync, poolAsync)) {
            (AsyncError(:final error), _) || (_, AsyncError(:final error)) =>
              Center(child: Text(s.errorGeneric('$error'))),
            (AsyncData(value: final surahs), AsyncData(value: final pool)) =>
              surahs.isEmpty
                  ? Center(child: Text(s.noSurahsLoaded))
                  : _HomeBody(surahs: surahs, pool: pool),
            _ => const Center(child: CircularProgressIndicator()),
          },
        ),
      ],
    );
  }
}

class _HomeGradientAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  const _HomeGradientAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context)!;
    final surahsAsync = ref.watch(surahsAsyncProvider);
    final subtitle = surahsAsync.maybeWhen(
      data: (surahs) {
        if (surahs.isEmpty) return s.noSurahsLoaded;
        final poolAsync = ref.watch(poolEntriesAsyncProvider);
        return poolAsync.maybeWhen(
          data: (pool) =>
              s.appBarSubtitleChaptersPool(surahs.length, pool.length),
          orElse: () => s.appBarSubtitleChaptersLoading(surahs.length),
        );
      },
      orElse: () => null,
    );

    return GradientAppBar(
      title: s.appTitle,
      subtitle: subtitle,
      showLogo: true,
    );
  }
}

class _HomeBody extends ConsumerStatefulWidget {
  const _HomeBody({required this.surahs, required this.pool});

  final List<Surah> surahs;
  final List<SurahPoolEntry> pool;

  @override
  ConsumerState<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<_HomeBody> {
  late Map<int, Surah> _masterById;

  @override
  void initState() {
    super.initState();
    _masterById = {for (final s in widget.surahs) s.id: s};
  }

  @override
  void didUpdateWidget(_HomeBody old) {
    super.didUpdateWidget(old);
    if (old.surahs != widget.surahs) {
      _masterById = {for (final s in widget.surahs) s.id: s};
    }
  }

  Future<void> _generate() async {
    final ok = await ref.read(monthPlanProvider.notifier).regenerate();
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.snackbarNeedTwoSegments)),
      );
    }
  }

  Future<void> _toggleLock({
    required int year,
    required int month,
    required int day,
    required Prayer prayer,
    required bool currentlyLocked,
  }) async {
    await ref
        .read(monthPlanProvider.notifier)
        .toggleSlotLock(year: year, month: month, day: day, prayer: prayer);
    if (!mounted) return;
    final s = S.of(context)!;
    final message = currentlyLocked
        ? s.slotUnlockedSnackbar
        : s.slotLockedSnackbar;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final planAsync = ref.watch(monthPlanProvider);
    final plan = planAsync.when(
      skipLoadingOnReload: true,
      data: (p) => p,
      loading: () => planAsync.value,
      error: (_, _) => planAsync.value,
    );
    if (planAsync.hasError && plan == null) {
      return Center(
        child: Text(S.of(context)!.errorGeneric('${planAsync.error}')),
      );
    }
    if (planAsync.isLoading && plan == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final effective = plan?.effectiveOrNull(now);
    final selectedDay = ref.watch(selectedPlanDayProvider);
    final enabledCount = widget.pool.where((e) => e.enabled).length;

    final daysInMonth = effective != null
        ? DateTime(effective.year, effective.month + 1, 0).day
        : DateTime(now.year, now.month + 1, 0).day;
    final clampedDay = selectedDay.clamp(1, daysInMonth);

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        if (effective != null) ...[
          _DaySelectorRow(
            selectedDay: clampedDay,
            daysInMonth: daysInMonth,
            onChanged: (d) =>
                ref.read(selectedPlanDayProvider.notifier).setDay(d),
          ),
          const SizedBox(height: 16),
          ...Prayer.values.map((prayer) {
            final slot =
                effective.planForDay(clampedDay)?.slotFor(prayer) ??
                PrayerSlot();
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PrayerCard(
                prayer: prayer,
                slot: slot,
                masterBySurahId: _masterById,
                onToggleLock: () => _toggleLock(
                  year: effective.year,
                  month: effective.month,
                  day: clampedDay,
                  prayer: prayer,
                  currentlyLocked: slot.locked,
                ),
                onTap: slot.surahs.isEmpty
                    ? null
                    : () => showQuranReaderSheet(
                        context,
                        prayer: prayer,
                        slot: slot,
                        masterById: _masterById,
                      ),
              ),
            );
          }),
          const SizedBox(height: 8),
          GradientButton(
            label: S.of(context)!.regeneratePlan,
            icon: Icons.auto_awesome_rounded,
            onPressed: enabledCount >= 2 ? _generate : null,
            enabled: enabledCount >= 2,
          ),
        ] else ...[
          if (enabledCount < 2)
            EmptyState(
              variant: EmptyStateVariant.hifdhListTooSmall,
              onAction: () => ref.read(navIndexProvider.notifier).setIndex(2),
            )
          else
            EmptyState(variant: EmptyStateVariant.noPlan, onAction: _generate),
        ],
      ],
    );
  }
}

class _DaySelectorRow extends StatelessWidget {
  const _DaySelectorRow({
    required this.selectedDay,
    required this.daysInMonth,
    required this.onChanged,
  });

  final int selectedDay;
  final int daysInMonth;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    return Row(
      children: [
        Text(s.dayLabel, style: AppTextStyles.sectionHeadingSerif),
        const SizedBox(width: 12),
        IconButton.filledTonal(
          onPressed: selectedDay > 1 ? () => onChanged(selectedDay - 1) : null,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: Text(
            s.dayOfMonth(selectedDay, daysInMonth),
            textAlign: TextAlign.center,
            style: AppTextStyles.cardLabel,
          ),
        ),
        IconButton.filledTonal(
          onPressed: selectedDay < daysInMonth
              ? () => onChanged(selectedDay + 1)
              : null,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}
