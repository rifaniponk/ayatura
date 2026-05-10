import 'package:drift/drift.dart';

class PrayerTimes extends Table {
  TextColumn get date => text()(); // yyyy-MM-dd

  TextColumn get fajr => text()();
  TextColumn get dhuhr => text()();
  TextColumn get asr => text()();
  TextColumn get maghrib => text()();
  TextColumn get isha => text()();

  /// End of Fajr observance window (not a salah slot in the app UI).
  TextColumn get sunrise => text().nullable()();

  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get locationName => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {date};
}
