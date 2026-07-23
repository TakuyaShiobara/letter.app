import 'package:flutter/material.dart';

/// The eight top-level letter categories shown on the home screen and used
/// to filter the sample library.
enum LetterCategory {
  gratitude,
  celebration,
  apology,
  sympathy,
  greeting,
  business,
  seasonal,
  other;

  String get label => switch (this) {
    LetterCategory.gratitude => 'お礼',
    LetterCategory.celebration => 'お祝い',
    LetterCategory.apology => 'お詫び',
    LetterCategory.sympathy => 'お見舞い',
    LetterCategory.greeting => '挨拶',
    LetterCategory.business => 'ビジネス',
    LetterCategory.seasonal => '季節の便り',
    LetterCategory.other => 'その他',
  };

  /// Thin, outlined icons only — no filled or duotone icons.
  IconData get icon => switch (this) {
    LetterCategory.gratitude => Icons.volunteer_activism_outlined,
    LetterCategory.celebration => Icons.celebration_outlined,
    LetterCategory.apology => Icons.self_improvement_outlined,
    LetterCategory.sympathy => Icons.local_florist_outlined,
    LetterCategory.greeting => Icons.waving_hand_outlined,
    LetterCategory.business => Icons.business_center_outlined,
    LetterCategory.seasonal => Icons.eco_outlined,
    LetterCategory.other => Icons.more_horiz_outlined,
  };

  /// Material's outlined glyphs don't share a common optical size — some
  /// (waving_hand, local_florist) fill their bounding box much more than
  /// others (eco, self_improvement), so rendered at one fixed size they
  /// visually vary in width. This scales each glyph so they read as a
  /// consistent set; tune alongside [icon] if a glyph changes.
  double get iconSizeScale => switch (this) {
    LetterCategory.gratitude => 0.96,
    LetterCategory.celebration => 0.96,
    LetterCategory.apology => 1.15,
    LetterCategory.sympathy => 1.0,
    LetterCategory.greeting => 0.88,
    LetterCategory.business => 1.03,
    LetterCategory.seasonal => 1.2,
    LetterCategory.other => 0.95,
  };
}
