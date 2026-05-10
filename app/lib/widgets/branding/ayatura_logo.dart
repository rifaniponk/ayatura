import 'package:flutter/material.dart';

import 'ayatura_logo_variant.dart';

/// Ayatura wordmark / emblem from bundled PNG variants.
class AyaturaLogo extends StatelessWidget {
  const AyaturaLogo({
    super.key,
    required this.variant,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.semanticLabel,
  });

  final AyaturaLogoVariant variant;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Alignment alignment;

  /// When null, the image is excluded from semantics (decorative).
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      variant.assetPath,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment,
      gaplessPlayback: true,
      filterQuality: FilterQuality.medium,
      semanticLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
  }
}
