import 'package:flutter/foundation.dart';

import '../models/letter_sample.dart';
import '../models/recipient_type.dart';
import '../models/writing_style.dart';
import '../services/letter_generation_backend.dart';
import '../services/letter_generation_backend_factory.dart';

/// Holds the in-progress state for a single letter creation flow — from
/// picking a recipient through to the generated (and possibly revised)
/// result. Scoped to one flow at a time; a fresh instance is created each
/// time the user starts composing a new letter.
class LetterCreationController extends ChangeNotifier {
  LetterCreationController({
    LetterSample? referenceSample,
    LetterGenerationBackend? backend,
  }) : _referenceSample = referenceSample,
       backend = backend ?? createDefaultLetterGenerationBackend() {
    if (referenceSample != null) {
      _style = referenceSample.style;
    }
  }

  final LetterGenerationBackend backend;

  RecipientType? _recipient;
  WritingStyle? _style;
  String _content = '';
  LetterSample? _referenceSample;
  String? _generatedText;
  bool _isGenerating = false;
  String? _errorMessage;
  LetterDraftRequest? _lastRequest;

  RecipientType? get recipient => _recipient;
  WritingStyle? get style => _style;
  String get content => _content;
  LetterSample? get referenceSample => _referenceSample;
  String? get generatedText => _generatedText;
  bool get isGenerating => _isGenerating;
  String? get errorMessage => _errorMessage;

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

  Future<void> generate() async {
    if (!canGenerate) return;
    _isGenerating = true;
    _errorMessage = null;
    notifyListeners();

    _lastRequest = LetterDraftRequest(
      recipient: _recipient!,
      style: _style!,
      content: _content,
      referenceBody: _referenceSample?.body,
    );

    try {
      _generatedText = await _withMinDelay(backend.generate(_lastRequest!));
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isGenerating = false;
    notifyListeners();
  }

  Future<void> regenerate() async {
    if (_lastRequest == null) return;
    _isGenerating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final next = await _withMinDelay(backend.regenerate(_lastRequest!));
      _lastRequest = LetterDraftRequest(
        recipient: _lastRequest!.recipient,
        style: _lastRequest!.style,
        content: _lastRequest!.content,
        referenceBody: _lastRequest!.referenceBody,
        variant: _lastRequest!.variant + 1,
      );
      _generatedText = next;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isGenerating = false;
    notifyListeners();
  }

  Future<void> revise(String instruction) async {
    if (_generatedText == null || instruction.trim().isEmpty) return;
    _isGenerating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _generatedText = await _withMinDelay(
        backend.revise(currentText: _generatedText!, instruction: instruction),
      );
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isGenerating = false;
    notifyListeners();
  }

  /// Keeps the brush-writing loading animation visible for at least
  /// [minDuration], regardless of how fast the backend actually responds.
  static Future<T> _withMinDelay<T>(
    Future<T> future, [
    Duration minDuration = const Duration(milliseconds: 900),
  ]) async {
    final results = await Future.wait([future, Future.delayed(minDuration)]);
    return results[0] as T;
  }
}
