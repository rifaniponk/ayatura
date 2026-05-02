import 'package:flutter/material.dart';

/// All brand colours for Surah Planner.
/// Derived 1-to-1 from the design system: `--green`, `--green2`, `--gold`, etc.
abstract final class AppColors {
  // ── Brand ──────────────────────────────────────────────────────────────────
  static const Color green = Color(0xFF0F3D2E);
  static const Color green2 = Color(0xFF1F7A6B);
  static const Color gold = Color(0xFFD4AF37);

  // ── Surface / background ───────────────────────────────────────────────────
  static const Color background = Color(0xFFF6F7F5);
  static const Color white = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE8E8E8);

  // ── Ink ────────────────────────────────────────────────────────────────────
  static const Color ink = Color(0xFF1A1A1A);
  static const Color ink2 = Color(0xFF555555);
  static const Color ink3 = Color(0xFF888888);

  // ── Header dark gradient stops ─────────────────────────────────────────────
  static const Color headerDark = Color(0xFF071D13);

  // ── Semantic helpers ──────────────────────────────────────────────────────
  static const Color error = Color(0xFFC0392B);
  static const Color errorBg = Color(0x1ADC3545);

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    transform: GradientRotation(160 * 3.14159265 / 180),
    colors: [green, green2],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [green, green2],
  );

  static const LinearGradient sheetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    transform: GradientRotation(160 * 3.14159265 / 180),
    colors: [green, headerDark],
  );

  static const LinearGradient timelineLineGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [gold, Colors.transparent],
  );

  // ── Semi-transparent helpers ───────────────────────────────────────────────
  static const Color greenOverlay06 = Color(0x0F0F3D2E); // 6%
  static const Color goldOverlay12 = Color(0x1FD4AF37); // 12%
  static const Color goldOverlay30 = Color(0x4DD4AF37); // 30%
  static const Color white14 = Color(0x24FFFFFF); // 14%
  static const Color white10 = Color(0x1AFFFFFF); // 10%
  static const Color overlayDark = Color(0xE004120C); // modal backdrop ~88%

  // Named constructor is private — use as static-only class.
  AppColors._();
}
