import 'package:flutter/foundation.dart';

import '../models/letter_sample.dart';
import '../models/recipient_type.dart';
import '../models/writing_style.dart';
import '../services/letter_generator_service.dart';

/// Holds the in-progress state for a single letter creation flow — from
/// picking a recipient through to the generated (and possibly revised)
/// result. Scoped to one flow at a time; a fresh instance is created each
/// time the user starts composing a new letter.
class LetterCreationController extends ChangeNotifier {
  LetterCreationController({
    LetterSample? referenceSample,
    this.generator = const LetterGeneratorService(),
  }) : _referenceSample = referenceSample {
    if (referenceSample != null) {
      _style = referenceSample.style;
    }
  }

  final LetterGeneratorService generator;

  RecipientType? _recipient;
  WritingStyle? _style;
  String _content = '';
  LetterSample? _referenceSample;
  String? _generatedText;
  bool _isGenerating = false;
  int _variant = 0;
  LetterDraftRequest? _lastRequest;

  RecipientType? get recipient => _recipient;
  WritingStyle? get style => _style;
  String get content => _content;
  LetterSample? get referenceSample => _referenceSample;
  String? get generatedText => _generatedText;
  bool get isGenerating => _isGenerating;

  bool get canGenerate =>
      _recipient != null && _style != null && _content.trim().isNotEmpty;

  void setRecipient(RecipientType recipient) {
    _recipient = recipient;
    notifyListeners();
  }

  void setStyle(WritingStyle style) {
    _style = style;
    notifyListeners();
  }

  void setContent(String content) {
    _content = content;
    notifyListeners();
  }

  void clearReferenceSample() {
    _referenceSample = null;
    notifyListeners();
  }

  void setReferenceSample(LetterSample sample) {
    _referenceSample = sample;
    _style = sample.style;
    notifyListeners();
  }

  /// Simulates the AI generation step with a short, realistic delay so the
  /// brush-writing loading animation has time to play.
  Future<void> generate() async {
    if (!canGenerate) return;
    _isGenerating = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1800));

    _variant = 0;
    _lastRequest = LetterDraftRequest(
      recipient: _recipient!,
      style: _style!,
      content: _content,
      referenceBody: _referenceSample?.body,
      variant: _variant,
    );
    _generatedText = generator.generate(_lastRequest!);
    _isGenerating = false;
    notifyListeners();
  }

  Future<void> regenerate() async {
    if (_lastRequest == null) return;
    _isGenerating = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1400));

    _variant += 1;
    _lastRequest = LetterDraftRequest(
      recipient: _lastRequest!.recipient,
      style: _lastRequest!.style,
      content: _lastRequest!.content,
      referenceBody: _lastRequest!.referenceBody,
      variant: _variant,
    );
    _generatedText = generator.generate(_lastRequest!);
    _isGenerating = false;
    notifyListeners();
  }

  Future<void> revise(String instruction) async {
    if (_generatedText == null || instruction.trim().isEmpty) return;
    _isGenerating = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    _generatedText = generator.revise(
      currentText: _generatedText!,
      instruction: instruction,
    );
    _isGenerating = false;
    notifyListeners();
  }
}
