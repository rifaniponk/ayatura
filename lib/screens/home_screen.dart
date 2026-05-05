import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../data/local/app_database.dart';
import '../l10n/app_localizations.dart';
import '../data/models/plan.dart';
import '../data/models/prayer.dart';
import '../data/models/surah.dart';
import '../data/models/surah_pool_entry.dart';
import '../providers/providers.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/gradient_button.dart';
import '../widgets/home/quran_reader_sheet.dart';
import '../widgets/prayer/prayer_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahsAsyncProvider);
    final poolAsync = ref.watch(poolEntriesAsyncProvider);

    final s = S.of(context)!;
    return switch ((surahsAsync, poolAsync)) {
      (AsyncError(:final error), _) || (_, AsyncError(:final error)) => Center(
        child: Text(s.errorGeneric('$error')),
      ),
      (AsyncData(value: final surahs), AsyncData(value: final pool)) =>
        surahs.isEmpty
            ? Center(child: Text(s.noSurahsLoaded))
            : _HomeBody(surahs: surahs, pool: pool),
      _ => const Center(child: CircularProgressIndicator()),
    };
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
  static const double _dayTileWidth = 50;
  static const double _dayTileGap = 14;

  late Map<int, Surah> _masterById;
  final ScrollController _weekStripController = ScrollController();

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

  @override
  void dispose() {
    _weekStripController.dispose();
    super.dispose();
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
  }) async {
    await ref
        .read(monthPlanProvider.notifier)
        .toggleSlotLock(year: year, month: month, day: day, prayer: prayer);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
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
    final selectedDate = effective != null
        ? DateTime(effective.year, effective.month, clampedDay)
        : DateTime(now.year, now.month, clampedDay);
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final titleDate = DateFormat(
      'EEEE, d MMMM',
      localeTag,
    ).format(selectedDate);
    final isSelectedToday =
        selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
    final prayerTimesResult = prayerTimesAsync.asData?.value;
    final prayerTimesToday = isSelectedToday ? prayerTimesResult?.today : null;
    final locationName = isSelectedToday ? prayerTimesResult?.locationName : null;
    final cardState = _PrayerCardState.from(
      now: now,
      todayRow: prayerTimesToday,
      tomorrowRow: prayerTimesResult?.tomorrow,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_weekStripController.hasClients) return;
      final itemExtent = _dayTileWidth + _dayTileGap;
      final targetCenter = (clampedDay - 1) * itemExtent + (_dayTileWidth / 2);
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

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      children: [
        if (effective != null) ...[
          _WeekStrip(
            controller: _weekStripController,
            year: effective.year,
            month: effective.month,
            selectedDay: clampedDay,
            daysInMonth: daysInMonth,
            today: now,
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
                  child: Text(
                    '• $locationName',
                    style: AppTextStyles.smallLabel.copyWith(
                      color: AppColors.ink3,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          ...Prayer.values.map((prayer) {
            final slot =
                effective.planForDay(clampedDay)?.slotFor(prayer) ??
                PrayerSlot();
            final status = cardState.statusFor(prayer, S.of(context)!);
            return Padding(
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
                  day: clampedDay,
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

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({
    required this.controller,
    required this.year,
    required this.month,
    required this.selectedDay,
    required this.daysInMonth,
    required this.today,
    required this.onChanged,
  });

  final ScrollController controller;
  final int year;
  final int month;
  final int selectedDay;
  final int daysInMonth;
  final DateTime today;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    return SizedBox(
      height: 66,
      child: ListView.separated(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: daysInMonth,
        separatorBuilder: (_, _) =>
            const SizedBox(width: _HomeBodyState._dayTileGap),
        itemBuilder: (context, index) {
          final day = index + 1;
          final date = DateTime(year, month, day);
          final weekday = DateFormat(
            'EEE',
            localeTag,
          ).format(date).toUpperCase();
          final selected = day == selectedDay;
          final isToday =
              date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;

          return SizedBox(
            width: _HomeBodyState._dayTileWidth,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => onChanged(day),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.fromLTRB(6, 6, 6, 5),
                decoration: BoxDecoration(
                  gradient: selected ? AppColors.buttonGradient : null,
                  color: selected ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: selected ? Border.all(color: AppColors.green2) : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weekday,
                      style: AppTextStyles.smallLabel.copyWith(
                        fontSize: 9,
                        letterSpacing: 0.8,
                        color: selected ? AppColors.white : AppColors.ink3,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$day',
                      style: AppTextStyles.cardLabel.copyWith(
                        color: selected ? AppColors.white : AppColors.ink,
                        fontSize: 19,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    AnimatedOpacity(
                      opacity: isToday ? 1 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
    required this.times,
    required this.currentPrayer,
    required this.upcomingPrayer,
    required this.tomorrowFajr,
  });

  final Map<Prayer, DateTime> times;
  final Prayer? currentPrayer;
  final Prayer? upcomingPrayer;
  final DateTime? tomorrowFajr;

  static _PrayerCardState from({
    required DateTime now,
    PrayerTime? todayRow,
    PrayerTime? tomorrowRow,
  }) {
    if (todayRow == null) {
      return const _PrayerCardState(
        times: {},
        currentPrayer: null,
        upcomingPrayer: null,
        tomorrowFajr: null,
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

    Prayer? current;
    Prayer? upcoming;
    for (final prayer in Prayer.values) {
      final at = parsed[prayer];
      if (at == null) continue;
      if (at.isBefore(now) || at.isAtSameMomentAs(now)) {
        current = prayer;
      } else {
        upcoming ??= prayer;
      }
    }
    return _PrayerCardState(
      times: parsed,
      currentPrayer: current,
      upcomingPrayer: upcoming,
      tomorrowFajr: tomorrowRow == null ? null : parseOn(now.add(const Duration(days: 1)), tomorrowRow.fajr),
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
        progressRight: trailing == null ? null : s.homePrayerUntilNext(trailing),
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
    final at = times[prayer];
    final isPast = at != null && currentPrayer != null && at.isBefore(times[currentPrayer!]!);
    return _PrayerCardStatus(
      highlight: isPast ? PrayerCardHighlight.past : PrayerCardHighlight.normal,
    );
  }

  String? displayTimeFor(Prayer prayer) {
    final at = times[prayer];
    if (at == null) return null;
    return DateFormat('HH:mm').format(at);
  }

  DateTime? nextTimeAfterCurrent() {
    if (currentPrayer == null) return null;
    if (upcomingPrayer != null) return times[upcomingPrayer!];
    return tomorrowFajr;
  }

  double _windowProgress(DateTime start, DateTime end) {
    final totalMs = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    if (totalMs <= 0) return 0;
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final elapsed = (nowMs - start.millisecondsSinceEpoch).clamp(0, totalMs);
    return elapsed / totalMs;
  }

  String? _countdownTo(DateTime? at) {
    if (at == null) return null;
    final now = DateTime.now();
    var diff = at.difference(now);
    if (diff.isNegative) return null;
    final hours = diff.inHours;
    diff -= Duration(hours: hours);
    final minutes = diff.inMinutes;
    if (hours > 0) return '${hours}H ${minutes}M';
    if (minutes <= 0) return null;
    return '${minutes}M';
  }
}
