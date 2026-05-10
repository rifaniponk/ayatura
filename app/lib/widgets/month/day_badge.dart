part of 'day_plan_card.dart';

class _DayBadge extends StatelessWidget {
  const _DayBadge({required this.day});

  final int day;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.border,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$day',
        style: AppTextStyles.smallLabel.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.ink2,
        ),
      ),
    );
  }
}
