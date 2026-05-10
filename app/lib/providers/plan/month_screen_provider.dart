import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Same horizon backward / forward from [DateTime.now] for month-picker arrows.
const int _kMonthNavHorizonMonths = 12;

/// Calendar month being browsed on the Month tab (independent of home day picker).
class ViewedMonthNotifier extends Notifier<({int month, int year})> {
  @override
  ({int month, int year}) build() {
    final now = DateTime.now();
    return (month: now.month, year: now.year);
  }

  void goToPrev() {
    final v = state;
    final prev = _addMonths(v.year, v.month, -1);
    final now = DateTime.now();
    final earliest = _addMonths(now.year, now.month, -_kMonthNavHorizonMonths);
    if (_ym(prev) < _ym(earliest)) return;
    state = (month: prev.month, year: prev.year);
  }

  void goToNext() {
    final v = state;
    final next = _addMonths(v.year, v.month, 1);
    final now = DateTime.now();
    final latest = _addMonths(now.year, now.month, _kMonthNavHorizonMonths);
    if (_ym(next) > _ym(latest)) return;
    state = (month: next.month, year: next.year);
  }
}

final viewedMonthProvider =
    NotifierProvider<ViewedMonthNotifier, ({int month, int year})>(
      ViewedMonthNotifier.new,
    );

/// Whether [viewedMonth] can move one month backward (within [_kMonthNavHorizonMonths]
/// of the current calendar month).
bool viewedMonthCanGoPrev(({int month, int year}) viewed) {
  final now = DateTime.now();
  final prev = _addMonths(viewed.year, viewed.month, -1);
  final earliest = _addMonths(now.year, now.month, -_kMonthNavHorizonMonths);
  return _ym(prev) >= _ym(earliest);
}

/// Whether [viewedMonth] can move one month forward (within [_kMonthNavHorizonMonths]
/// of the current calendar month).
bool viewedMonthCanGoNext(({int month, int year}) viewed) {
  final now = DateTime.now();
  final next = _addMonths(viewed.year, viewed.month, 1);
  final latest = _addMonths(now.year, now.month, _kMonthNavHorizonMonths);
  return _ym(next) <= _ym(latest);
}

DateTime _addMonths(int year, int month, int delta) {
  var m = month + delta;
  var y = year;
  while (m > 12) {
    m -= 12;
    y++;
  }
  while (m < 1) {
    m += 12;
    y--;
  }
  return DateTime(y, m);
}

int _ym(DateTime d) => d.year * 12 + d.month;
