part of '../../screens/home_screen.dart';

class _PrayerCardStatus {
  const _PrayerCardStatus({
    this.badge,
    this.trailing,
    this.subtitle,
    this.progress,
    this.progressLeft,
    this.progressRight,
    this.highlight = PrayerCardHighlight.normal,
  });

  final String? badge;
  final String? trailing;
  final String? subtitle;
  final double? progress;
  final String? progressLeft;
  final String? progressRight;
  final PrayerCardHighlight highlight;
}
