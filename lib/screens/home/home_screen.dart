import 'package:flutter/material.dart';

import '../../models/letter_category.dart';
import '../../theme/app_theme.dart';
import '../../widgets/category_tile.dart';
import '../../widgets/fade_slide_in.dart';
import '../sample_list/sample_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          ],
        ),
      ),
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
