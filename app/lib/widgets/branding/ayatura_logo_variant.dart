import 'package:flutter/material.dart';

/// Selects which raster logo asset to show.
///
/// PNG files live under `assets/images/logo/`.
enum AyaturaLogoVariant {
  /// Full-color mark (green frame, gold moon) — `logo.png`.
  fullColor('assets/images/logo/logo.png'),

  /// Dark glyphs for light surfaces — `logo_black.png`.
  onLightBackground('assets/images/logo/logo_black.png'),

  /// Light glyphs for dark or saturated surfaces — `logo_white.png`.
  onDarkBackground('assets/images/logo/logo_white.png'),

  /// White outline mark for busy headers — `logo_o_white.png`.
  outlineOnDarkBackground('assets/images/logo/logo_o_white.png');

  const AyaturaLogoVariant(this.assetPath);

  final String assetPath;

  /// Picks [onLightBackground] or [onDarkBackground] from material brightness.
  static AyaturaLogoVariant forBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? onDarkBackground : onLightBackground;
  }

  /// Uses [Theme.of] brightness ([forBrightness]).
  static AyaturaLogoVariant forTheme(BuildContext context) {
    return forBrightness(Theme.of(context).brightness);
  }
}
