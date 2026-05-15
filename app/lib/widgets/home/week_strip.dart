part of '../../screens/home_screen.dart';

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({
    required this.planYear,
    required this.planMonth,
    required this.stripDates,
    required this.selectedDate,
    required this.today,
    required this.tapEnabledDays,
    required this.onChanged,
  });

  final int planYear;
  final int planMonth;
  final List<DateTime> stripDates;
  final DateTime selectedDate;
  final DateTime today;
  final Set<int> tapEnabledDays;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    return SizedBox(
      height: 66,
      child: Row(
        children: [
          for (var i = 0; i < stripDates.length; i++) ...[
            if (i > 0) const SizedBox(width: _HomeBodyState._dayTileGap),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: _HomeBodyState._dayTileWidth,
                  child: _weekDayTile(
                    localeTag: localeTag,
                    date: stripDates[i],
                    planYear: planYear,
                    planMonth: planMonth,
                    selectedDate: selectedDate,
                    today: today,
                    tapEnabledDays: tapEnabledDays,
                    onChanged: onChanged,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static Widget _weekDayTile({
    required String localeTag,
    required DateTime date,
    required int planYear,
    required int planMonth,
    required DateTime selectedDate,
    required DateTime today,
    required Set<int> tapEnabledDays,
    required ValueChanged<int> onChanged,
  }) {
    final weekday = DateFormat('EEE', localeTag).format(date).toUpperCase();
    final selected =
        date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day;
    final inPlanMonth = date.year == planYear && date.month == planMonth;
    final isTappable = inPlanMonth && tapEnabledDays.contains(date.day);
    final isToday =
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;

    return SizedBox(
      width: _HomeBodyState._dayTileWidth,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: isTappable ? () => onChanged(date.day) : null,
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
                  color: selected
                      ? AppColors.white
                      : (isTappable
                            ? AppColors.ink3
                            : AppColors.ink3.withValues(alpha: 0.45)),
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '${date.day}',
                style: AppTextStyles.cardLabel.copyWith(
                  color: selected
                      ? AppColors.white
                      : (isTappable
                            ? AppColors.ink
                            : AppColors.ink3.withValues(alpha: 0.45)),
                  fontSize: 19,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
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
  }
}
