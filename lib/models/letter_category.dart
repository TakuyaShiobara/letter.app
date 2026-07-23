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

  /// Material's outlined glyphs don't share a common optical size within
  /// their em-square — e.g. waving_hand's ink spans 470/512 units while
  /// eco's spans only 342/512 — so rendered at one fixed `size`, some read
  /// noticeably wider than others.
  ///
  /// These factors were computed from the actual glyph bounding boxes in
  /// MaterialIcons-Regular.otf (via fontTools), normalizing every icon's
  /// larger dimension (max of glyph width/height) to a common target:
  ///   gratitude   448×437   celebration 459×438   apology 384×342
  ///   sympathy    384×448   greeting    470×470   business 426×384
  ///   seasonal    342×342   other       342×86
  /// (Width alone isn't used as the target because sympathy's glyph is
  /// taller than it is wide — matching only width would blow up its height
  /// and clip it inside the tile.) Recompute if [icon] changes.
  double get iconSizeScale => switch (this) {
    LetterCategory.gratitude => 0.971,
    LetterCategory.celebration => 0.948,
    LetterCategory.apology => 1.133,
    LetterCategory.sympathy => 0.971,
    LetterCategory.greeting => 0.926,
    LetterCategory.business => 1.022,
    LetterCategory.seasonal => 1.273,
    LetterCategory.other => 1.273,
  };
}
