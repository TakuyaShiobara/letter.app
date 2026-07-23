import 'package:flutter/material.dart';

/// A title, with an optional trailing text action such as "すべて見る".
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(title, style: theme.textTheme.titleMedium),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onActionTap,
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}
