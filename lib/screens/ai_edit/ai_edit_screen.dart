import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/letter_creation_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/washi_card.dart';

const _shortcuts = <String>[
  'もっと感動的に',
  'やわらかい雰囲気に',
  'もう少し短く',
  '敬語を強めて',
  '季節感を加えて',
];

/// Step used from the result screen to refine the generated letter with a
/// free-form instruction or one of a handful of shortcut chips.
class AiEditScreen extends StatefulWidget {
  const AiEditScreen({super.key});

  @override
  State<AiEditScreen> createState() => _AiEditScreenState();
}

class _AiEditScreenState extends State<AiEditScreen> {
  final _instructionController = TextEditingController();
  bool _showFullText = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _instructionController.dispose();
    super.dispose();
  }

  Future<void> _submit(LetterCreationController controller) async {
    final instruction = _instructionController.text.trim();
    if (instruction.isEmpty || _isSubmitting) return;

    setState(() => _isSubmitting = true);
    await controller.revise(instruction);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LetterCreationController>();
    final theme = Theme.of(context);
    final currentText = controller.generatedText ?? '';
    final isLong = currentText.length > 90;
    final preview = !isLong || _showFullText
        ? currentText
        : '${currentText.substring(0, 90)}…';

    return Scaffold(
      appBar: AppBar(title: const Text('AIで修正')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                children: [
                  FadeSlideIn(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('現在の文章', style: theme.textTheme.titleMedium),
                        ),
                        if (isLong)
                          TextButton(
                            onPressed: () =>
                                setState(() => _showFullText = !_showFullText),
                            child: Text(_showFullText ? '折りたたむ' : '全文を表示'),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 40),
                    child: WashiCard(child: Text(preview, style: theme.textTheme.bodyMedium)),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 80),
                    child: Icon(
                      Icons.arrow_downward,
                      size: 18,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 120),
                    child: Text('どう修正しますか？', style: theme.textTheme.titleMedium),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 160),
                    child: TextField(
                      controller: _instructionController,
                      maxLines: 3,
                      maxLength: 200,
                      decoration: const InputDecoration(
                        hintText: '例）もっと感動的に／もう少し短く／敬語を強めて／\n優しい雰囲気に／最後だけ変更して',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 200),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _shortcuts.map((shortcut) {
                        return _ShortcutChip(
                          label: shortcut,
                          onTap: () => setState(() {
                            _instructionController.text = shortcut;
                          }),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: FilledButton.icon(
                onPressed: _isSubmitting ? null : () => _submit(controller),
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome, size: 18),
                label: Text(_isSubmitting ? '修正しています…' : '修正する'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShortcutChip extends StatelessWidget {
  const _ShortcutChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: colorScheme.outline),
          ),
          child: Text(label, style: Theme.of(context).textTheme.labelMedium),
        ),
      ),
    );
  }
}
