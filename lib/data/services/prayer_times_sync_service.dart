import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../local/app_database.dart';

class PrayerTimesSyncResult {
  const PrayerTimesSyncResult({
    required this.today,
    required this.tomorrow,
    this.locationName,
  });

  final PrayerTime today;
  final PrayerTime? tomorrow;
  final String? locationName;
}

class PrayerTimesSyncService {
  PrayerTimesSyncService(this._db, {http.Client? client})
    : _client = client ?? http.Client();

  final AppDatabase _db;
  final http.Client _client;

  static const _ipApiUrl = 'http://ip-api.com/json/';
  static const _aladhanHost = 'api.aladhan.com';
  static const _aladhanMethod = '20';

  Future<PrayerTimesSyncResult?> syncAndLoadToday() async {
    final location = await _resolveLocation();
    if (location == null) return null;

    final today = _dayOnly(DateTime.now());
    final days = List<DateTime>.generate(
      7,
      (idx) => today.add(Duration(days: idx)),
      growable: false,
    );
    final dayKeys = days.map(_isoDate).toList(growable: false);
    final existing = await _db.prayerTimesByDates(dayKeys);
    final missingDays = days.where((day) => !existing.containsKey(_isoDate(day)));

    for (final day in missingDays) {
      final timings = await _fetchTiming(day: day, location: location);
      if (timings == null) continue;
      await _db.upsertPrayerTime(
        PrayerTimesCompanion.insert(
          date: _isoDate(day),
          fajr: timings.fajr,
          sunrise: Value(timings.sunrise.isEmpty ? null : timings.sunrise),
          dhuhr: timings.dhuhr,
          asr: timings.asr,
          maghrib: timings.maghrib,
          isha: timings.isha,
          latitude: location.latitude,
          longitude: location.longitude,
          locationName: Value(location.cityName),
        ),
      );
    }

    final todayRow = await _db.prayerTimeByDate(_isoDate(today));
    if (todayRow == null) return null;
    final tomorrowRow = await _db.prayerTimeByDate(
      _isoDate(today.add(const Duration(days: 1))),
    );
    return PrayerTimesSyncResult(
      today: todayRow,
      tomorrow: tomorrowRow,
      locationName: todayRow.locationName ?? location.cityName,
    );
  }

  Future<_ResolvedLocation?> _resolveLocation() async {
    try {
      final status = await Permission.locationWhenInUse.request();
      if (status.isGranted) {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
          ),
        );
        return _ResolvedLocation(
          latitude: position.latitude,
          longitude: position.longitude,
          cityName: null,
        );
      }
    } catch (_) {
      // Fallback handled below.
    }

    try {
      final response = await _client.get(Uri.parse(_ipApiUrl));
      if (response.statusCode != 200) return null;
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if ((body['status'] as String?) != 'success') return null;
      final latitude = (body['lat'] as num?)?.toDouble();
      final longitude = (body['lon'] as num?)?.toDouble();
      if (latitude == null || longitude == null) return null;
      final city = (body['city'] as String?)?.trim();
      return _ResolvedLocation(
        latitude: latitude,
        longitude: longitude,
        cityName: (city == null || city.isEmpty) ? null : city,
      );
    } catch (_) {
      return null;
    }
  }

  Future<_ApiTiming?> _fetchTiming({
    required DateTime day,
    required _ResolvedLocation location,
  }) async {
    try {
      final formatted = DateFormat('dd-MM-yyyy').format(day);
      final uri = Uri.https(_aladhanHost, '/v1/timings/$formatted', {
        'latitude': '${location.latitude}',
        'longitude': '${location.longitude}',
        'method': _aladhanMethod,
      });
      final response = await _client.get(uri);
      if (response.statusCode != 200) return null;
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;
      final timings = data?['timings'] as Map<String, dynamic>?;
      if (timings == null) return null;
      return _ApiTiming(
        fajr: _cleanTime(timings['Fajr']),
        sunrise: _cleanTime(timings['Sunrise']),
        dhuhr: _cleanTime(timings['Dhuhr']),
        asr: _cleanTime(timings['Asr']),
        maghrib: _cleanTime(timings['Maghrib']),
        isha: _cleanTime(timings['Isha']),
      );
    } catch (_) {
      return null;
    }
  }

  static String _cleanTime(Object? raw) {
    final text = (raw as String? ?? '').trim();
    if (text.isEmpty) return '';
    final hhmm = text.split(' ').first;
    final chunks = hhmm.split(':');
    if (chunks.length < 2) return '';
    final h = int.tryParse(chunks[0]);
    final m = int.tryParse(chunks[1]);
    if (h == null || m == null) return '';
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  static String _isoDate(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  static DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}

class _ResolvedLocation {
  const _ResolvedLocation({
    required this.latitude,
    required this.longitude,
    required this.cityName,
  });

  final double latitude;
  final double longitude;
  final String? cityName;
}

class _ApiTiming {
  const _ApiTiming({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
}
