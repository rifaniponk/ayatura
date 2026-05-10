part of '../../screens/home_screen.dart';

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({
    required this.controller,
    required this.year,
    required this.month,
    required this.selectedDay,
    required this.daysInMonth,
    required this.today,
    required this.availableDays,
    required this.onChanged,
  });

  final ScrollController controller;
  final int year;
  final int month;
  final int selectedDay;
  final int daysInMonth;
  final DateTime today;
  final Set<int> availableDays;
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
          final isAvailable = availableDays.contains(day);
          final isToday =
              date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;

          return SizedBox(
            width: _HomeBodyState._dayTileWidth,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: isAvailable ? () => onChanged(day) : null,
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
                            : (isAvailable
                                  ? AppColors.ink3
                                  : AppColors.ink3.withValues(alpha: 0.45)),
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$day',
                      style: AppTextStyles.cardLabel.copyWith(
                        color: selected
                            ? AppColors.white
                            : (isAvailable
                                  ? AppColors.ink
                                  : AppColors.ink3.withValues(alpha: 0.45)),
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
