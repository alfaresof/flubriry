import 'package:flutter/material.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/models/localized_text.dart';

// <flubriry:code>
/// A solid pill with a bright companion coin.
///
/// The coin nudges forward on hover, so the two halves feel like one object.
class TandemButton extends StatefulWidget {
  const TandemButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.arrow_forward_rounded,
    this.background,
    this.foreground,
    this.accent,
    this.accentInk,
    this.mirrorIcon = true,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  /// Defaults to the theme's onSurface colour.
  final Color? background;

  /// Defaults to the theme's surface colour.
  final Color? foreground;

  /// Defaults to the theme's primary colour.
  final Color? accent;
  final Color? accentInk;

  /// Flip directional icons when the interface runs right-to-left.
  final bool mirrorIcon;

  @override
  State<TandemButton> createState() => _TandemButtonState();
}

class _TandemButtonState extends State<TandemButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final background = widget.background ?? colors.onSurface;
    final foreground = widget.foreground ?? colors.surface;
    final accent = widget.accent ?? colors.primary;
    final accentInk = widget.accentInk ?? colors.onPrimary;
    final hoveredBackground = Color.alphaBlend(
      foreground.withValues(alpha: 0.12),
      background,
    );
    final rtl = Directionality.of(context) == TextDirection.rtl;

    return AnimatedScale(
      scale: _pressed ? 0.982 : 1,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.2),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: _hovered ? hoveredBackground : background,
          animationDuration: const Duration(milliseconds: 180),
          shape: const StadiumBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onPressed,
            onHover: (value) => setState(() => _hovered = value),
            onHighlightChanged: (value) => setState(() => _pressed = value),
            customBorder: const StadiumBorder(),
            focusColor: accent.withValues(alpha: 0.28),
            hoverColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 22,
                end: 6,
                top: 6,
                bottom: 6,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: foreground,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(width: 16),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    width: 40,
                    height: 40,
                    transform: Matrix4.translationValues(
                      _hovered ? (rtl ? -3 : 3) : 0,
                      0,
                      0,
                    ),
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                    child: Transform.flip(
                      flipX:
                          widget.mirrorIcon &&
                          Directionality.of(context) == TextDirection.rtl,
                      child: Icon(widget.icon, size: 18, color: accentInk),
                    ),
                  ),
                ],
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
  id: 'tandem-button',
  order: 20,
  category: ComponentCategory.buttons,
  name: const LocalizedText('Tandem Button', 'زر الانطلاق'),
  description: const LocalizedText(
    'A solid pill with a bright companion coin. The coin nudges forward on hover, so the label and icon move as one pair.',
    'زر ممتلئ بقرص ملوّن يرافقه. يتقدّم القرص قليلًا عند المرور، فيتحرّك النص والأيقونة كوحدة واحدة.',
  ),
  tags: const ['button', 'hover', 'pill', 'icon', 'زر', 'مرور', 'أيقونة'],
  origin: 'Qafelah',
  preview: (context) => const _TandemPreview(),
);

class _TandemPreview extends StatelessWidget {
  const _TandemPreview();

  @override
  Widget build(BuildContext context) {
    return TandemButton(label: context.strings.demoJourney, onPressed: () {});
  }
}
