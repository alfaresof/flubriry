import 'package:flutter/material.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/models/localized_text.dart';

// <flubriry:code>
/// A compact membership pass: the plan, its price, and one quiet action.
class PlanPass extends StatelessWidget {
  const PlanPass({
    super.key,
    required this.title,
    required this.price,
    required this.renewal,
    required this.actionLabel,
    this.onAction,
    this.icon = Icons.workspace_premium_rounded,
  });

  final String title;
  final String price;
  final String renewal;
  final String actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      constraints: const BoxConstraints(maxWidth: 340),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 24, color: colors.onPrimary),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  price,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colors.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  renewal,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.7),
                    fontSize: 10.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 9),
          Material(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(9),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(9),
              focusColor: colors.primary.withValues(alpha: 0.24),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Text(
                  actionLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.onPrimaryContainer,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// </flubriry:code>

final ComponentMeta componentMeta = ComponentMeta(
  id: 'plan-pass',
  order: 140,
  category: ComponentCategory.display,
  name: const LocalizedText('Plan Pass', 'بطاقة الاشتراك'),
  description: const LocalizedText(
    'A compact membership pass: the plan, what it costs, and when it renews, with one quiet action. From Khaber subscriptions.',
    'بطاقة عضوية صغيرة: الخطة وسعرها وموعد تجديدها، مع إجراء واحد هادئ. من اشتراكات خبر.',
  ),
  tags: const [
    'plan',
    'subscription',
    'membership',
    'crown',
    'khaber',
    'اشتراك',
    'عضوية',
    'خبر',
  ],
  origin: 'Khaber',
  preview: (context) => const _PlanPreview(),
);

class _PlanPreview extends StatelessWidget {
  const _PlanPreview();

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return SizedBox(
      width: 322,
      child: PlanPass(
        title: strings.demoPlanName,
        price: strings.demoPlanPrice,
        renewal: strings.demoPlanRenewal,
        actionLabel: strings.demoManage,
        onAction: () {},
      ),
    );
  }
}
