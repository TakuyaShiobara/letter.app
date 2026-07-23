import 'gemini_letter_service.dart';
import 'letter_generation_backend.dart';
import 'letter_generator_service.dart';

/// Injected at build time with `--dart-define=GEMINI_API_KEY=...` (the
/// GitHub Actions deploy workflow reads it from a repository secret so the
/// key never lives in source control). Empty when not provided.
const String _geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

/// Optional `--dart-define=GEMINI_MODEL=...` override, so the model can be
/// changed without a code edit. Falls back to [GeminiLetterService]'s
/// default when not provided.
const String _geminiModel = String.fromEnvironment('GEMINI_MODEL');

/// Picks the letter-generation backend for the app: Gemini when an API key
/// was supplied at build time, otherwise the offline template engine so the
/// app still works end-to-end without one.
LetterGenerationBackend createDefaultLetterGenerationBackend() {
  if (_geminiApiKey.isNotEmpty) {
    return _geminiModel.isNotEmpty
        ? GeminiLetterService(apiKey: _geminiApiKey, model: _geminiModel)
        : GeminiLetterService(apiKey: _geminiApiKey);
  }
  return const LetterGeneratorService();
}
