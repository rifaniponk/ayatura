import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/plan.dart';
import '../../data/models/plan_surah.dart';
import '../../data/models/prayer.dart';
import '../../data/models/surah.dart';
import '../../l10n/app_localizations.dart';

part 'compact_prayer_row.dart';
part 'day_badge.dart';
part 'row_divider.dart';

const double _kPrayerColWidth = 40;

/// One calendar day in the month review — compact narrow card: day badge +
/// month, then one row per prayer (code + surah line).
class DayPlanCard extends StatelessWidget {
  const DayPlanCard({
    super.key,
    required this.dayPlan,
    required this.viewedYear,
    required this.viewedMonth,
    required this.masterBySurahId,
    required this.isToday,
    required this.isPastDay,
    required this.allSlotsLocked,
    required this.onToggleLock,
    required this.onTapPrayer,
  });

  final DayPlan dayPlan;
  final int viewedYear;
  final int viewedMonth;
  final Map<int, Surah> masterBySurahId;
  final bool isToday;
  final bool isPastDay;
  final bool allSlotsLocked;
  final ValueChanged<Prayer> onToggleLock;
  final ValueChanged<Prayer> onTapPrayer;

  static bool calendarDayIsPast(int y, int m, int d, DateTime now) {
    final t = DateTime(now.year, now.month, now.day);
    final candidate = DateTime(y, m, d);
    return candidate.isBefore(t);
  }

  static bool isCalendarToday(int y, int m, int d, DateTime now) {
    return y == now.year && m == now.month && d == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final inner = _cardBody(context, s, lang);

    final card = ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: isToday
            ? IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 3,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.green, AppColors.green2],
                        ),
                      ),
                    ),
                    Expanded(child: inner),
                  ],
                ),
              )
            : inner,
      ),
    );

    if (!isPastDay) return card;
    return Opacity(opacity: 0.6, child: card);
  }

  Widget _cardBody(BuildContext context, S s, String lang) {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final monthAbbrev = DateFormat(
      'MMM',
      localeTag,
    ).format(DateTime(viewedYear, viewedMonth)).toUpperCase();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _DayBadge(day: dayPlan.day),
              const SizedBox(width: 8),
              Text(
                monthAbbrev,
                style: AppTextStyles.meta.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.ink3,
                ),
              ),
              const Spacer(),
              if (isToday)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    s.monthTodayChip,
                    style: AppTextStyles.sectionEyebrow.copyWith(
                      color: AppColors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              if (allSlotsLocked) ...[
                if (isToday) const SizedBox(width: 6),
                const Icon(Icons.lock_rounded, size: 15, color: AppColors.gold),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Container(height: 1, color: AppColors.border),
          const SizedBox(height: 2),
          for (var i = 0; i < Prayer.values.length; i++) ...[
            if (i > 0) const _RowDivider(),
            _CompactPrayerRow(
              prayer: Prayer.values[i],
              slot: dayPlan.slotFor(Prayer.values[i]),
              s: s,
              lang: lang,
              masterBySurahId: masterBySurahId,
              onToggleLock: () => onToggleLock(Prayer.values[i]),
              onTap: () => onTapPrayer(Prayer.values[i]),
            ),
          ],
        ],
      ),
    );
  }
}
