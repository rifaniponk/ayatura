part of '../../screens/home_screen.dart';

class _HomeBody extends ConsumerStatefulWidget {
  const _HomeBody({required this.surahs, required this.pool});

  final List<Surah> surahs;
  final List<SurahPoolEntry> pool;

  @override
  ConsumerState<_HomeBody> createState() => _HomeBodyState();
}

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
    if (mounted) {
      setState(() {
        _clockNow = DateTime.now();
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
      if (!_weekStripController.hasClients) return;
      final itemExtent = _dayTileWidth + _dayTileGap;
      final targetCenter = (resolvedDay - 1) * itemExtent + (_dayTileWidth / 2);
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

    return RefreshIndicator(
      onRefresh: _forceRefreshPrayerTimes,
      child: ListView(
        controller: _listController,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
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
                  ? const _PrayerCardStatus(highlight: PrayerCardHighlight.past)
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
          ] else ...[
            if (enabledCount < 2)
              EmptyState(
                variant: EmptyStateVariant.hifdhListTooSmall,
                onAction: () => ref.read(navIndexProvider.notifier).setIndex(2),
              )
            else
              EmptyState(
                variant: EmptyStateVariant.noPlan,
                onAction: () => ref.read(navIndexProvider.notifier).setIndex(1),
              ),
          ],
        ],
      ),
    );
  }
}

class _PrayerCardStatus {
  const _PrayerCardStatus({
    this.badge,
    this.trailing,
    this.subtitle,
    this.progress,
    this.progressLeft,
    this.progressRight,
    this.highlight = PrayerCardHighlight.normal,
  });

  final String? badge;
  final String? trailing;
  final String? subtitle;
  final double? progress;
  final String? progressLeft;
  final String? progressRight;
  final PrayerCardHighlight highlight;
}

class _PrayerCardState {
  const _PrayerCardState({
    required this.referenceNow,
    required this.times,
    required this.currentPrayer,
    required this.upcomingPrayer,
    required this.tomorrowFajr,
    required this.sunrise,
  });

  final DateTime referenceNow;
  final Map<Prayer, DateTime> times;
  final Prayer? currentPrayer;
  final Prayer? upcomingPrayer;
  final DateTime? tomorrowFajr;
  final DateTime? sunrise;

  static _PrayerCardState from({
    required DateTime now,
    PrayerTime? todayRow,
    PrayerTime? tomorrowRow,
  }) {
    if (todayRow == null) {
      return _PrayerCardState(
        referenceNow: DateTime.fromMillisecondsSinceEpoch(0),
        times: {},
        currentPrayer: null,
        upcomingPrayer: null,
        tomorrowFajr: null,
        sunrise: null,
      );
    }
    final parsed = <Prayer, DateTime>{};
    DateTime? parseOn(DateTime day, String hhmm) {
      final chunks = hhmm.split(':');
      if (chunks.length < 2) return null;
      final h = int.tryParse(chunks[0]);
      final m = int.tryParse(chunks[1]);
      if (h == null || m == null) return null;
      return DateTime(day.year, day.month, day.day, h, m);
    }

    void add(Prayer prayer, String hhmm) {
      final parsedAt = parseOn(now, hhmm);
      if (parsedAt == null) return;
      parsed[prayer] = parsedAt;
    }

    add(Prayer.fajr, todayRow.fajr);
    add(Prayer.dhuhr, todayRow.dhuhr);
    add(Prayer.asr, todayRow.asr);
    add(Prayer.maghrib, todayRow.maghrib);
    add(Prayer.isha, todayRow.isha);
    final sunriseRaw = todayRow.sunrise;
    final sunriseAt = sunriseRaw != null && sunriseRaw.isNotEmpty
        ? parseOn(now, sunriseRaw)
        : null;
    final fajrAt = parsed[Prayer.fajr];
    Prayer? current;
    if (fajrAt != null &&
        sunriseAt != null &&
        !now.isBefore(fajrAt) &&
        now.isBefore(sunriseAt)) {
      current = Prayer.fajr;
    } else {
      for (final prayer in Prayer.values) {
        final at = parsed[prayer];
        if (at == null) continue;
        if (at.isAfter(now)) break;
        if (prayer == Prayer.fajr && sunriseAt != null) continue;
        current = prayer;
      }
    }
    Prayer? upcoming;
    for (final prayer in Prayer.values) {
      final at = parsed[prayer];
      if (at == null) continue;
      if (at.isAfter(now)) {
        upcoming = prayer;
        break;
      }
    }
    return _PrayerCardState(
      referenceNow: now,
      times: parsed,
      currentPrayer: current,
      upcomingPrayer: upcoming,
      tomorrowFajr: tomorrowRow == null
          ? null
          : parseOn(now.add(const Duration(days: 1)), tomorrowRow.fajr),
      sunrise: sunriseAt,
    );
  }

  _PrayerCardStatus statusFor(Prayer prayer, S s) {
    if (times.isEmpty) return const _PrayerCardStatus();
    if (prayer == currentPrayer) {
      final currentAt = times[prayer];
      final nextAt = nextTimeAfterCurrent();
      final progress = (currentAt != null && nextAt != null)
          ? _windowProgress(currentAt, nextAt)
          : null;
      final trailing = _countdownTo(nextAt);
      return _PrayerCardStatus(
        badge: s.homeNowPrayingBadge,
        subtitle: displayTimeFor(prayer) == null
            ? null
            : s.homePrayerStartedAt(displayTimeFor(prayer)!),
        progress: progress,
        progressLeft: null,
        progressRight: trailing == null
            ? null
            : s.homePrayerUntilNext(trailing),
        highlight: PrayerCardHighlight.current,
      );
    }
    if (prayer == upcomingPrayer) {
      return _PrayerCardStatus(
        badge: s.homeUpNextBadge,
        trailing: _countdownTo(times[prayer]),
        highlight: PrayerCardHighlight.upcoming,
      );
    }
    final isPast = _isPastPrayer(prayer);
    return _PrayerCardStatus(
      highlight: isPast ? PrayerCardHighlight.past : PrayerCardHighlight.normal,
    );
  }

  bool _isPastPrayer(Prayer prayer) {
    final at = times[prayer];
    if (at == null) return false;
    if (prayer == Prayer.fajr) {
      if (sunrise != null) {
        if (referenceNow.isBefore(at)) return false;
        return !referenceNow.isBefore(sunrise!);
      }
      if (currentPrayer != null) {
        return at.isBefore(times[currentPrayer!]!);
      }
      return referenceNow.isAfter(at);
    }
    if (currentPrayer != null) {
      return at.isBefore(times[currentPrayer!]!);
    }
    return false;
  }

  String? displayTimeFor(Prayer prayer) {
    final at = times[prayer];
    if (at == null) return null;
    return DateFormat('HH:mm').format(at);
  }

  DateTime? nextTimeAfterCurrent() {
    if (currentPrayer == null) return null;
    if (currentPrayer == Prayer.fajr &&
        sunrise != null &&
        referenceNow.isBefore(sunrise!)) {
      return sunrise;
    }
    if (upcomingPrayer != null) return times[upcomingPrayer!];
    return tomorrowFajr;
  }

  double _windowProgress(DateTime start, DateTime end) {
    final totalMs = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    if (totalMs <= 0) return 0;
    final nowMs = referenceNow.millisecondsSinceEpoch;
    final elapsed = (nowMs - start.millisecondsSinceEpoch).clamp(0, totalMs);
    return elapsed / totalMs;
  }

  String? _countdownTo(DateTime? at) {
    if (at == null) return null;
    var diff = at.difference(referenceNow);
    if (diff.isNegative) return null;
    final hours = diff.inHours;
    diff -= Duration(hours: hours);
    final minutes = diff.inMinutes;
    if (hours > 0) return '${hours}H ${minutes}M';
    if (minutes <= 0) return null;
    return '${minutes}M';
  }
}
