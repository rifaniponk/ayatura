import 'package:drift/drift.dart';

@DataClassName('SurahRow')
class Surahs extends Table {
  IntColumn get id => integer()();

  TextColumn get name => text()();

  TextColumn get nameId => text().withDefault(const Constant(''))();

  TextColumn get arabicName => text()();

  IntColumn get ayatCount => integer()();

  IntColumn get startJuz => integer().withDefault(const Constant(1))();

  IntColumn get endJuz => integer().withDefault(const Constant(1))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
