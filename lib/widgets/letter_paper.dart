import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'washi_texture.dart';

/// Renders letter content on a stationery-like sheet: washi texture, a thin
/// border, a faint plum-branch flourish in the corner, and generous inner
/// margins — as if the text were written on a fine letterhead.
class LetterPaper extends StatelessWidget {
  const LetterPaper({
    super.key,
    required this.child,
    this.showFlourish = true,
    this.showSeal = false,
  });

  final Widget child;
  final bool showFlourish;
  final bool showSeal;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AppRadius.md);

    return WashiTexture(
      borderRadius: radius,
      opacity: 0.06,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: radius,
          border: Border.all(color: colorScheme.outline),
        ),
        child: Stack(
          children: [
            if (showFlourish)
              Positioned(
                top: 0,
                right: 0,
                child: IgnorePointer(
                  child: CustomPaint(
                    size: const Size(96, 96),
                    painter: _PlumBranchPainter(color: colorScheme.primary),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  child,
                  if (showSeal) ...[
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _HankoSeal(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A minimal decorative branch with a few blossoms, echoing the washi /
/// ichi-fusen reference imagery without importing any image assets.
class _PlumBranchPainter extends CustomPainter {
  _PlumBranchPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final branchPaint = Paint()
      ..color = color.withValues(alpha: 0.28)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.95, size.height * 0.05)
      ..cubicTo(
        size.width * 0.7,
        size.height * 0.2,
        size.width * 0.55,
        size.height * 0.3,
        size.width * 0.35,
        size.height * 0.55,
      );
    canvas.drawPath(path, branchPaint);

    final twigPaint = Paint()
      ..color = color.withValues(alpha: 0.22)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.6, size.height * 0.24),
      Offset(size.width * 0.72, size.height * 0.1),
      twigPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.44, size.height * 0.46),
      Offset(size.width * 0.3, size.height * 0.36),
      twigPaint,
    );

    final blossomPaint = Paint()..color = color.withValues(alpha: 0.32);
    final blossomSpots = [
      Offset(size.width * 0.74, size.height * 0.09),
      Offset(size.width * 0.62, size.height * 0.23),
      Offset(size.width * 0.31, size.height * 0.35),
      Offset(size.width * 0.35, size.height * 0.55),
    ];
    for (final spot in blossomSpots) {
      _drawBlossom(canvas, spot, 3.2, blossomPaint);
    }
  }

  void _drawBlossom(Canvas canvas, Offset center, double radius, Paint paint) {
    for (var i = 0; i < 5; i++) {
      final angle = (math.pi * 2 / 5) * i;
      final petalCenter = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      canvas.drawCircle(petalCenter, radius * 0.7, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PlumBranchPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _HankoSeal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFA13B2E).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '印',
        style: TextStyle(
          color: AppColors.washi,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
