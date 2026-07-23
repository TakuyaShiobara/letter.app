import 'letter_category.dart';
import 'writing_style.dart';

/// A pre-written example letter shown in the sample library, used either
/// for reading as-is or as a reference when composing a new letter.
class LetterSample {
  const LetterSample({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.body,
    this.style = WritingStyle.polite,
  });

  final String id;
  final LetterCategory category;
  final String title;
  final String description;
  final String body;
  final WritingStyle style;
}
