import '../models/recipient_type.dart';
import '../models/writing_style.dart';

/// A single request to compose a new letter.
class LetterDraftRequest {
  const LetterDraftRequest({
    required this.recipient,
    required this.style,
    required this.content,
    this.referenceBody,
    this.variant = 0,
  });

  final RecipientType recipient;
  final WritingStyle style;
  final String content;
  final String? referenceBody;

  /// Bumped on every "re-generate" tap so the same inputs produce a
  /// visibly different phrasing instead of an identical result.
  final int variant;
}

/// Assembles and revises letters from a fixed set of phrase templates.
///
/// There is no network model behind this — it is a deterministic, offline
/// stand-in that mirrors how the real generation feature will behave, so the
/// rest of the app (loading state, result screen, revision flow) can be
/// built and reviewed end-to-end.
class LetterGeneratorService {
  const LetterGeneratorService();

  String generate(LetterDraftRequest request) {
    final topic = _detectTopic('${request.content}\n${request.referenceBody ?? ''}');
    final v = request.variant;

    final buffer = StringBuffer();
    buffer.writeln(_salutation(request.recipient, request.style));
    buffer.writeln();

    final opening = _pick(_openings[request.style]!, v);
    if (opening.isNotEmpty) {
      buffer.writeln(opening);
      buffer.writeln();
    }

    for (final paragraph in _body(topic, request, v)) {
      buffer.writeln(paragraph);
      buffer.writeln();
    }

    buffer.write(_pick(_closings[request.style]!, v));
    return buffer.toString().trim();
  }

  /// Regenerates using the same inputs but the next phrasing variant.
  String regenerate(LetterDraftRequest previous) {
    return generate(
      LetterDraftRequest(
        recipient: previous.recipient,
        style: previous.style,
        content: previous.content,
        referenceBody: previous.referenceBody,
        variant: previous.variant + 1,
      ),
    );
  }

  /// Revises [currentText] according to a free-form or shortcut
  /// [instruction], such as "もっと感動的に" or "季節感を加える".
  String revise({required String currentText, required String instruction}) {
    final text = instruction.trim();

    if (_contains(text, ['最後だけ', '結びを変え', '結びだけ'])) {
      return _replaceClosing(currentText);
    }
    if (_contains(text, ['季節感'])) {
      return _addSeasonalOpening(currentText);
    }
    if (_contains(text, ['敬語を強', 'もっと丁寧', 'フォーマルに'])) {
      return _formalize(currentText);
    }
    if (_contains(text, ['やさしい', '柔らかい', 'やわらかく', '優しい'])) {
      return _soften(currentText);
    }
    if (_contains(text, ['短く', 'コンパクト', '簡潔'])) {
      return _shorten(currentText);
    }
    if (_contains(text, ['感動的', '心に響く'])) {
      return _makeMoreEmotional(currentText);
    }

    // Free-form instruction that doesn't match a known shortcut: apply a
    // gentle, generally-applicable adjustment rather than doing nothing.
    return _softRephrase(currentText);
  }

  // --- topic detection ---------------------------------------------------

  _Topic _detectTopic(String source) {
    for (final entry in _topicKeywords.entries) {
      if (_contains(source, entry.value)) return entry.key;
    }
    return _Topic.general;
  }

  static bool _contains(String source, List<String> keywords) {
    return keywords.any(source.contains);
  }

  static String _pick(List<String> pool, int variant) {
    if (pool.isEmpty) return '';
    return pool[variant % pool.length];
  }

  // --- salutation ----------------------------------------------------------

  String _salutation(RecipientType recipient, WritingStyle style) {
    final formal = style == WritingStyle.veryPolite || style == WritingStyle.polite;
    return switch (recipient) {
      RecipientType.boss => formal ? '○○部長' : '○○さん',
      RecipientType.colleague => '○○さん',
      RecipientType.family => formal ? 'お父さん、お母さんへ' : 'お母さんへ',
      RecipientType.partner => formal ? '○○様' : '○○へ',
      RecipientType.friend => formal ? '○○様' : '○○へ',
      RecipientType.other => '○○様',
    };
  }

  // --- phrase pools ----------------------------------------------------------

  static const Map<WritingStyle, List<String>> _openings = {
    WritingStyle.veryPolite: [
      '拝啓　時下ますますご清祥のこととお慶び申し上げます。',
      '拝啓　貴殿にはますますご健勝のこととお慶び申し上げます。',
    ],
    WritingStyle.polite: [
      'いつも大変お世話になっております。',
      'いつも温かいお心遣いをいただき、ありがとうございます。',
    ],
    WritingStyle.soft: ['お元気にお過ごしでしょうか。', ''],
    WritingStyle.casual: ['', '突然だけど、手紙を書いてみました。'],
  };

  static const Map<WritingStyle, List<String>> _closings = {
    WritingStyle.veryPolite: [
      '末筆ではございますが、皆様のご健勝とご多幸を心よりお祈り申し上げます。\n\n敬具',
      '今後とも変わらぬご厚誼を賜りますよう、よろしくお願い申し上げます。\n\n敬具',
    ],
    WritingStyle.polite: [
      '今後ともどうぞよろしくお願いいたします。',
      'これからも変わらぬお付き合いのほど、よろしくお願いいたします。',
    ],
    WritingStyle.soft: [
      'また近いうちに、ゆっくり話せたら嬉しいです。',
      'これからもどうぞよろしくね。',
    ],
    WritingStyle.casual: ['また今度ゆっくり話そうね。', 'それじゃ、また連絡するね。'],
  };

  static const Map<_Topic, List<String>> _topicKeywords = {
    _Topic.retirement: ['退職', '退社'],
    _Topic.celebration: ['お祝い', 'おめでとう', '結婚', '出産', '昇進', '合格'],
    _Topic.apology: ['お詫び', '謝罪', 'ごめん', '申し訳'],
    _Topic.sympathy: ['お見舞い', '体調', '入院', '被災'],
    _Topic.seasonal: ['暑中', '年末', '母の日', '父の日', '新年', '年始'],
    _Topic.greeting: ['引っ越し', '着任', '異動', 'ご挨拶'],
    _Topic.business: ['打ち合わせ', '契約', '取引', '商談', 'ご紹介'],
    _Topic.gratitude: ['感謝', 'お礼', 'ありがとう'],
  };

  List<String> _body(_Topic topic, LetterDraftRequest request, int variant) {
    final userContent = request.content.trim();
    final intro = _pick(_topicIntros[topic] ?? _topicIntros[_Topic.general]!, variant);
    final elaboration = _pick(
      _topicElaborations[topic] ?? _topicElaborations[_Topic.general]!,
      variant,
    );

    return [
      intro,
      if (userContent.isNotEmpty) userContent,
      elaboration,
    ];
  }

  static const Map<_Topic, List<String>> _topicIntros = {
    _Topic.retirement: [
      'このたび、長年勤めた職場を離れることとなりました。',
      'このたび、これまでお世話になった職場を退くこととなりました。',
    ],
    _Topic.celebration: [
      'このたびは、心よりお祝いを申し上げたく、筆を取りました。',
      'おめでたいお知らせをいただき、私事のように嬉しく思っております。',
    ],
    _Topic.apology: [
      'このたびは、私の至らなさでご迷惑をおかけしましたこと、お詫び申し上げます。',
      '先日のことについて、どうしてもお伝えしたく、お手紙を書いています。',
    ],
    _Topic.sympathy: [
      'このたびのこと、心よりお見舞い申し上げます。',
      'お体の具合を伺い、いてもたってもいられずお手紙を書いております。',
    ],
    _Topic.seasonal: [
      '季節の変わり目、いかがお過ごしでしょうか。',
      '暦の上でも季節が移ろう頃となりました。',
    ],
    _Topic.greeting: [
      'このたびのご報告を兼ねて、お手紙を差し上げます。',
      '新しい節目を迎えるにあたり、ひと言ご挨拶を申し上げます。',
    ],
    _Topic.business: [
      '平素より格別のお引き立てを賜り、厚く御礼申し上げます。',
      '日頃より大変お世話になっております。',
    ],
    _Topic.gratitude: [
      '日頃より温かくしていただいていること、心より感謝しております。',
      'どうしても感謝の気持ちをお伝えしたく、お手紙を書いております。',
    ],
    _Topic.general: [
      'いつも気にかけていただき、ありがとうございます。',
      'こうして手紙を書くのは久しぶりですが、伝えたいことがあります。',
    ],
  };

  static const Map<_Topic, List<String>> _topicElaborations = {
    _Topic.retirement: [
      '至らぬ点も多くあったかと存じますが、いつも温かく支えていただいたこと、本当にありがとうございました。今後も、ここで学んだことを胸に、新たな道でも精一杯努めてまいります。',
      'この場所で過ごした日々は、私にとってかけがえのない時間でした。今後もご指導いただいたことを忘れず、次の一歩を踏み出してまいります。',
    ],
    _Topic.celebration: [
      'これから始まる新しい日々が、明るく穏やかなものでありますように、心よりお祈りしております。',
      '大変な時期もあるかと思いますが、どうかご無理なさらず、この慶びの時間を大切に過ごしてください。',
    ],
    _Topic.apology: [
      '今後は同じことを繰り返さぬよう、心を引き締めて参ります。どうかご容赦いただけますと幸いです。',
      '関係を大切に思っているからこそ、正直な気持ちをお伝えしたいと思いました。',
    ],
    _Topic.sympathy: [
      'どうか無理をなさらず、ご自身のお体を第一にお過ごしください。一日も早い回復を、心よりお祈り申し上げます。',
      '何かできることがあれば、いつでも遠慮なくお申し付けください。',
    ],
    _Topic.seasonal: [
      '寒暖の差が大きい時期ですので、どうぞご自愛くださいませ。',
      '変わらぬ日々の中にも、季節の便りをお届けできれば嬉しく思います。',
    ],
    _Topic.greeting: [
      '至らぬ点も多いかと存じますが、どうぞ変わらぬお付き合いのほど、よろしくお願いいたします。',
      '新しい環境でも精一杯努めてまいりますので、変わらぬご厚誼を賜れますと幸いです。',
    ],
    _Topic.business: [
      '今後とも変わらぬご支援を賜りますよう、よろしくお願い申し上げます。',
      'ご期待に沿えるよう、誠心誠意努めてまいる所存です。',
    ],
    _Topic.gratitude: [
      'このご恩は忘れず、これからも大切にしていきたいと思っています。',
      '言葉では言い尽くせないほどの感謝の気持ちでいっぱいです。',
    ],
    _Topic.general: [
      'これからも変わらず、大切な時間を積み重ねていけたらと思っています。',
      'この気持ちが、少しでも伝わりましたら嬉しく思います。',
    ],
  };

  // --- revision transforms -------------------------------------------------

  static List<String> _paragraphs(String text) =>
      text.split(RegExp(r'\n\s*\n')).map((p) => p.trim()).where((p) => p.isNotEmpty).toList();

  String _shorten(String text) {
    final paragraphs = _paragraphs(text);
    if (paragraphs.length <= 2) {
      final sentences = text.split('。').where((s) => s.trim().isNotEmpty).toList();
      final keep = (sentences.length / 2).ceil().clamp(1, sentences.length);
      return '${sentences.take(keep).join('。')}。';
    }
    final kept = [paragraphs.first, paragraphs.last];
    return kept.join('\n\n');
  }

  String _makeMoreEmotional(String text) {
    final replacements = {
      'ありがとうございました': '本当に、心の底からありがとうございました',
      'ありがとうございます': '言葉にならないほど、ありがとうございます',
      '嬉しく思います': '胸がいっぱいになるほど嬉しく思います',
      '感謝しています': '深く深く感謝しています',
    };
    var result = _applyReplacements(text, replacements);
    if (!result.contains('胸が熱くなり')) {
      result = '$result\n\nこうして言葉にしていても、胸が熱くなります。';
    }
    return result;
  }

  /// Used when the free-form instruction doesn't match a known shortcut.
  /// Softens a few stock connector words so the result still visibly
  /// reflects that a revision was requested.
  String _softRephrase(String text) {
    final replacements = {
      '思っております': '思っています',
      'お慶び申し上げます': '嬉しく思っております',
      '申し上げます': 'いたします',
    };
    return _applyReplacements(text, replacements).trimRight();
  }

  String _formalize(String text) {
    final replacements = {
      'ありがとう': 'ありがとうございます',
      'ごめんね': '申し訳ございません',
      'また今度ゆっくり話そうね。': '末筆ではございますが、皆様のご健勝を心よりお祈り申し上げます。\n\n敬具',
      'それじゃ、また連絡するね。': '今後とも変わらぬご厚誼を賜りますよう、よろしくお願い申し上げます。\n\n敬具',
    };
    var result = _applyReplacements(text, replacements);
    if (!result.startsWith('拝啓')) {
      result = '拝啓　時下ますますご清祥のこととお慶び申し上げます。\n\n$result';
    }
    return result;
  }

  String _soften(String text) {
    var result = text.replaceFirst(RegExp(r'^拝啓[　\s]*.*?。\n*'), '');
    final replacements = {
      '申し上げます': 'ますね',
      '存じます': '思います',
      'いたします': 'しますね',
      '\n\n敬具': '',
    };
    result = _applyReplacements(result, replacements).trimRight();
    if (result.endsWith('具')) {
      result = result.substring(0, result.length - 1);
    }
    return result;
  }

  String _addSeasonalOpening(String text) {
    final month = DateTime.now().month;
    final seasonal = switch (month) {
      3 || 4 || 5 => '桜の便りが聞こえる、うららかな季節となりました。',
      6 || 7 || 8 => '緑がまぶしい季節、いかがお過ごしでしょうか。',
      9 || 10 || 11 => '秋風が心地よい季節となりました。',
      _ => '寒さ厳しき折、いかがお過ごしでしょうか。',
    };
    return '$seasonal\n\n$text';
  }

  String _replaceClosing(String text) {
    final paragraphs = _paragraphs(text);
    if (paragraphs.isEmpty) return text;
    final alternativeClosings = [
      'これからも変わらず、良いお付き合いを続けていけたら嬉しく思います。',
      '今後とも、変わらぬご厚誼のほど、心よりお願い申し上げます。',
    ];
    final replaced = [
      ...paragraphs.sublist(0, paragraphs.length - 1),
      alternativeClosings[DateTime.now().second % alternativeClosings.length],
    ];
    return replaced.join('\n\n');
  }

  static String _applyReplacements(String text, Map<String, String> replacements) {
    var result = text;
    replacements.forEach((from, to) {
      result = result.replaceAll(from, to);
    });
    return result;
  }
}

enum _Topic {
  retirement,
  celebration,
  apology,
  sympathy,
  seasonal,
  greeting,
  business,
  gratitude,
  general,
}
