import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../state/letter_creation_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/ink_brush_loader.dart';
import '../../widgets/letter_paper.dart';
import '../ai_edit/ai_edit_screen.dart';

/// Step 3 of the creation flow: shows the generated letter on a stationery
/// sheet, with actions to copy it, regenerate, or refine it with AI修正.
class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String? _lastShownError;

  @override
  void initState() {
    super.initState();
    final controller = context.read<LetterCreationController>();
    if (controller.generatedText == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => controller.generate());
    }
  }

  Future<void> _copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('文章をコピーしました')),
    );
  }

  void _maybeShowErrorSnackBar(LetterCreationController controller) {
    final error = controller.errorMessage;
    // Only surface as a transient SnackBar when a letter is already on
    // screen (regenerate/revise failure) — the initial-generation failure
    // gets its own full error state below instead.
    if (error == null || error == _lastShownError || controller.generatedText == null) {
      return;
    }
    _lastShownError = error;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LetterCreationController>();
    final theme = Theme.of(context);
    _maybeShowErrorSnackBar(controller);

    final hasInitialError =
        !controller.isGenerating && controller.generatedText == null && controller.errorMessage != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('生成結果'),
        actions: [
          IconButton(
            tooltip: 'ホームに戻る',
            icon: const Icon(Icons.home_outlined),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
                  child: controller.isGenerating
                      ? const Center(
                          key: ValueKey('loading'),
                          child: InkBrushLoader(),
                        )
                      : hasInitialError
                      ? _ErrorState(
                          key: const ValueKey('error'),
                          message: controller.errorMessage!,
                          onRetry: controller.generate,
                        )
                      : controller.generatedText == null
                      ? const Center(
                          key: ValueKey('loading'),
                          child: InkBrushLoader(),
                        )
                      : SingleChildScrollView(
                          key: const ValueKey('result'),
                          child: FadeSlideIn(
                            child: LetterPaper(
                              showSeal: true,
                              child: SelectableText(
                                controller.generatedText!,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (!controller.isGenerating && controller.generatedText != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ResultAction(
                      icon: Icons.copy_outlined,
                      label: 'コピー',
                      onTap: () => _copy(controller.generatedText!),
                    ),
                    _ResultAction(
                      icon: Icons.refresh,
                      label: '再生成',
                      onTap: controller.regenerate,
                    ),
                    _ResultAction(
                      icon: Icons.edit_outlined,
                      label: 'AIで修正',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: controller,
                            child: const AiEditScreen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 32,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '文章の生成に失敗しました',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('もう一度試す'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultAction extends StatelessWidget {
  const _ResultAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.outline),
                ),
                child: Icon(icon, size: 20, color: colorScheme.primary),
              ),
              const SizedBox(height: 8),
              Text(label, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ),
      ),
    );
  }
}
