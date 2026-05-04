part of '../app_database.dart';

@DriftAccessor(tables: [MonthPlans])
class MonthPlanDao extends DatabaseAccessor<AppDatabase>
    with _$MonthPlanDaoMixin {
  MonthPlanDao(super.db);

  /// Loads the most recently stored plan (by calendar year/month).
  Future<MonthPlan?> loadLatestPlan() async {
    final row =
        await (select(monthPlans)
              ..orderBy([
                (t) => OrderingTerm.desc(t.year),
                (t) => OrderingTerm.desc(t.month),
              ])
              ..limit(1))
            .getSingleOrNull();
    if (row == null) return null;
    return MonthPlan.fromJson(jsonDecode(row.planJson) as Map<String, dynamic>);
  }

  /// Persists [plan] as the sole stored row (all other months are removed).
  ///
  /// NOTE: single-plan storage — only one month is kept at a time.
  /// Issue #31 (multi-month navigation) will require changing this to
  /// upsert per (year, month) without deleting other rows.
  Future<void> savePlan(MonthPlan plan) async {
    await transaction(() async {
      await delete(monthPlans).go();
      await into(monthPlans).insert(
        MonthPlansCompanion.insert(
          year: plan.year,
          month: plan.month,
          planJson: jsonEncode(plan.toJson()),
        ),
      );
    });
  }

  Future<void> deletePlan(int year, int month) {
    return (delete(
      monthPlans,
    )..where((t) => t.year.equals(year) & t.month.equals(month))).go();
  }
}
