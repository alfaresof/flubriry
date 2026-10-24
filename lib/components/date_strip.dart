import 'package:flutter/material.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/models/localized_text.dart';

// <flubriry:code>
class DayOption {
  const DayOption({required this.weekday, required this.day});

  final String weekday;
  final String day;
}

/// A short strip of days. The selected day fills with the theme color.
class DateStrip extends StatelessWidget {
  const DateStrip({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<DayOption> days;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final safeIndex = days.isEmpty
        ? 0
        : selectedIndex.clamp(0, days.length - 1);

    return Row(
      children: [
        for (var index = 0; index < days.length; index++) ...[
          if (index > 0) const SizedBox(width: 8),
          Expanded(
            child: Semantics(
              button: true,
              selected: index == safeIndex,
              label: '${days[index].weekday} ${days[index].day}',
              excludeSemantics: true,
              onTap: () => onChanged(index),
              child: Material(
                color: index == safeIndex ? colors.primary : colors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                  side: BorderSide(
                    color: index == safeIndex
                        ? colors.primary
                        : colors.outlineVariant,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => onChanged(index),
                  focusColor: index == safeIndex
                      ? colors.onPrimary.withValues(alpha: 0.24)
                      : colors.primary.withValues(alpha: 0.24),
                  hoverColor: index == safeIndex
                      ? colors.onPrimary.withValues(alpha: 0.08)
                      : colors.primary.withValues(alpha: 0.08),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 10,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          days[index].weekday,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: index == safeIndex
                                ? colors.onPrimary
                                : colors.onSurface.withValues(alpha: 0.68),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          days[index].day,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: index == safeIndex
                                ? colors.onPrimary
                                : colors.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.1,
                            letterSpacing: 0,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
// </flubriry:code>

final ComponentMeta componentMeta = ComponentMeta(
  id: 'date-strip',
  order: 160,
  category: ComponentCategory.navigation,
  name: const LocalizedText('Date Strip', 'شريط التواريخ'),
  description: const LocalizedText(
    'A short strip of days with one selected. The date tiles and their type stay put while the accent color changes.',
    'شريط قصير من الأيام مع اختيار واحد. تبقى خلايا التاريخ ونصها ثابتة بينما يتغير لون التمييز.',
  ),
  tags: const [
    'date',
    'calendar',
    'selector',
    'days',
    'khaber',
    'تاريخ',
    'تقويم',
    'اختيار',
    'خبر',
  ],
  origin: 'Khaber',
  preview: (context) => const _DatePreview(),
);

class _DatePreview extends StatefulWidget {
  const _DatePreview();

  @override
  State<_DatePreview> createState() => _DatePreviewState();
}

class _DatePreviewState extends State<_DatePreview> {
  int _selected = 1;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final theme = Theme.of(context);
    return SizedBox(
      width: 304,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            strings.demoDateHint,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 8),
          DateStrip(
            selectedIndex: _selected,
            onChanged: (value) => setState(() => _selected = value),
            days: [
              DayOption(weekday: strings.demoDateMonday, day: '12'),
              DayOption(weekday: strings.demoDateTuesday, day: '13'),
              DayOption(weekday: strings.demoDateWednesday, day: '14'),
            ],
          ),
        ],
      ),
    );
  }
}
