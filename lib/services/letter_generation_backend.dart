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

  /// Bumped on every "re-generate" tap. The template backend uses this to
  /// pick a different phrase variant; an LLM backend can ignore it since a
  /// fresh call already varies naturally.
  final int variant;
}

/// Something that can draft and revise letters. Swappable so the app can run
/// against a real model (see [GeminiLetterService]) or, absent an API key,
/// fall back to the deterministic [LetterGeneratorService].
abstract class LetterGenerationBackend {
  Future<String> generate(LetterDraftRequest request);

  Future<String> regenerate(LetterDraftRequest previous);

  Future<String> revise({required String currentText, required String instruction});
}
