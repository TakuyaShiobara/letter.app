import 'package:flutter/material.dart';

import '../../data/letter_samples_data.dart';
import '../../models/letter_category.dart';
import '../../models/letter_sample.dart';
import '../../theme/app_theme.dart';
import '../../widgets/category_tile.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/sample_list_tile.dart';
import '../../widgets/section_header.dart';
import '../../widgets/washi_card.dart';
import '../sample_detail/sample_detail_screen.dart';
import '../sample_list/sample_list_screen.dart';

const _popularSampleIds = [
  'gratitude_retirement',
  'gratitude_boss',
  'seasonal_mothers_day',
  'celebration_wedding_reply',
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final popularSamples = _popularSampleIds
        .map((id) => letterSamples.firstWhere((s) => s.id == id))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            FadeSlideIn(child: _Hero(theme: theme)),
            const SizedBox(height: AppSpacing.xl),
            FadeSlideIn(
              delay: const Duration(milliseconds: 60),
              child: Text('どのような手紙を書きますか？', style: theme.textTheme.titleMedium),
            ),
            const SizedBox(height: AppSpacing.md),
            FadeSlideIn(
              delay: const Duration(milliseconds: 100),
              child: _CategoryGrid(),
            ),
            const SizedBox(height: AppSpacing.xl),
            FadeSlideIn(
              delay: const Duration(milliseconds: 140),
              child: SectionHeader(
                title: '人気の文例',
                icon: Icons.auto_awesome_outlined,
                actionLabel: 'すべて見る',
                onActionTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SampleListScreen()),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            FadeSlideIn(
              delay: const Duration(milliseconds: 180),
              child: WashiCard(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  children: [
                    for (var i = 0; i < popularSamples.length; i++) ...[
                      if (i > 0) const Divider(height: 1),
                      SampleTextRow(
                        sample: popularSamples[i],
                        onTap: () => _openSample(context, popularSamples[i]),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSample(BuildContext context, LetterSample sample) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SampleDetailScreen(sample: sample)),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '想いを、\n言葉に。',
          style: theme.textTheme.displaySmall?.copyWith(height: 1.35),
        ),
        const SizedBox(height: AppSpacing.sm),
        Icon(
          Icons.spa_outlined,
          size: 20,
          color: theme.colorScheme.primary.withValues(alpha: 0.7),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '大切な人へ、心を伝えるお手伝いをします。',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: LetterCategory.values.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 0.92,
      ),
      itemBuilder: (context, index) {
        final category = LetterCategory.values[index];
        return CategoryTile(
          category: category,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SampleListScreen(initialCategory: category),
            ),
          ),
        );
      },
    );
  }
}
