import 'package:flutter/material.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/models/localized_text.dart';

// <flubriry:code>
/// A circular action with a small satellite that makes one orbit on hover.
class OrbitButton extends StatefulWidget {
  const OrbitButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.label,
    this.size = 52,
    this.background,
    this.foreground,
    this.ringColor,
    this.dotColor,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String label;
  final double size;
  final Color? background;
  final Color? foreground;
  final Color? ringColor;
  final Color? dotColor;

  @override
  State<OrbitButton> createState() => _OrbitButtonState();
}

class _OrbitButtonState extends State<OrbitButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 620),
  );
  late final Animation<double> _orbit = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  bool _hovered = false;
  bool _focused = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
    if (value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final background = widget.background ?? colors.primary;
    final foreground = widget.foreground ?? colors.onPrimary;
    final ringColor = widget.ringColor ?? colors.onSurface;
    final dotColor = widget.dotColor ?? colors.primary;
    final orbitSize = widget.size + 18;

    return Semantics(
      button: true,
      label: widget.label,
      excludeSemantics: true,
      onTap: widget.onPressed,
      child: Tooltip(
        message: widget.label,
        excludeFromSemantics: true,
        child: SizedBox(
          width: orbitSize,
          height: orbitSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _orbit,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _orbit.value * 6.28318530718,
                    child: child,
                  );
                },
                child: Container(
                  width: orbitSize,
                  height: orbitSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ringColor.withValues(alpha: 0.28),
                      width: 1,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Transform.translate(
                      offset: const Offset(0, -3),
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: _hovered ? ringColor : dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedScale(
                scale: _hovered ? 1.03 : 1,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                child: Material(
                  color: background,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: _focused ? ringColor : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: widget.onPressed,
                    onHover: _setHovered,
                    onFocusChange: (value) => setState(() => _focused = value),
                    customBorder: const CircleBorder(),
                    focusColor: background.withValues(alpha: 0.3),
                    hoverColor: Colors.transparent,
                    child: SizedBox(
                      width: widget.size,
                      height: widget.size,
                      child: Icon(
                        widget.icon,
                        color: foreground,
                        size: widget.size * 0.36,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// </flubriry:code>

final ComponentMeta componentMeta = ComponentMeta(
  id: 'orbit-button',
  order: 30,
  category: ComponentCategory.buttons,
  name: const LocalizedText('Orbit Button', 'زر المدار'),
  description: const LocalizedText(
    'A round icon action with a satellite dot. On hover, the dot completes one quiet orbit around the button.',
    'زر أيقونة دائري بنقطة تدور حوله. عند المرور، تكمل النقطة مدارًا هادئًا واحدًا حول الزر.',
  ),
  tags: const [
    'button',
    'icon',
    'circle',
    'hover',
    'orbit',
    'زر',
    'أيقونة',
    'دائري',
  ],
  contributor: 'alfaresof',
  preview: (context) => const _OrbitPreview(),
);

class _OrbitPreview extends StatelessWidget {
  const _OrbitPreview();

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OrbitButton(
          icon: Icons.add_rounded,
          label: strings.demoAdd,
          onPressed: () {},
        ),
        const SizedBox(width: 14),
        OrbitButton(
          icon: Icons.favorite_border_rounded,
          label: strings.demoHeart,
          onPressed: () {},
        ),
        const SizedBox(width: 14),
        OrbitButton(
          icon: Icons.ios_share_rounded,
          label: strings.demoShare,
          onPressed: () {},
        ),
      ],
    );
  }
}
