import 'package:flutter/material.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/models/localized_text.dart';

// <flubriry:code>
/// A bounded number control with two round keys and a count that rolls.
class TallyStepper extends StatelessWidget {
  const TallyStepper({
    super.key,
    required this.value,
    required this.onChanged,
    required this.decreaseLabel,
    required this.increaseLabel,
    this.min = 0,
    this.max = 99,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final String decreaseLabel;
  final String increaseLabel;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final canDecrease = value > min;
    final canIncrease = value < max;

    return Semantics(
      container: true,
      label: '$value',
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TallyKey(
              icon: Icons.remove_rounded,
              label: decreaseLabel,
              enabled: canDecrease,
              onTap: () => onChanged(value - 1),
            ),
            SizedBox(
              width: 52,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.28),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  '$value',
                  key: ValueKey<int>(value),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colors.onSurface,
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    height: 1,
                    letterSpacing: 0,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
            _TallyKey(
              icon: Icons.add_rounded,
              label: increaseLabel,
              enabled: canIncrease,
              onTap: () => onChanged(value + 1),
            ),
          ],
        ),
      ),
    );
  }
}

class _TallyKey extends StatelessWidget {
  const _TallyKey({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: Tooltip(
        message: label,
        excludeFromSemantics: true,
        child: AnimatedOpacity(
          opacity: enabled ? 1 : 0.35,
          duration: const Duration(milliseconds: 180),
          child: Material(
            color: colors.primaryContainer,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: enabled ? onTap : null,
              customBorder: const CircleBorder(),
              focusColor: colors.primary.withValues(alpha: 0.3),
              child: SizedBox(
                width: 38,
                height: 38,
                child: Icon(icon, size: 18, color: colors.onPrimaryContainer),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// </flubriry:code>

final ComponentMeta componentMeta = ComponentMeta(
  id: 'tally-stepper',
  order: 50,
  category: ComponentCategory.inputs,
  name: const LocalizedText('Tally Stepper', 'عدّاد الكمية'),
  description: const LocalizedText(
    'A bounded number control. The count rolls when it changes, and the two round keys politely disable themselves at the ends.',
    'أداة لاختيار عدد محدود. يتدحرج الرقم عند تغييره، ويتعطّل المفتاحان تلقائيًا عند بلوغ الحدين.',
  ),
  tags: const [
    'stepper',
    'number',
    'quantity',
    'counter',
    'input',
    'عدّاد',
    'كمية',
    'رقم',
  ],
  contributor: 'alfaresof',
  preview: (context) => const _TallyPreview(),
);

class _TallyPreview extends StatefulWidget {
  const _TallyPreview();

  @override
  State<_TallyPreview> createState() => _TallyPreviewState();
}

class _TallyPreviewState extends State<_TallyPreview> {
  int _value = 2;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          strings.demoTickets,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 10),
        TallyStepper(
          value: _value,
          min: 0,
          max: 8,
          decreaseLabel: strings.demoRemove,
          increaseLabel: strings.demoAdd,
          onChanged: (value) => setState(() => _value = value),
        ),
      ],
    );
  }
}
