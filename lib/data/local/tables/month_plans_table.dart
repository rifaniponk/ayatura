import 'package:drift/drift.dart';

@DataClassName('MonthPlanRow')
class MonthPlans extends Table {
  IntColumn get year => integer()();

  IntColumn get month => integer()();

  TextColumn get planJson => text()();

  @override
  Set<Column<Object>>? get primaryKey => {year, month};
}
