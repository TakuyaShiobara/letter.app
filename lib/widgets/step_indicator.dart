import 'package:flutter/material.dart';

/// The three-step progress marker shown at the top of the creation flow:
/// 入力 → 生成 → 完成.
class StepIndicator extends StatelessWidget {
  const StepIndicator({
    super.key,
    required this.steps,
    required this.currentIndex,
  });

  final List<String> steps;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                color: i <= currentIndex
                    ? colorScheme.primary
                    : colorScheme.outline,
              ),
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StepDot(
                label: '${i + 1}',
                active: i <= currentIndex,
                current: i == currentIndex,
              ),
              const SizedBox(height: 6),
              Text(
                steps[i],
                style: theme.textTheme.labelSmall?.copyWith(
                  color: i <= currentIndex
                      ? colorScheme.primary
                      : theme.textTheme.labelSmall?.color,
                  fontWeight: i == currentIndex ? FontWeight.w700 : null,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.label,
    required this.active,
    required this.current,
  });

  final String label;
  final bool active;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? colorScheme.primary : Colors.transparent,
        border: Border.all(
          color: active ? colorScheme.primary : colorScheme.outline,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: active ? colorScheme.onPrimary : colorScheme.onSurface,
        ),
      ),
    );
  }
}
