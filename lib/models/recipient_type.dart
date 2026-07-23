/// Who the letter is addressed to. Drives the honorific register used by
/// the generator and revision logic.
enum RecipientType {
  boss,
  colleague,
  family,
  partner,
  friend,
  other;

  String get label => switch (this) {
    RecipientType.boss => '上司',
    RecipientType.colleague => '同僚',
    RecipientType.family => '家族',
    RecipientType.partner => '恋人',
    RecipientType.friend => '友人',
    RecipientType.other => 'その他',
  };

  /// Honorific used when addressing this recipient in the letter body.
  String get honorific => switch (this) {
    RecipientType.boss => '部長',
    RecipientType.colleague => 'さん',
    RecipientType.family => '家族へ',
    RecipientType.partner => 'さんへ',
    RecipientType.friend => 'さん',
    RecipientType.other => '様',
  };
}
