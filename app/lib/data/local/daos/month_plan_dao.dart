part of '../app_database.dart';

@DriftAccessor(tables: [MonthPlans])
class MonthPlanDao extends DatabaseAccessor<AppDatabase>
    with _$MonthPlanDaoMixin {
  MonthPlanDao(super.db);

  /// Loads plan for a specific [year]/[month].
  Future<MonthPlan?> loadPlan(int year, int month) async {
    final row =
        await (select(monthPlans)
              ..where((t) => t.year.equals(year) & t.month.equals(month))
              ..limit(1))
            .getSingleOrNull();
    if (row == null) return null;
    return MonthPlan.fromJson(jsonDecode(row.planJson) as Map<String, dynamic>);
  }

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

  /// Persists [plan] by upserting per (year, month).
  Future<void> savePlan(MonthPlan plan) async {
    final now = DateTime.now();
    await into(monthPlans).insert(
      MonthPlansCompanion.insert(
        year: plan.year,
        month: plan.month,
        planJson: jsonEncode(plan.toJson()),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
      onConflict: DoUpdate(
        (old) => MonthPlansCompanion(
          planJson: Value(jsonEncode(plan.toJson())),
          updatedAt: Value(DateTime.now()),
        ),
      ),
    );
  }

  Future<void> deletePlan(int year, int month) {
    return (delete(
      monthPlans,
    )..where((t) => t.year.equals(year) & t.month.equals(month))).go();
  }

  Future<List<MonthPlan>> loadAllPlans() async {
    final rows =
        await (select(monthPlans)..orderBy([
              (t) => OrderingTerm.desc(t.year),
              (t) => OrderingTerm.desc(t.month),
            ]))
            .get();
    return rows
        .map(
          (row) => MonthPlan.fromJson(
            jsonDecode(row.planJson) as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
