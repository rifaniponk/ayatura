part of '../../screens/home_screen.dart';

class _HomeBodyState extends ConsumerState<_HomeBody> {
  static const double _dayTileWidth = 50;
  static const double _dayTileGap = 14;
  static const Duration _countdownRefreshInterval = Duration(seconds: 20);

  /// Number of calendar days in [month] of [year] (28 to 31).
  ///
  /// Uses `DateTime(year, month + 1, 0)`, where day 0 rolls back to the last
  /// day of [month].
  static int calendarDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  /// Five dates on the strip. Usually [now] is the center and neighbors are
  /// calendar offsets -2, -1, +1, +2. When the plan is for another month than
  /// [now], we show the first five days of that plan month instead.
  static List<DateTime> homeWeekStripFiveCalendarDates({
    required int planYear,
    required int planMonth,
    required DateTime now,
  }) {
    final daysInMonth = calendarDaysInMonth(planYear, planMonth);
    if (daysInMonth <= 0) return const [];
    final sameCalendarMonth = planYear == now.year && planMonth == now.month;
    if (!sameCalendarMonth) {
      return [
        for (var d = 1; d <= 5 && d <= daysInMonth; d++)
          DateTime(planYear, planMonth, d),
      ];
    }
    final center = DateTime(now.year, now.month, now.day);
    return [for (var i = -2; i <= 2; i++) center.add(Duration(days: i))];
  }

  late Map<int, Surah> _masterById;
  final ScrollController _listController = ScrollController();
  final Map<Prayer, GlobalKey> _prayerKeys = {
    for (final prayer in Prayer.values) prayer: GlobalKey(),
  };
  late DateTime _clockNow;
  Timer? _clockTimer;
  bool _shouldScrollToCurrentPrayer = true;

  @override
  void initState() {
    super.initState();
    _masterById = {for (final s in widget.surahs) s.id: s};
    _clockNow = appClockNow();
    _clockTimer = Timer.periodic(_countdownRefreshInterval, (_) {
      if (!mounted) return;
      setState(() {
        _clockNow = appClockNow();
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
    _listController.dispose();
    super.dispose();
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

  Future<void> _createPlanForCurrentMonth() async {
    final ok = await ref.read(monthPlanProvider.notifier).regenerate();
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.snackbarNeedTwoSegments)),
      );
    }
  }

  Future<void> _forceRefreshPrayerTimes() async {
    await ref.read(seededDatabaseProvider.future);
    final db = ref.read(appDatabaseProvider);
    await PrayerTimesSyncService(db).syncAndLoadToday(forceRefresh: true);
    ref.invalidate(prayerTimesSyncProvider);
    await WidgetSyncService.syncFromWidgetRef(ref);
    if (mounted) {
      setState(() {
        _clockNow = appClockNow();
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
    final s = S.of(context)!;
    final selectedDay = ref.watch(selectedPlanDayProvider);
    final enabledCount = widget.pool.where((e) => e.enabled).length;
    final planRegenerateBusy = ref.watch(monthPlanRegenerateBusyProvider);

    // Plan month when we have a plan, otherwise the clock month (empty state).
    final daysInMonth = effective != null
        ? calendarDaysInMonth(effective.year, effective.month)
        : calendarDaysInMonth(now.year, now.month);
    final viewingCurrentCalendarMonth =
        effective != null &&
        effective.year == now.year &&
        effective.month == now.month;
    final pickMin = viewingCurrentCalendarMonth
        ? (now.day - 2).clamp(1, daysInMonth)
        : 1;
    final pickMax = viewingCurrentCalendarMonth
        ? (now.day + 2).clamp(1, daysInMonth)
        : daysInMonth;
    final clampedDay = viewingCurrentCalendarMonth
        ? selectedDay.clamp(1, daysInMonth).clamp(pickMin, pickMax)
        : selectedDay.clamp(1, daysInMonth);
    final availableDays = effective == null
        ? <int>{}
        : effective.days
              .where(
                (d) => d.prayers.values.any((slot) => slot.surahs.isNotEmpty),
              )
              .map((d) => d.day)
              .toSet();
    final resolveCandidates = viewingCurrentCalendarMonth
        ? availableDays.where((d) => d >= pickMin && d <= pickMax).toSet()
        : availableDays;
    final tapEnabledDays = resolveCandidates;
    final int resolvedDay;
    if (resolveCandidates.isNotEmpty) {
      resolvedDay = resolveCandidates.contains(clampedDay)
          ? clampedDay
          : (() {
              final sorted = resolveCandidates.toList()..sort();
              for (final day in sorted) {
                if (day >= clampedDay) return day;
              }
              return sorted.first;
            })();
    } else if (viewingCurrentCalendarMonth) {
      resolvedDay = clampedDay;
    } else if (availableDays.isEmpty) {
      resolvedDay = clampedDay;
    } else {
      resolvedDay = availableDays.contains(clampedDay)
          ? clampedDay
          : (() {
              final sorted = availableDays.toList()..sort();
              for (final day in sorted) {
                if (day >= clampedDay) return day;
              }
              return sorted.first;
            })();
    }
    if (resolvedDay != selectedDay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(selectedPlanDayProvider.notifier).setDay(resolvedDay);
      });
    }
    final selectedDate = effective != null
        ? DateTime(effective.year, effective.month, resolvedDay)
        : DateTime(now.year, now.month, resolvedDay);
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
            clipBehavior: Clip.none,
            padding: listPadding,
            children: [
              if (effective != null) ...[
                _WeekStrip(
                  planYear: effective.year,
                  planMonth: effective.month,
                  stripDates: _HomeBodyState.homeWeekStripFiveCalendarDates(
                    planYear: effective.year,
                    planMonth: effective.month,
                    now: now,
                  ),
                  selectedDate: selectedDate,
                  today: now,
                  tapEnabledDays: tapEnabledDays,
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
                          : () => showQuranReaderForPrayerSlot(
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
                        ? HomeEmptyHeroLayout(
                            semanticLabel: s.emptyPoolTooSmallTitle,
                            title: s.emptyPoolTooSmallTitle,
                            subtitle: s.emptyPoolTooSmallSubtitle,
                            primaryLabel: s.emptyPoolTooSmallAction,
                            onPrimary: () =>
                                ref.read(navIndexProvider.notifier).setIndex(2),
                            secondaryLabel: s.homeNoPlanLearnHow,
                            onSecondary: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const AboutScreen(),
                                ),
                              );
                            },
                          )
                        : HomeEmptyHeroLayout(
                            semanticLabel: s.homeNoPlanTitle,
                            title: s.homeNoPlanTitle,
                            subtitle: s.homeNoPlanHeroSubtitle,
                            primaryLabel: s.homeNoPlanCreateThisMonth,
                            onPrimary: _createPlanForCurrentMonth,
                            primaryEnabled: !planRegenerateBusy,
                            showPrimaryChevron: true,
                            secondaryLabel: s.homeNoPlanLearnHow,
                            onSecondary: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const AboutScreen(),
                                ),
                              );
                            },
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
