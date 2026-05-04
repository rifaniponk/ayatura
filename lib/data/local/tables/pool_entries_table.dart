import 'package:drift/drift.dart';

import 'surahs_table.dart';

@DataClassName('SurahPoolEntryRow')
class SurahPoolEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get surahId => integer().references(Surahs, #id)();

  BoolColumn get isFullSurah => boolean()();

  IntColumn get startAyah => integer().nullable()();

  IntColumn get endAyah => integer().nullable()();

  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
}
