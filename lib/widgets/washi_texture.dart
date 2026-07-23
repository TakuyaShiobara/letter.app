import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Wraps [child] with a faint, static fiber texture reminiscent of washi
/// paper. Kept extremely subtle — this is a texture, not a pattern — and
/// deterministic (fixed seed) so it never distracts or flickers on rebuild.
class WashiTexture extends StatelessWidget {
  const WashiTexture({
    super.key,
    required this.child,
    this.borderRadius,
    this.opacity = 0.05,
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final fiberColor = Theme.of(context).colorScheme.onSurface;
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _WashiFiberPainter(
                  color: fiberColor.withValues(alpha: opacity),
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _WashiFiberPainter extends CustomPainter {
  _WashiFiberPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(7);
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;

    final fiberCount = (size.width * size.height / 1400).clamp(24, 220).toInt();
    for (var i = 0; i < fiberCount; i++) {
      final start = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
      final angle = random.nextDouble() * math.pi;
      final length = 3 + random.nextDouble() * 9;
      final end = start + Offset(math.cos(angle), math.sin(angle)) * length;
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WashiFiberPainter oldDelegate) =>
      oldDelegate.color != color;
}
