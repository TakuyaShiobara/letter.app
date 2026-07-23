import 'package:flutter/material.dart';

import '../../models/letter_sample.dart';
import '../../theme/app_theme.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/letter_paper.dart';
import '../create/create_screen.dart';

class SampleDetailScreen extends StatelessWidget {
  const SampleDetailScreen({super.key, required this.sample});

  final LetterSample sample;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('文例詳細')),
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
                    child: Text(sample.title, style: theme.textTheme.headlineSmall),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 40),
                    child: Text(sample.description, style: theme.textTheme.bodyMedium),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 80),
                    child: _StyleBadge(label: sample.style.label),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 120),
                    child: LetterPaper(
                      child: Text(
                        sample.body,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: FilledButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateScreen(referenceSample: sample),
                  ),
                ),
                child: const Text('この文例をもとに作成'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StyleBadge extends StatelessWidget {
  const _StyleBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$label な文体',
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: colorScheme.primary),
      ),
    );
  }
}
