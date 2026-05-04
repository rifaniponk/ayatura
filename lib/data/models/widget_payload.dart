class WidgetPayload {
  const WidgetPayload({
    required this.state,
    required this.generatedAtIso8601,
    this.current,
    this.next,
  });

  final String state;
  final String generatedAtIso8601;
  final WidgetPrayerBlock? current;
  final WidgetPrayerBlock? next;

  Map<String, dynamic> toJson() => {
    'state': state,
    'generatedAt': generatedAtIso8601,
    'current': current?.toJson(),
    'next': next?.toJson(),
  };
}

class WidgetPrayerBlock {
  const WidgetPrayerBlock({
    required this.prayer,
    required this.time,
    required this.surahs,
    this.countdownMinutes,
    this.isTomorrow = false,
  });

  final String prayer;
  final String time;
  final int? countdownMinutes;
  final bool isTomorrow;
  final List<WidgetSurahRow> surahs;

  Map<String, dynamic> toJson() => {
    'prayer': prayer,
    'time': time,
    'countdownMinutes': countdownMinutes,
    'isTomorrow': isTomorrow,
    'surahs': surahs.map((s) => s.toJson()).toList(),
  };
}

class WidgetSurahRow {
  const WidgetSurahRow({required this.name, required this.ayat});

  final String name;
  final String ayat;

  Map<String, dynamic> toJson() => {'name': name, 'ayat': ayat};
}
