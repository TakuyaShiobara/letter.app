import 'package:flutter/material.dart';

/// Color palette inspired by washi paper, sumi ink and a quiet tea room.
///
/// Kept intentionally narrow: a warm paper background, ink-colored text,
/// and two low-saturation accents (deep green / deep navy) with gold used
/// only as a rare highlight (e.g. the hanko seal).
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color washi = Color(0xFFF6F1E4);
  static const Color washiCard = Color(0xFFFCFAF2);
  static const Color washiBorder = Color(0xFFE3D9C4);

  // Ink (text)
  static const Color ink = Color(0xFF2E2B26);
  static const Color inkSoft = Color(0xFF6B6459);

  // Accents
  static const Color deepGreen = Color(0xFF2F4A3C);
  static const Color deepGreenSoft = Color(0xFFE3E9E1);
  static const Color deepNavy = Color(0xFF263447);
  static const Color gold = Color(0xFFB4915B);

  // Dark theme (quiet, sumi-toned)
  static const Color inkBackground = Color(0xFF1C1B18);
  static const Color inkCard = Color(0xFF25231F);
  static const Color inkBorder = Color(0xFF3B372F);
  static const Color paleInk = Color(0xFFEDE7D9);
  static const Color paleInkSoft = Color(0xFFAFA898);
  static const Color deepGreenDark = Color(0xFF9CB8A6);
  static const Color deepNavyDark = Color(0xFF9AABC2);
}
