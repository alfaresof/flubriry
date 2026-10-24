import 'package:flutter/material.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/models/localized_text.dart';

// <flubriry:code>
class SegmentOption {
  const SegmentOption({required this.label, this.icon});

  final String label;
  final IconData? icon;
}

/// A compact two-or-more way switch with a thumb that travels on an ease.
class SegmentSwitch extends StatelessWidget {
  const SegmentSwitch({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
    this.width,
  });

  final List<SegmentOption> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final safeIndex = options.isEmpty
        ? 0
        : selectedIndex.clamp(0, options.length - 1);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : width ?? 280;
        final thumbWidth = options.isEmpty
            ? 0.0
            : (available - 8) / options.length;
        final thumbLeft = isRtl
            ? available - 8 - thumbWidth * (safeIndex + 1)
            : thumbWidth * safeIndex;

        return SizedBox(
          width: available,
          height: 50,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.outlineVariant),
            ),
            child: Stack(
              children: [
                if (options.isNotEmpty)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    left: thumbLeft,
                    top: 0,
                    bottom: 0,
                    width: thumbWidth,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: colors.shadow.withValues(alpha: 0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned.fill(
                  child: Row(
                    children: [
                      for (var index = 0; index < options.length; index++)
                        Expanded(
                          child: Semantics(
                            button: true,
                            selected: index == safeIndex,
                            label: options[index].label,
                            excludeSemantics: true,
                            onTap: () => onChanged(index),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => onChanged(index),
                                customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusColor: colors.onSurface.withValues(
                                  alpha: 0.14,
                                ),
                                hoverColor: Colors.transparent,
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (options[index].icon != null) ...[
                                        Icon(
                                          options[index].icon,
                                          size: 17,
                                          color: index == safeIndex
                                              ? colors.onPrimary
                                              : colors.onSurface.withValues(
                                                  alpha: 0.68,
                                                ),
                                        ),
                                        const SizedBox(width: 7),
                                      ],
                                      AnimatedDefaultTextStyle(
                                        duration: const Duration(
                                          milliseconds: 180,
                                        ),
                                        style: theme.textTheme.labelMedium!
                                            .copyWith(
                                              color: index == safeIndex
                                                  ? colors.onPrimary
                                                  : colors.onSurface.withValues(
                                                      alpha: 0.72,
                                                    ),
                                              fontSize: 12.5,
                                              fontWeight: index == safeIndex
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                              letterSpacing: 0,
                                              height: 1.1,
                                            ),
                                        child: Text(options[index].label),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
// </flubriry:code>

final ComponentMeta componentMeta = ComponentMeta(
  id: 'segment-switch',
  order: 70,
  category: ComponentCategory.navigation,
  name: const LocalizedText('Segment Switch', 'قائمة انتقال'),
  description: const LocalizedText(
    'A small room with two doors. The amber thumb glides to the chosen side, and the direction reverses correctly in Arabic.',
    'غرفة صغيرة ببابين. ينزلق المقبض الكهرماني إلى الجهة المختارة، وينعكس اتجاهه تلقائيًا في العربية.',
  ),
  tags: const [
    'segmented',
    'switch',
    'tabs',
    'navigation',
    'rtl',
    'تبديل',
    'أقسام',
    'تنقل',
  ],
  preview: (context) => const _SegmentPreview(),
);

class _SegmentPreview extends StatefulWidget {
  const _SegmentPreview();

  @override
  State<_SegmentPreview> createState() => _SegmentPreviewState();
}

class _SegmentPreviewState extends State<_SegmentPreview> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return SizedBox(
      width: 268,
      child: SegmentSwitch(
        selectedIndex: _selected,
        onChanged: (value) => setState(() => _selected = value),
        options: [
          SegmentOption(label: strings.demoGrid, icon: Icons.grid_view_rounded),
          SegmentOption(
            label: strings.demoList,
            icon: Icons.view_agenda_outlined,
          ),
        ],
      ),
    );
  }
}
