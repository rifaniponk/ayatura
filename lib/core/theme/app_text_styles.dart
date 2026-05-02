import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralised text style catalogue for Surah Planner.
///
/// Font families declared in pubspec.yaml under `flutter: fonts:`.
/// Files live in `assets/fonts/` — see README for download instructions.
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

  static const TextStyle prayerTime = TextStyle(
    fontFamily: _sans,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.ink3,
  );

  static const TextStyle meta = TextStyle(
    fontFamily: _sans,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.ink3,
  );

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

  AppTextStyles._();
}
