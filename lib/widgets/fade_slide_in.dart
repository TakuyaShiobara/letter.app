import 'package:flutter/material.dart';

/// A gentle, one-shot fade + upward slide used to bring content onto the
/// screen calmly — the only kind of entrance motion this app uses.
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 420),
    this.offset = 0.06,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration + delay,
      curve: Interval(
        (delay.inMilliseconds / (duration + delay).inMilliseconds).clamp(
          0,
          1,
        ),
        1,
        curve: Curves.easeOut,
      ),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, offset * 100 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
