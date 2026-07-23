import 'package:flutter/material.dart';

/// A wrapped grid of selectable, mutually-exclusive text options — used for
/// picking the recipient and writing style in the create flow. Deliberately
/// plain: a thin border, small radius, and a filled state on selection. No
/// checkmarks or shadows.
class SelectableOptionGrid<T> extends StatelessWidget {
  const SelectableOptionGrid({
    super.key,
    required this.options,
    required this.labelBuilder,
    required this.selected,
    required this.onSelected,
  });

  final List<T> options;
  final String Function(T) labelBuilder;
  final T? selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((option) {
        final isSelected = option == selected;
        return _OptionChip(
          label: labelBuilder(option),
          selected: isSelected,
          onTap: () => onSelected(option),
        );
      }).toList(),
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? colorScheme.primary : colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? colorScheme.primary : colorScheme.outline,
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
