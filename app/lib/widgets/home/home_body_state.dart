part of '../../screens/home_screen.dart';

class _HomeBodyState extends ConsumerState<_HomeBody> {
  static const double _dayTileWidth = 50;
  static const double _dayTileGap = 14;
  static const Duration _countdownRefreshInterval = Duration(seconds: 20);

  late Map<int, Surah> _masterById;
  final ScrollController _weekStripController = ScrollController();
  final ScrollController _listController = ScrollController();
  final Map<Prayer, GlobalKey> _prayerKeys = {
    for (final prayer in Prayer.values) prayer: GlobalKey(),
  };
  late DateTime _clockNow;
  Timer? _clockTimer;
  int? _visibleWeekStripYear;
  int? _visibleWeekStripMonth;
  int? _visibleWeekStripDay;
  int? _lastCenteredWeekStripYear;
  int? _lastCenteredWeekStripMonth;
  int? _lastCenteredWeekStripDay;
  bool _shouldScrollSelectedDay = true;
  bool _shouldScrollToCurrentPrayer = true;

  @override
  void initState() {
    super.initState();
    _masterById = {for (final s in widget.surahs) s.id: s};
    _clockNow = DateTime.now();
    _clockTimer = Timer.periodic(_countdownRefreshInterval, (_) {
      if (!mounted) return;
      setState(() {
        _clockNow = DateTime.now();
      });
    });
  }

  @override
  void didUpdateWidget(_HomeBody old) {
    super.didUpdateWidget(old);
    if (old.surahs != widget.surahs) {
      _masterById = {for (final s in widget.surahs) s.id: s};
    }
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _weekStripController.dispose();
    _listController.dispose();
    super.dispose();
  }

  void _scheduleSelectedDayScroll({
    required int year,
    required int month,
    required int day,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_weekStripController.hasClients) return;
      final itemExtent = _dayTileWidth + _dayTileGap;
      final targetCenter = (day - 1) * itemExtent + (_dayTileWidth / 2);
      final viewportCenter =
          _weekStripController.position.viewportDimension / 2;
      final rawOffset = targetCenter - viewportCenter;
      final maxOffset = _weekStripController.position.maxScrollExtent;
      final nextOffset = rawOffset.clamp(0.0, maxOffset);
      if ((_weekStripController.offset - nextOffset).abs() < 1) return;
      _weekStripController.animateTo(
        nextOffset,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    });
    _lastCenteredWeekStripYear = year;
    _lastCenteredWeekStripMonth = month;
    _lastCenteredWeekStripDay = day;
    _shouldScrollSelectedDay = false;
  }

  void _restoreVisibleSelectedDay() {
    final year = _visibleWeekStripYear;
    final month = _visibleWeekStripMonth;
    final day = _visibleWeekStripDay;
    if (year == null || month == null || day == null) return;
    _scheduleSelectedDayScroll(year: year, month: month, day: day);
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

  Future<void> _forceRefreshPrayerTimes() async {
    await ref.read(seededDatabaseProvider.future);
    final db = ref.read(appDatabaseProvider);
    await PrayerTimesSyncService(db).syncAndLoadToday(forceRefresh: true);
    ref.invalidate(prayerTimesSyncProvider);
    await WidgetSyncService.syncFromWidgetRef(ref);
    if (mounted) {
      setState(() {
        _clockNow = DateTime.now();
        _shouldScrollSelectedDay = true;
        _shouldScrollToCurrentPrayer = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = _clockNow;
    final prayerTimesAsync = ref.watch(prayerTimesSyncProvider);
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
    final availableDays = effective == null
        ? <int>{}
        : effective.days
              .where(
                (d) => d.prayers.values.any((slot) => slot.surahs.isNotEmpty),
              )
              .map((d) => d.day)
              .toSet();
    final resolvedDay = availableDays.isEmpty
        ? clampedDay
        : (availableDays.contains(clampedDay)
              ? clampedDay
              : (() {
                  final sorted = availableDays.toList()..sort();
                  for (final day in sorted) {
                    if (day >= clampedDay) return day;
                  }
                  return sorted.first;
                })());
    if (resolvedDay != clampedDay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(selectedPlanDayProvider.notifier).setDay(resolvedDay);
      });
    }
    final selectedDate = effective != null
        ? DateTime(effective.year, effective.month, resolvedDay)
        : DateTime(now.year, now.month, resolvedDay);
    if (effective != null) {
      _visibleWeekStripYear = effective.year;
      _visibleWeekStripMonth = effective.month;
      _visibleWeekStripDay = resolvedDay;
      final selectedDayChanged =
          _lastCenteredWeekStripYear != effective.year ||
          _lastCenteredWeekStripMonth != effective.month ||
          _lastCenteredWeekStripDay != resolvedDay;
      if (_shouldScrollSelectedDay || selectedDayChanged) {
        _scheduleSelectedDayScroll(
          year: effective.year,
          month: effective.month,
          day: resolvedDay,
        );
      }
    }
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final titleDate = DateFormat(
      'EEEE, d MMMM',
      localeTag,
    ).format(selectedDate);
    final isSelectedToday =
        selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
    final todayDateOnly = DateTime(now.year, now.month, now.day);
    final selectedDateOnly = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final isViewingPastDay = selectedDateOnly.isBefore(todayDateOnly);
    final prayerTimesResult = prayerTimesAsync.asData?.value;
    final prayerTimesToday = isSelectedToday ? prayerTimesResult?.today : null;
    final locationName = isSelectedToday
        ? prayerTimesResult?.locationName
        : null;
    final cardState = _PrayerCardState.from(
      now: now,
      todayRow: prayerTimesToday,
      tomorrowRow: prayerTimesResult?.tomorrow,
    );

    void scrollToCurrentPrayer() {
      if (!isSelectedToday) return;
      final currentPrayer = cardState.currentPrayer;
      if (currentPrayer == null) return;
      final targetKey = _prayerKeys[currentPrayer];
      final targetContext = targetKey?.currentContext;
      if (targetContext == null || !_listController.hasClients) return;
      Scrollable.ensureVisible(
        targetContext,
        alignment: 0.2,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_shouldScrollToCurrentPrayer) return;
      _shouldScrollToCurrentPrayer = false;
      scrollToCurrentPrayer();
    });

    ref.listen(navIndexProvider, (previous, next) {
      if (next == 0) {
        _restoreVisibleSelectedDay();
        _shouldScrollToCurrentPrayer = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || !_shouldScrollToCurrentPrayer) return;
          _shouldScrollToCurrentPrayer = false;
          scrollToCurrentPrayer();
        });
      }
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        const listPadding = EdgeInsets.fromLTRB(16, 14, 16, 18);
        final emptyStateHeight = constraints.maxHeight > listPadding.vertical
            ? constraints.maxHeight - listPadding.vertical
            : constraints.maxHeight;

        return RefreshIndicator(
          onRefresh: _forceRefreshPrayerTimes,
          child: ListView(
            controller: _listController,
            padding: listPadding,
            children: [
              if (effective != null) ...[
                _WeekStrip(
                  controller: _weekStripController,
                  year: effective.year,
                  month: effective.month,
                  selectedDay: resolvedDay,
                  daysInMonth: daysInMonth,
                  today: now,
                  availableDays: availableDays,
                  onChanged: (d) =>
                      ref.read(selectedPlanDayProvider.notifier).setDay(d),
                ),
                const SizedBox(height: 14),
                if (isSelectedToday)
                  Text(
                    S.of(context)!.monthTodayChip,
                    style: AppTextStyles.sectionEyebrow.copyWith(
                      color: AppColors.ink3,
                      letterSpacing: 1.5,
                    ),
                  ),
                if (isSelectedToday) const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        titleDate,
                        style: AppTextStyles.sectionHeadingSerif.copyWith(
                          color: AppColors.green,
                          fontSize: 24,
                          height: 1.05,
                        ),
                      ),
                    ),
                    if (locationName != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.greenOverlay06,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.green2,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              locationName,
                              style: AppTextStyles.smallLabel.copyWith(
                                color: AppColors.ink3,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                ...Prayer.values.map((prayer) {
                  final slot =
                      effective.planForDay(resolvedDay)?.slotFor(prayer) ??
                      PrayerSlot();
                  final status = isViewingPastDay
                      ? const _PrayerCardStatus(
                          highlight: PrayerCardHighlight.past,
                        )
                      : cardState.statusFor(prayer, S.of(context)!);
                  return Padding(
                    key: _prayerKeys[prayer],
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PrayerCard(
                      prayer: prayer,
                      slot: slot,
                      masterBySurahId: _masterById,
                      prayerTime: cardState.displayTimeFor(prayer),
                      highlight: status.highlight,
                      badgeLabel: status.badge,
                      trailingMeta: status.trailing,
                      subtitle: status.subtitle,
                      progress: status.progress,
                      progressLeftLabel: status.progressLeft,
                      progressRightLabel: status.progressRight,
                      onToggleLock: () => _toggleLock(
                        year: effective.year,
                        month: effective.month,
                        day: resolvedDay,
                        prayer: prayer,
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
              ] else
                SizedBox(
                  height: emptyStateHeight,
                  child: Center(
                    child: enabledCount < 2
                        ? EmptyState(
                            variant: EmptyStateVariant.hifdhListTooSmall,
                            onAction: () =>
                                ref.read(navIndexProvider.notifier).setIndex(2),
                          )
                        : EmptyState(
                            variant: EmptyStateVariant.noPlan,
                            onAction: () =>
                                ref.read(navIndexProvider.notifier).setIndex(1),
                          ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
