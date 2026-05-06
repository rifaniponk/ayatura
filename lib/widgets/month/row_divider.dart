part of 'day_plan_card.dart';

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: _kPrayerColWidth, bottom: 3),
      child: Container(height: 1, color: AppColors.border),
    );
  }
}
