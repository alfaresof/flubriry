import 'package:flutter/material.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/models/localized_text.dart';

// <flubriry:code>
/// A deliberately quiet empty state with a stack of blank tiles.
class EmptyNest extends StatelessWidget {
  const EmptyNest({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.maxWidth = 340,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: CustomPaint(
        painter: _DashedBorderPainter(color: colors.outline, radius: 22),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _EmptyNestMark(),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.75),
                  fontSize: 12.5,
                  height: 1.6,
                ),
              ),
              if (actionLabel != null) ...[
                const SizedBox(height: 16),
                Material(
                  color: colors.onSurface,
                  shape: const StadiumBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onAction,
                    customBorder: const StadiumBorder(),
                    focusColor: colors.primary.withValues(alpha: 0.3),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_rounded,
                            size: 16,
                            color: colors.surface,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            actionLabel!,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colors.surface,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyNestMark extends StatelessWidget {
  const _EmptyNestMark();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: 64,
      height: 54,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Transform.rotate(
            angle: -0.12,
            child: Container(
              width: 36,
              height: 28,
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: colors.outline),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(8, -8),
            child: Transform.rotate(
              angle: 0.1,
              child: Container(
                width: 38,
                height: 30,
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.outline),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(-6, -17),
            child: Container(
              width: 40,
              height: 32,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: colors.outline),
              ),
              child: Icon(Icons.add_rounded, size: 17, color: colors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );
    const dash = 5.0;
    const gap = 4.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
// </flubriry:code>

final ComponentMeta componentMeta = ComponentMeta(
  id: 'empty-nest',
  order: 110,
  category: ComponentCategory.states,
  name: const LocalizedText('Empty Nest', 'حالة فراغ'),
  description: const LocalizedText(
    'A quiet page-ending with a dashed frame and a stack of blank tiles. There is one way forward, and it is obvious.',
    'نهاية هادئة للصفحة بإطار متقطّع ورزمة بطاقات فارغة. هناك طريق واحد للمتابعة، وهو واضح.',
  ),
  tags: const [
    'empty state',
    'zero data',
    'placeholder',
    'onboarding',
    'حالة فارغة',
    'لا بيانات',
    'بداية',
  ],
  preview: (context) => const _EmptyPreview(),
);

class _EmptyPreview extends StatelessWidget {
  const _EmptyPreview();

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return SizedBox(
      width: 316,
      child: EmptyNest(
        title: strings.demoEmptyTitle,
        message: strings.demoEmptyBody,
        actionLabel: strings.demoEmptyAction,
        onAction: () {},
      ),
    );
  }
}
