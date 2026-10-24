import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/models/localized_text.dart';

// <flubriry:code>
/// A tactile button with smoothed corners and a real, physical press.
///
/// Requires `figma_squircle` for the true squircle silhouette.
class SquircleButton extends StatefulWidget {
  const SquircleButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.arrow_forward_rounded,
    this.color,
    this.inkColor,
    this.depth = 4,
    this.expanded = false,
    this.mirrorIcon = true,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  /// Defaults to the theme primary, so the button follows the palette.
  final Color? color;
  final Color? inkColor;
  final double depth;
  final bool expanded;

  /// Flip directional icons when the interface runs right-to-left.
  final bool mirrorIcon;

  @override
  State<SquircleButton> createState() => _SquircleButtonState();
}

class _SquircleButtonState extends State<SquircleButton> {
  bool _pressed = false;
  bool _hovered = false;
  bool _focused = false;

  Color _baseColor(Color color) =>
      Color.alphaBlend(const Color(0x55000000), color);

  Color _faceColor(Color color) {
    if (_pressed) {
      return Color.alphaBlend(const Color(0x14000000), color);
    }
    if (_hovered) {
      return Color.alphaBlend(const Color(0x14FFFFFF), color);
    }
    return color;
  }

  ShapeBorder get _shape => SmoothRectangleBorder(
    borderRadius: SmoothBorderRadius(cornerRadius: 16, cornerSmoothing: 0.62),
  );

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  void _activate() {
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    final faceColor = widget.color ?? palette.primary;
    final inkColor = widget.inkColor ?? palette.onPrimary;
    final textStyle = Theme.of(context).textTheme.titleSmall!.copyWith(
      color: inkColor,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: 0,
    );

    return Semantics(
      button: true,
      label: widget.label,
      excludeSemantics: true,
      onTap: _activate,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _activate();
              return null;
            },
          ),
        },
        onShowHoverHighlight: (value) => setState(() => _hovered = value),
        onShowFocusHighlight: (value) => setState(() => _focused = value),
        child: GestureDetector(
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          onTap: _activate,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            width: widget.expanded ? double.infinity : null,
            padding: EdgeInsets.only(bottom: widget.depth),
            decoration: ShapeDecoration(
              color: _baseColor(faceColor),
              shape: _shape,
              shadows: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 20,
                  offset: const Offset(0, 9),
                ),
              ],
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 90),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(
                0,
                _pressed ? widget.depth : 0,
                0,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 17),
              decoration: ShapeDecoration(
                color: _faceColor(faceColor),
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 16,
                    cornerSmoothing: 0.62,
                  ),
                  side: BorderSide(
                    color: _focused ? palette.onSurface : _faceColor(faceColor),
                    width: _focused ? 2 : 1,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: widget.expanded
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.expanded)
                    Expanded(
                      child: Text(
                        widget.label,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle,
                      ),
                    )
                  else
                    Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle,
                    ),
                  if (widget.icon != null) ...[
                    const SizedBox(width: 12),
                    Transform.flip(
                      flipX:
                          widget.mirrorIcon &&
                          Directionality.of(context) == TextDirection.rtl,
                      child: Icon(widget.icon, size: 18, color: inkColor),
                    ),
                  ],
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
  id: 'squircle-button',
  order: 10,
  category: ComponentCategory.buttons,
  name: const LocalizedText('Squircle Button', 'زر سكويركل'),
  description: const LocalizedText(
    'A tactile key with smoothed corners and a visible 4px press. The color comes from the theme, so it follows the palette.',
    'زر ملموس بزوايا ناعمة وضغطة مرئية بمقدار 4 بكسل. لونه من الثيم فيتبع لوحة الألوان.',
  ),
  tags: const [
    'button',
    'press',
    'squircle',
    'tactile',
    'theme',
    'palette',
    'زر',
    'ضغط',
    'زوايا',
  ],
  dependencies: const ['figma_squircle: ^0.6.3'],
  origin: 'Qafelah',
  preview: (context) => const _SquirclePreview(),
);

class _SquirclePreview extends StatelessWidget {
  const _SquirclePreview();

  @override
  Widget build(BuildContext context) {
    return SquircleButton(
      label: context.strings.demoContinue,
      onPressed: () {},
    );
  }
}
