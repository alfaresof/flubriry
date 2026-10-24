import 'package:flubriry/views/shared/app_context.dart';
import 'package:flutter/material.dart';

Color stageColor(BuildContext context) => context.palette.stage;

/// The tinted specimen mat used on cards, the featured entry, and detail.
class PreviewStage extends StatelessWidget {
  const PreviewStage({
    super.key,
    required this.child,
    required this.color,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.dots = true,
  });

  final Widget child;
  final Color color;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final bool dots;

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    return ClipRRect(
      borderRadius: borderRadius,
      child: ColoredBox(
        color: color,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (dots)
              CustomPaint(
                painter: DotGridPainter(
                  color: ink.withValues(
                    alpha: Theme.of(context).brightness == Brightness.dark
                        ? 0.055
                        : 0.04,
                  ),
                  spacing: 20,
                ),
              ),
            Padding(
              padding: padding,
              child: Center(
                child: FittedBox(fit: BoxFit.scaleDown, child: child),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DotGridPainter extends CustomPainter {
  const DotGridPainter({required this.color, this.spacing = 18});

  final Color color;
  final double spacing;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (var x = spacing / 2; x < size.width; x += spacing) {
      for (var y = spacing / 2; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.05, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DotGridPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.spacing != spacing;
  }
}
