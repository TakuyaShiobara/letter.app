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
}
