import 'dart:convert';

import 'package:http/http.dart' as http;

import 'letter_generation_backend.dart';

/// Calls the Gemini API to draft and revise letters.
///
/// The API key is baked in at build time via `--dart-define=GEMINI_API_KEY=...`
/// (see `letter_generation_backend_factory.dart` and the GitHub Actions
/// workflow) rather than hardcoded here. Note that any key embedded in a
/// client-side app — web or mobile — can be extracted from the compiled
/// output or network traffic by anyone; restrict the key (HTTP referrer /
/// app restrictions in Google Cloud Console) before relying on this for
/// anything beyond a quick trial.
class GeminiLetterService implements LetterGenerationBackend {
  /// If [model] is given (e.g. via `--dart-define=GEMINI_MODEL=...`), only
  /// that model is used — an explicit choice is never silently overridden.
  /// Otherwise this tries [_defaultCandidates] in order and sticks with
  /// whichever first responds, since Google has been retiring specific
  /// model versions for new API keys (flash-lite, then flash, within the
  /// same day) faster than this list can be kept in sync by hand.
  GeminiLetterService({required this.apiKey, String? model})
    : _candidates = (model != null && model.isNotEmpty) ? [model] : List.of(_defaultCandidates);

  final String apiKey;
  final List<String> _candidates;

  static const _defaultCandidates = [
    'gemini-flash-latest',
    'gemini-2.5-flash',
    'gemini-2.5-pro',
    'gemini-2.0-flash',
  ];

  Uri _endpointFor(String model) => Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey',
  );

  @override
  Future<String> generate(LetterDraftRequest request) async {
    final prompt =
        '''
あなたは日本語の手紙代筆のプロです。以下の条件に沿って、心のこもった手紙の本文を作成してください。

【宛先】${request.recipient.label}
【文体】${request.style.label}
【伝えたいこと】
${request.content}
${request.referenceBody != null ? '\n【参考にする文例(雰囲気や構成の参考にしてよい。内容の丸写しはしないこと)】\n${request.referenceBody}\n' : ''}
必ず守ること:
- 出力は手紙の本文のみ。前置き・説明・見出し・Markdown記法(**など)は一切含めない。
- 宛先の相手や指定された文体にふさわしい敬語・言い回しを使う。
- 書き出し・本文・結びのある、手紙として自然な構成にする。
- 名前は伏せ字の「○○」を使う(実在の固有名詞を創作しない)。
''';
    return _call(prompt);
  }

  @override
  Future<String> regenerate(LetterDraftRequest previous) => generate(previous);

  @override
  Future<String> revise({required String currentText, required String instruction}) async {
    final prompt =
        '''
あなたは日本語の手紙代筆のプロです。以下の手紙を、指示に従って書き直してください。

【現在の手紙】
$currentText

【修正の指示】
$instruction

必ず守ること:
- 出力は修正後の手紙本文のみ。前置き・説明・Markdown記法は一切含めない。
- 指示にない部分の雰囲気や事実関係は保つこと。
''';
    return _call(prompt);
  }

  Future<String> _call(String prompt) async {
    Object? lastError;
    // Iterate over a snapshot: a successful call trims _candidates down to
    // just the working model, so later calls in the same session don't
    // keep re-probing ones that are known to be retired.
    for (final model in List<String>.of(_candidates)) {
      try {
        final result = await _callModel(model, prompt);
        _candidates
          ..clear()
          ..add(model);
        return result;
      } on GeminiApiException catch (e) {
        if (!e.modelUnavailable) rethrow;
        lastError = e;
      }
    }
    throw lastError ?? const GeminiApiException('Gemini APIモデル候補が設定されていません。');
  }

  Future<String> _callModel(String model, String prompt) async {
    final response = await http.post(
      _endpointFor(model),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {'temperature': 0.9, 'maxOutputTokens': 1024},
      }),
    );

    if (response.statusCode != 200) {
      throw GeminiApiException(
        'Gemini API error (${response.statusCode}): ${response.body}',
        modelUnavailable: response.statusCode == 404,
      );
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final candidates = decoded['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      throw const GeminiApiException('Gemini API returned no candidates.');
    }

    final parts = (candidates.first as Map<String, dynamic>)['content']?['parts'] as List<dynamic>?;
    final text = parts?.map((p) => p['text'] as String? ?? '').join().trim();
    if (text == null || text.isEmpty) {
      throw const GeminiApiException('Gemini API returned an empty response.');
    }
    return text;
  }
}

class GeminiApiException implements Exception {
  const GeminiApiException(this.message, {this.modelUnavailable = false});

  final String message;

  /// True for a 404 response, which for this API means "this specific
  /// model id is retired/unknown" rather than a general failure — worth
  /// falling through to the next candidate model instead of giving up.
  final bool modelUnavailable;

  @override
  String toString() => message;
}
