import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Headings use a mincho (serif) typeface for a calligraphic, editorial
/// feel; body copy uses a gothic (sans) typeface for readability. Both are
/// bundled as local variable-font assets (see pubspec.yaml) rather than
/// fetched at runtime, so text never flashes invisible while a font loads.
class AppTextStyles {
  AppTextStyles._();

  static const _serif = 'NotoSerifJP';
  static const _sans = 'NotoSansJP';

  static TextStyle _weighted(
    String family,
    Color color,
    double size,
    FontWeight weight, {
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: family,
      color: color,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      // The bundled fonts are variable (single "wght" axis); this keeps
      // rendering correct even on engines that don't map FontWeight to a
      // variable font's named instances automatically.
      fontVariations: [FontVariation('wght', weight.value.toDouble())],
    );
  }

  static TextTheme textTheme(Color ink, Color inkSoft) {
    return TextTheme(
      displayLarge: _weighted(_serif, ink, 46, FontWeight.w600, height: 1.3, letterSpacing: 1.2),
      displayMedium: _weighted(_serif, ink, 40, FontWeight.w600, height: 1.3, letterSpacing: 1.1),
      displaySmall: _weighted(_serif, ink, 32, FontWeight.w600, height: 1.3, letterSpacing: 1.0),
      headlineLarge: _weighted(_serif, ink, 28, FontWeight.w600, letterSpacing: 1.0),
      headlineMedium: _weighted(_serif, ink, 24, FontWeight.w600, letterSpacing: 0.8),
      headlineSmall: _weighted(_serif, ink, 20, FontWeight.w600, letterSpacing: 0.6),
      titleLarge: _weighted(_serif, ink, 18, FontWeight.w600, letterSpacing: 0.4),
      titleMedium: _weighted(_sans, ink, 16, FontWeight.w600, letterSpacing: 0.2),
      titleSmall: _weighted(_sans, ink, 14, FontWeight.w600),
      bodyLarge: _weighted(_sans, ink, 16, FontWeight.w400, height: 1.7, letterSpacing: 0.2),
      bodyMedium: _weighted(_sans, ink, 14, FontWeight.w400, height: 1.7, letterSpacing: 0.2),
      bodySmall: _weighted(_sans, inkSoft, 12, FontWeight.w400, height: 1.6, letterSpacing: 0.2),
      labelLarge: _weighted(_sans, ink, 14, FontWeight.w600, letterSpacing: 0.4),
      labelMedium: _weighted(_sans, inkSoft, 12, FontWeight.w500, letterSpacing: 0.3),
      labelSmall: _weighted(_sans, inkSoft, 11, FontWeight.w500, letterSpacing: 0.3),
    );
  }

  static TextTheme get light => textTheme(AppColors.ink, AppColors.inkSoft);
  static TextTheme get dark =>
      textTheme(AppColors.paleInk, AppColors.paleInkSoft);
}
