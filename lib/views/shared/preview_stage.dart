import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flutter/material.dart';

Color categoryMat(BuildContext context, ComponentCategory category) {
  final palette = context.palette;
  final base = switch (category) {
    ComponentCategory.buttons => palette.matButtons,
    ComponentCategory.inputs => palette.matInputs,
    ComponentCategory.navigation => palette.matNavigation,
    ComponentCategory.display => palette.matDisplay,
    ComponentCategory.states => palette.matStates,
  };
  // A barely-there wash of the selected accent keeps the whole grid in tune
  // without sacrificing the category tints.
  final strength = Theme.of(context).brightness == Brightness.dark
      ? 0.06
      : 0.05;
  return Color.alphaBlend(palette.accent.withValues(alpha: strength), base);
}

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
                  color: ink.withValues(alpha: 0.075),
                  spacing: 18,
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
