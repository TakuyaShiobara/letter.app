import 'package:flutter/material.dart';

import '../models/letter_category.dart';
import 'washi_card.dart';

/// One tile in the home screen's category grid: a thin-line icon above a
/// short label, on a washi card.
class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category, required this.onTap});

  final LetterCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WashiCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            category.icon,
            size: 24,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            category.label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
