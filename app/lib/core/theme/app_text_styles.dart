import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralised text style catalogue for Surah Planner.
///
/// Font families declared in pubspec.yaml under `flutter: fonts:`.
/// Files live in `assets/fonts/` — see pubspec.yaml commented `fonts:` block.
///
/// Falls back gracefully to the system serif / sans-serif if a font file
/// has not yet been added, so the app always compiles and runs.
abstract final class AppTextStyles {
  // Font family name constants — match pubspec.yaml `family:` keys exactly.
  static const _serif = 'PlayfairDisplay';
  static const _sans = 'DMSans';
  static const _arabic = 'Amiri';

  // ── Serif (Playfair Display) ───────────────────────────────────────────────
  static const TextStyle appTitle = TextStyle(
    fontFamily: _serif,
    fontSize: 21,
    fontWeight: FontWeight.w700,
    color: AppColors.gold,
  );

  static const TextStyle mainHeading = TextStyle(
    fontFamily: _serif,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.ink,
  );

  static const TextStyle sectionHeadingSerif = TextStyle(
    fontFamily: _serif,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  static const TextStyle surahNameCard = TextStyle(
    fontFamily: _serif,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  /// Large heading used in highlighted current prayer card (e.g. "Isha").
  static const TextStyle prayerCurrentTitle = TextStyle(
    fontFamily: _serif,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.0,
    color: AppColors.gold,
  );

  /// Prayer name for highlighted secondary cards.
  static const TextStyle prayerHighlightedTitle = TextStyle(
    fontFamily: _serif,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.0,
    color: AppColors.gold,
  );

  /// Surah row title inside prayer cards.
  static const TextStyle surahNamePrayerCard = TextStyle(
    fontFamily: _serif,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
  );

  static const TextStyle sheetSurahName = TextStyle(
    fontFamily: _serif,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static const TextStyle emptyStateTitle = TextStyle(
    fontFamily: _serif,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.green,
  );

  // ── Sans (DM Sans) ────────────────────────────────────────────────────────
  static const TextStyle sectionEyebrow = TextStyle(
    fontFamily: _sans,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.5,
    color: AppColors.green2,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.ink2,
  );

  static const TextStyle cardLabel = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  static const TextStyle prayerLabel = TextStyle(
    fontFamily: _sans,
    fontSize: 11,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.8,
    color: AppColors.green,
  );

  /// Prayer times, counts, hints — single secondary line style.
  static const TextStyle prayerTime = TextStyle(
    fontFamily: _sans,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.ink3,
  );

  /// Same styles as [prayerTime]; kept for existing / handoff call sites.
  static const TextStyle meta = prayerTime;

  static const TextStyle navLabel = TextStyle(
    fontFamily: _sans,
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontFamily: _sans,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static const TextStyle smallLabel = TextStyle(
    fontFamily: _sans,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.ink2,
  );

  static const TextStyle prayerCardBadge = TextStyle(
    fontFamily: _sans,
    fontSize: 9,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.8,
    color: AppColors.gold,
  );

  static const TextStyle prayerCardProgressMeta = TextStyle(
    fontFamily: _sans,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.9,
    color: AppColors.ink3,
  );

  static const TextStyle prayerCardPanelTitle = TextStyle(
    fontFamily: _sans,
    fontSize: 10,
    fontWeight: FontWeight.w800,
    letterSpacing: 2.2,
    color: AppColors.gold,
  );

  static const TextStyle prayerCardVerseCount = TextStyle(
    fontFamily: _sans,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.ink3,
  );

  static const TextStyle dayPillLabel = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w700,
  );

  // ── Arabic (Amiri) ────────────────────────────────────────────────────────
  static const TextStyle arabicBody = TextStyle(
    fontFamily: _arabic,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
    height: 1.8,
  );

  static const TextStyle arabicSecondary = TextStyle(
    fontFamily: _arabic,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.ink2,
  );
}
