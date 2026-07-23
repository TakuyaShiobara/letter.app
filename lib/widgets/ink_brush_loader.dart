import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A loading indicator that traces a calligraphy-like stroke, as if a brush
/// were writing the letter — used while the letter is being generated.
class InkBrushLoader extends StatefulWidget {
  const InkBrushLoader({super.key, this.label = '文章を作成しています…'});

  final String label;

  @override
  State<InkBrushLoader> createState() => _InkBrushLoaderState();
}

class _InkBrushLoaderState extends State<InkBrushLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 140,
          height: 70,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: _BrushStrokePainter(
                  progress: _controller.value,
                  color: colorScheme.primary,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(widget.label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _BrushStrokePainter extends CustomPainter {
  _BrushStrokePainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.06, size.height * 0.75)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.15,
        size.width * 0.38,
        size.height * 0.95,
        size.width * 0.55,
        size.height * 0.35,
      )
      ..cubicTo(
        size.width * 0.68,
        size.height * -0.05,
        size.width * 0.82,
        size.height * 0.85,
        size.width * 0.96,
        size.height * 0.45,
      );

    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final totalLength = metrics.fold<double>(0, (sum, m) => sum + m.length);

    // A stroke that grows then fully retraces, evoking a brush lifting off
    // the page and beginning the next line — a slow, calm loop.
    final t = progress < 0.7 ? (progress / 0.7) : 1.0;
    final targetLength = totalLength * t;
    final fadeOut = progress > 0.85 ? (1 - (progress - 0.85) / 0.15) : 1.0;

    var remaining = targetLength;
    for (final metric in metrics) {
      if (remaining <= 0) break;
      final drawLength = remaining.clamp(0, metric.length).toDouble();
      final extracted = metric.extractPath(0, drawLength);

      final paint = Paint()
        ..color = color.withValues(alpha: 0.75 * fadeOut)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = 3.2;
      canvas.drawPath(extracted, paint);

      remaining -= metric.length;
    }
  }

  @override
  bool shouldRepaint(covariant _BrushStrokePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
