import 'package:flutter/material.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/models/localized_text.dart';

// <flubriry:code>
/// A title, a short body, and an optional action, stacked with enough air
/// to let the words lead.
class TitleStack extends StatelessWidget {
  const TitleStack({
    super.key,
    required this.title,
    required this.body,
    this.action,
    this.maxWidth = 460,
    this.alignment = CrossAxisAlignment.start,
  });

  final String title;
  final String body;
  final Widget? action;
  final double maxWidth;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final textAlign = switch (alignment) {
      CrossAxisAlignment.center => TextAlign.center,
      CrossAxisAlignment.end => TextAlign.end,
      _ => TextAlign.start,
    };

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: alignment,
        children: [
          Text(
            title,
            textAlign: textAlign,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colors.onSurface,
              fontSize: 30,
              height: isRtl ? 1.35 : 1.1,
              letterSpacing: isRtl ? 0 : -0.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            body,
            textAlign: textAlign,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurface.withValues(alpha: 0.72),
              fontSize: 14.5,
              height: isRtl ? 1.85 : 1.7,
            ),
          ),
          if (action != null) ...[const SizedBox(height: 16), action!],
        ],
      ),
    );
  }
}
// </flubriry:code>

final ComponentMeta componentMeta = ComponentMeta(
  id: 'title-stack',
  order: 90,
  category: ComponentCategory.display,
  name: const LocalizedText('Title Stack', 'كتلة العنوان'),
  description: const LocalizedText(
    'A title, a short body, and room for an action. The line height changes for Arabic so the block keeps the same calm rhythm.',
    'عنوان ونص قصير ومساحة لإجراء. يتغيّر ارتفاع السطر في العربية لتحافظ الكتلة على إيقاعها الهادئ.',
  ),
  tags: const [
    'title',
    'copy',
    'layout',
    'display',
    'typography',
    'عنوان',
    'نص',
    'تنسيق',
  ],
  contributor: 'alfaresof',
  preview: (context) => const _TitlePreview(),
);

class _TitlePreview extends StatelessWidget {
  const _TitlePreview();

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return SizedBox(
      width: 300,
      child: TitleStack(
        title: strings.demoStoryTitle,
        body: strings.demoStoryBody,
      ),
    );
  }
}
