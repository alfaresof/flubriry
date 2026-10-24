import 'package:flutter/material.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/models/localized_text.dart';

// <flubriry:code>
/// A selectable pill with a fixed dot slot, so the row never jumps when the
/// selection moves.
class FilterPill extends StatefulWidget {
  const FilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<FilterPill> createState() => _FilterPillState();
}

class _FilterPillState extends State<FilterPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final background = widget.selected
        ? colors.primary
        : _hovered
        ? Color.alphaBlend(
            colors.primary.withValues(alpha: 0.12),
            colors.surface,
          )
        : colors.surface;
    final foreground = widget.selected ? colors.onPrimary : colors.onSurface;

    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.label,
      excludeSemantics: true,
      onTap: widget.onTap,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: widget.selected ? colors.primary : colors.outlineVariant,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: widget.selected
                        ? colors.onPrimary
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: foreground,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                onHover: (value) => setState(() => _hovered = value),
                customBorder: const StadiumBorder(),
                focusColor: colors.primary.withValues(alpha: 0.28),
                hoverColor: Colors.transparent,
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
  id: 'filter-pill',
  order: 60,
  category: ComponentCategory.navigation,
  name: const LocalizedText('Filter Pill', 'زر التصفية'),
  description: const LocalizedText(
    'A selectable pill with a fixed dot slot. The dot wakes up when selected, and the row never shifts as the choice moves.',
    'زر اختيار بنقطة ثابتة الموضع. تستيقظ النقطة عند الاختيار، ولا يتحرّك الصف عند تغيير الاختيار.',
  ),
  tags: const [
    'chip',
    'filter',
    'select',
    'navigation',
    'pill',
    'تصفية',
    'اختيار',
    'تنقل',
  ],
  origin: 'Qafelah',
  preview: (context) => const _FilterPreview(),
);

class _FilterPreview extends StatefulWidget {
  const _FilterPreview();

  @override
  State<_FilterPreview> createState() => _FilterPreviewState();
}

class _FilterPreviewState extends State<_FilterPreview> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final labels = [strings.demoAll, strings.demoSaved, strings.demoNew];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var index = 0; index < labels.length; index++)
          FilterPill(
            label: labels[index],
            selected: _selected == index,
            onTap: () => setState(() => _selected = index),
          ),
      ],
    );
  }
}
