import 'day_plan.dart';

/// The full plan for an entire month.
class MonthPlan {
  /// Calendar month (1–12).
  final int month;
  final int year;
  final List<DayPlan> days;

  const MonthPlan({
    required this.month,
    required this.year,
    required this.days,
  });

  DayPlan? planForDay(int day) {
    for (final d in days) {
      if (d.day == day) return d;
    }
    return null;
  }

  /// Whether this plan is for a month/year before [at]'s calendar month.
  bool isStaleAt(DateTime at) => at.month != month || at.year != year;

  /// Returns `this` if not stale at [now], otherwise `null`.
  MonthPlan? effectiveOrNull(DateTime now) => isStaleAt(now) ? null : this;

  Map<String, dynamic> toJson() => {
    'month': month,
    'year': year,
    'days': days.map((d) => d.toJson()).toList(),
  };

  factory MonthPlan.fromJson(Map<String, dynamic> json) {
    return MonthPlan(
      month: json['month'] as int,
      year: json['year'] as int,
      days: (json['days'] as List<dynamic>)
          .map((d) => DayPlan.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }
}
