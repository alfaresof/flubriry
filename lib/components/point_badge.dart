import 'package:flutter/material.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/models/localized_text.dart';

// <flubriry:code>
/// A compact balance with a bright emblem and a quiet label.
class PointBadge extends StatelessWidget {
  const PointBadge({
    super.key,
    required this.value,
    required this.label,
    this.icon = Icons.star_rounded,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Semantics(
      container: true,
      label: '$value $label',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsetsDirectional.only(
          start: 6,
          end: 16,
          top: 6,
          bottom: 6,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: colors.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.1),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, size: 20, color: colors.onPrimary),
            ),
            const SizedBox(width: 11),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colors.onSurface,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                    letterSpacing: 0,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.68),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// </flubriry:code>

final ComponentMeta componentMeta = ComponentMeta(
  id: 'point-badge',
  order: 80,
  category: ComponentCategory.display,
  name: const LocalizedText('Point Badge', 'شارة النقاط'),
  description: const LocalizedText(
    'A compact balance for points, credits, or counts. The amber emblem gives the number a warm place to land.',
    'شارة صغيرة للنقاط أو الأرصدة أو الأعداد. يمنح الشعار الكهرماني الرقم مكانًا دافئًا يستقر فيه.',
  ),
  tags: const [
    'badge',
    'points',
    'stat',
    'display',
    'value',
    'شارة',
    'نقاط',
    'عرض',
  ],
  origin: 'Qafelah',
  preview: (context) => const _PointPreview(),
);

class _PointPreview extends StatelessWidget {
  const _PointPreview();

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return PointBadge(
      value: strings.formatCount(2450),
      label: strings.demoPoints,
    );
  }
}
