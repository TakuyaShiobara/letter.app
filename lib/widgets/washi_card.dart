import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'washi_texture.dart';

/// The base surface used across the app: a washi-textured card with a thin
/// border, small corner radius, and no shadow. Every list item, section and
/// panel is built on top of this.
class WashiCard extends StatelessWidget {
  const WashiCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.onTap,
    this.borderRadius,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final radius = borderRadius ?? BorderRadius.circular(AppRadius.md);

    final content = WashiTexture(
      borderRadius: radius,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: radius,
          border: Border.all(color: colorScheme.outline),
        ),
        padding: padding,
        child: child,
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: content,
      ),
    );
  }
}
