import 'package:flutter/material.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/models/localized_text.dart';

// <flubriry:code>
/// A calm progress rail with a marker riding the leading edge.
class ProgressRail extends StatelessWidget {
  const ProgressRail({
    super.key,
    required this.value,
    required this.label,
    this.valueLabel,
    this.color,
  });

  /// A value between 0 and 1.
  final double value;
  final String label;
  final String? valueLabel;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final progress = value.clamp(0.0, 1.0);
    final fillColor = color ?? colors.primary;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final percentLabel = valueLabel ?? '${(progress * 100).round()}%';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colors.onSurface,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              percentLabel,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.78),
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: 11),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.hasBoundedWidth
                ? constraints.maxWidth
                : 280.0;
            return TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (context, animated, _) {
                final fillWidth = width * animated;
                return SizedBox(
                  height: 12,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: isRtl
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: colors.onSurface.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      Container(
                        width: fillWidth,
                        height: 8,
                        decoration: BoxDecoration(
                          color: fillColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      if (fillWidth > 5)
                        Positioned(
                          left: (isRtl ? width - fillWidth - 5 : fillWidth - 5)
                              .clamp(0.0, width - 10),
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: colors.onSurface,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colors.surface,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
// </flubriry:code>

final ComponentMeta componentMeta = ComponentMeta(
  id: 'progress-rail',
  order: 120,
  category: ComponentCategory.states,
  name: const LocalizedText('Progress Rail', 'حالة التقدم'),
  description: const LocalizedText(
    'A calm progress rail with a marker at the leading edge. The fill eases forward; the number stays still and legible.',
    'مسار تقدم هادئ بمؤشر عند حافة الامتلاء. يتقدّم الشريط بنعومة، ويبقى الرقم ثابتًا وواضحًا.',
  ),
  tags: const [
    'progress',
    'loading',
    'upload',
    'meter',
    'feedback',
    'تقدم',
    'تحميل',
    'رفع',
  ],
  contributor: 'alfaresof',
  preview: (context) => const _ProgressPreview(),
);

class _ProgressPreview extends StatelessWidget {
  const _ProgressPreview();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 292,
      child: ProgressRail(value: 0.68, label: context.strings.demoUploading),
    );
  }
}
