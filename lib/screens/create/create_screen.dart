import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/letter_sample.dart';
import '../../models/recipient_type.dart';
import '../../models/writing_style.dart';
import '../../state/letter_creation_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/selectable_option_grid.dart';
import '../../widgets/step_indicator.dart';
import '../../widgets/washi_card.dart';
import '../result/result_screen.dart';
import '../sample_list/sample_list_screen.dart';

/// Step 1 of the creation flow: who the letter is for, its tone, and what
/// the user wants to say. Generating navigates to [ResultScreen], which
/// shares the same [LetterCreationController] instance.
class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key, this.referenceSample});

  final LetterSample? referenceSample;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LetterCreationController(referenceSample: referenceSample),
      child: const _CreateView(),
    );
  }
}

class _CreateView extends StatefulWidget {
  const _CreateView();

  @override
  State<_CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<_CreateView> {
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    final controller = context.read<LetterCreationController>();
    _contentController = TextEditingController(text: controller.content);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickReferenceSample(LetterCreationController controller) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SampleListScreen(
          onSelect: (sample) {
            controller.setReferenceSample(sample);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _generate(LetterCreationController controller) async {
    if (!controller.canGenerate) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: controller,
          child: const ResultScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LetterCreationController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('手紙を作成')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: const StepIndicator(
                steps: ['入力', '生成', '完成'],
                currentIndex: 0,
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                children: [
                  if (controller.referenceSample != null) ...[
                    FadeSlideIn(
                      child: _ReferenceBanner(
                        sample: controller.referenceSample!,
                        onClear: controller.clearReferenceSample,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  FadeSlideIn(
                    child: Text('相手は誰ですか？', style: theme.textTheme.titleMedium),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 40),
                    child: SelectableOptionGrid<RecipientType>(
                      options: RecipientType.values,
                      labelBuilder: (r) => r.label,
                      selected: controller.recipient,
                      onSelected: controller.setRecipient,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 80),
                    child: Text('文体を選んでください', style: theme.textTheme.titleMedium),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 120),
                    child: SelectableOptionGrid<WritingStyle>(
                      options: WritingStyle.values,
                      labelBuilder: (s) => s.label,
                      selected: controller.style,
                      onSelected: controller.setStyle,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 160),
                    child: Text(
                      '伝えたいことを教えてください（自由入力）',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 200),
                    child: TextField(
                      controller: _contentController,
                      onChanged: controller.setContent,
                      maxLines: 5,
                      maxLength: 200,
                      decoration: const InputDecoration(
                        hintText: '例）3年間お世話になった上司への退職の挨拶と、\n感謝の気持ちを伝えたいです。',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 240),
                    child: OutlinedButton.icon(
                      onPressed: () => _pickReferenceSample(controller),
                      icon: const Icon(Icons.menu_book_outlined, size: 18),
                      label: const Text('文例を参考にする'),
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
              child: FilledButton(
                onPressed: controller.canGenerate
                    ? () => _generate(controller)
                    : null,
                child: const Text('この内容で生成する'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReferenceBanner extends StatelessWidget {
  const _ReferenceBanner({required this.sample, required this.onClear});

  final LetterSample sample;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WashiCard(
      child: Row(
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 18,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: theme.textTheme.bodySmall,
                children: [
                  const TextSpan(text: '参考にする文例：'),
                  TextSpan(
                    text: sample.title,
                    style: theme.textTheme.labelLarge,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: onClear,
            icon: const Icon(Icons.close, size: 18),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
