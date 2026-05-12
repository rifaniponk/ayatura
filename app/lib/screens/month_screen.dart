import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../data/models/plan.dart';
import '../data/models/prayer.dart';
import '../data/models/surah.dart';
import '../l10n/app_localizations.dart';
import '../providers/providers.dart';
import '../widgets/month/no_plan_empty_layout.dart';
import '../widgets/month/day_plan_card.dart';
import '../widgets/quran_reader/quran_reader_sheet.dart';

/// Month review: browse any allowed month, see full per-prayer assignments,
/// regenerate for the viewed month, auto-scroll to today on the current month.
class MonthScreen extends ConsumerStatefulWidget {
  const MonthScreen({super.key});

  @override
  ConsumerState<MonthScreen> createState() => _MonthScreenState();
}

class _MonthScreenState extends ConsumerState<MonthScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _todayKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _monthYearLabel(BuildContext context, int year, int month) {
    final locale = Localizations.localeOf(context).languageCode;
    final monthName = DateFormat('MMMM', locale).format(DateTime(year, month));
    return '$monthName $year';
  }

  void _scrollToTodayIfNeeded() {
    final viewed = ref.read(viewedMonthProvider);
    final now = DateTime.now();
    if (viewed.month != now.month || viewed.year != now.year) return;
    final ctx = _todayKey.currentContext;
    if (ctx == null || !mounted) return;
    Scrollable.ensureVisible(
      ctx,
      alignment: 0.12,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _onRegenerate() async {
    final viewed = ref.read(viewedMonthProvider);
    if (_isPastMonth(viewed.year, viewed.month)) return;
    final ok = await ref
        .read(monthPlanProvider.notifier)
        .regenerate(month: viewed.month, year: viewed.year);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.snackbarNeedTwoSegments)),
      );
    }
  }

  Future<void> _onClearAllLocks() async {
    final viewed = ref.read(viewedMonthProvider);
    final cleared = await ref
        .read(monthPlanProvider.notifier)
        .clearLocksForMonth(year: viewed.year, month: viewed.month);
    if (!mounted) return;
    final s = S.of(context)!;
    final message = cleared == 0
        ? s.monthNoLocksToClear
        : s.monthClearedLocksSnackbar(cleared);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _toggleLock({
    required int year,
    required int month,
    required int day,
    required Prayer prayer,
  }) async {
    await ref
        .read(monthPlanProvider.notifier)
        .toggleSlotLock(year: year, month: month, day: day, prayer: prayer);
  }

  bool _allSlotsLocked(DayPlan d) {
    for (final p in Prayer.values) {
      if (!d.slotFor(p).locked) return false;
    }
    return true;
  }

  bool _isPastMonth(int year, int month) {
    final now = DateTime.now();
    return year * 12 + month < now.year * 12 + now.month;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final now = DateTime.now();
    final viewed = ref.watch(viewedMonthProvider);
    final planAsync = ref.watch(
      monthPlanByYearMonthProvider((year: viewed.year, month: viewed.month)),
    );
    final plan = planAsync.when(
      skipLoadingOnReload: true,
      data: (p) => p,
      loading: () => planAsync.value,
      error: (_, _) => planAsync.value,
    );
    final effective = plan;
    final busy = ref.watch(monthPlanRegenerateBusyProvider);
    final canRegenerateForViewedMonth = !_isPastMonth(
      viewed.year,
      viewed.month,
    );
    final prevMonth = DateTime(viewed.year, viewed.month - 1);
    final prevMonthHasPlanAsync = ref.watch(
      monthPlanExistsByYearMonthProvider((
        year: prevMonth.year,
        month: prevMonth.month,
      )),
    );
    final prevMonthHasPlan = prevMonthHasPlanAsync.maybeWhen(
      data: (hasPlan) => hasPlan,
      orElse: () => false,
    );

    ref.listen(viewedMonthProvider, (previous, next) {
      if (previous != null && previous != next) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _scrollController.hasClients) {
            _scrollController.jumpTo(0);
          }
        });
      }
    });

    ref.listen(navIndexProvider, (previous, next) {
      if (next == 1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _scrollToTodayIfNeeded();
        });
      }
    });

    final surahsAsync = ref.watch(surahsAsyncProvider);

    final daysInMonth = DateTime(viewed.year, viewed.month + 1, 0).day;
    final monthYearStr = _monthYearLabel(context, viewed.year, viewed.month);
    final navCenter = s.monthNavYearDays(monthYearStr, daysInMonth);

    final Widget body;
    if (planAsync.hasError && plan == null) {
      body = Center(child: Text(s.errorGeneric('${planAsync.error}')));
    } else if (planAsync.isLoading && plan == null) {
      body = const Center(child: CircularProgressIndicator());
    } else if (effective == null) {
      body = NoPlanEmptyLayout(
        title: s.monthNoPlanTitle(monthYearStr),
        subtitle: canRegenerateForViewedMonth
            ? s.monthNoPlanSubtitle
            : s.monthNoPlanPastSubtitle,
        createPlanLabel: canRegenerateForViewedMonth
            ? s.monthRegeneratePlanFor(monthYearStr)
            : null,
        onCreatePlan: canRegenerateForViewedMonth ? _onRegenerate : null,
        createPlanEnabled: !busy,
      );
    } else {
      final masterList = surahsAsync.maybeWhen(
        data: (list) => list,
        orElse: () => const <Surah>[],
      );
      final masterById = {for (final x in masterList) x.id: x};
      final visibleDays = effective.days
          .where((d) => d.prayers.values.any((slot) => slot.surahs.isNotEmpty))
          .toList();

      body = ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
        itemCount: visibleDays.length,
        itemBuilder: (context, i) {
          final d = visibleDays[i];
          final isToday = DayPlanCard.isCalendarToday(
            viewed.year,
            viewed.month,
            d.day,
            now,
          );
          final isPast = DayPlanCard.calendarDayIsPast(
            viewed.year,
            viewed.month,
            d.day,
            now,
          );
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: DayPlanCard(
              key: isToday ? _todayKey : ValueKey('day-${d.day}'),
              dayPlan: d,
              viewedYear: viewed.year,
              viewedMonth: viewed.month,
              masterBySurahId: masterById,
              isToday: isToday,
              isPastDay: isPast,
              allSlotsLocked: _allSlotsLocked(d),
              onToggleLock: (prayer) => _toggleLock(
                year: viewed.year,
                month: viewed.month,
                day: d.day,
                prayer: prayer,
              ),
              onTapPrayer: (prayer) {
                final slot = d.slotFor(prayer);
                if (slot.surahs.isEmpty) return;
                showQuranReaderSheet(
                  context,
                  prayer: prayer,
                  slot: slot,
                  masterById: masterById,
                );
              },
            ),
          );
        },
      );
    }

    final prevMonthIsPast = _isPastMonth(prevMonth.year, prevMonth.month);
    final canPrev =
        viewedMonthCanGoPrev(viewed) && (!prevMonthIsPast || prevMonthHasPlan);
    final canNext = viewedMonthCanGoNext(viewed);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: s.monthNavPreviousMonth,
                      onPressed: canPrev
                          ? () => ref
                                .read(viewedMonthProvider.notifier)
                                .goToPrev()
                          : null,
                      icon: Icon(
                        Icons.chevron_left_rounded,
                        size: 28,
                        color: canPrev ? AppColors.green : AppColors.ink3,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        navCenter,
                        style: AppTextStyles.sectionHeadingSerif,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      tooltip: s.monthNavNextMonth,
                      onPressed: canNext
                          ? () => ref
                                .read(viewedMonthProvider.notifier)
                                .goToNext()
                          : null,
                      icon: Icon(
                        Icons.chevron_right_rounded,
                        size: 28,
                        color: canNext ? AppColors.green : AppColors.ink3,
                      ),
                    ),
                  ],
                ),
                if (effective != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        if (canRegenerateForViewedMonth)
                          OutlinedButton.icon(
                            onPressed: busy ? null : _onRegenerate,
                            icon: busy
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.green,
                                    ),
                                  )
                                : const Icon(
                                    Icons.refresh_rounded,
                                    size: 18,
                                    color: AppColors.green,
                                  ),
                            label: Text(
                              s.monthRegenerateCompact,
                              style: AppTextStyles.smallLabel.copyWith(
                                color: AppColors.green,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.green,
                              side: const BorderSide(color: AppColors.green2),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        OutlinedButton.icon(
                          onPressed: busy ? null : _onClearAllLocks,
                          icon: const Icon(
                            Icons.lock_open_rounded,
                            size: 18,
                            color: AppColors.green,
                          ),
                          label: Text(
                            s.monthClearAllLocks,
                            style: AppTextStyles.smallLabel.copyWith(
                              color: AppColors.green,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.green,
                            side: const BorderSide(color: AppColors.green2),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        Expanded(child: body),
      ],
    );
  }
}
