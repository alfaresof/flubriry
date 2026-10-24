import 'package:flutter/material.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/models/localized_text.dart';

// <flubriry:code>
/// A friendly lock for subscriber-only content, with one clear way in.
class AccessGate extends StatelessWidget {
  const AccessGate({
    super.key,
    required this.title,
    required this.message,
    required this.actionLabel,
    this.onAction,
    this.icon = Icons.lock_outline_rounded,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 340),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 21, color: colors.onPrimaryContainer),
            ),
            const SizedBox(height: 14),
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
            const SizedBox(height: 5),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.72),
                fontSize: 12,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            Material(
              color: colors.primary,
              shape: const StadiumBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onAction,
                customBorder: const StadiumBorder(),
                focusColor: colors.onPrimary.withValues(alpha: 0.24),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock_open_rounded,
                        size: 15,
                        color: colors.onPrimary,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        actionLabel,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colors.onPrimary,
                          fontSize: 12,
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
        ),
      ),
    );
  }
}
// </flubriry:code>

final ComponentMeta componentMeta = ComponentMeta(
  id: 'access-gate',
  order: 150,
  category: ComponentCategory.states,
  name: const LocalizedText('Access Gate', 'بوابة العضوية'),
  description: const LocalizedText(
    'A friendly lock for subscriber-only content, with one clear way in.',
    'قفل ودود للمحتوى المخصص للأعضاء، مع طريق واحد واضح للدخول.',
  ),
  tags: const [
    'lock',
    'paywall',
    'membership',
    'access',
    'قفل',
    'عضوية',
    'وصول',
  ],
  contributor: 'alfaresof',
  preview: (context) => const _AccessPreview(),
);

class _AccessPreview extends StatelessWidget {
  const _AccessPreview();

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return SizedBox(
      width: 314,
      child: AccessGate(
        title: strings.demoAccessTitle,
        message: strings.demoAccessBody,
        actionLabel: strings.demoUnlock,
        onAction: () {},
      ),
    );
  }
}
