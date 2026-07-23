/// The register / tone the generated letter should be written in.
enum WritingStyle {
  polite,
  veryPolite,
  soft,
  casual;

  String get label => switch (this) {
    WritingStyle.polite => '丁寧',
    WritingStyle.veryPolite => 'とても丁寧',
    WritingStyle.soft => 'やわらかい',
    WritingStyle.casual => 'カジュアル',
  };
}
