import 'dart:async';

import 'package:flubriry/views/shared/app_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum CopyButtonTone { standard, inverse }

/// A copy action with a visible label and a short, local confirmation.
class CopyButton extends StatefulWidget {
  const CopyButton({
    super.key,
    required this.text,
    this.label,
    this.copiedLabel,
    this.large = false,
    this.tone = CopyButtonTone.standard,
    this.emphasis = false,
  });

  final String text;
  final String? label;
  final String? copiedLabel;
  final bool large;
  final CopyButtonTone tone;

  /// A filled amber action, for the one copy control that should lead.
  final bool emphasis;

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  bool _copied = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _copy() async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final errorText = context.strings.copyFailed;
    try {
      await Clipboard.setData(ClipboardData(text: widget.text));
    } on Object {
      messenger?.showSnackBar(SnackBar(content: Text(errorText)));
      return;
    }
    if (!mounted) return;
    setState(() => _copied = true);
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 1900), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    final strings = context.strings;
    final idleLabel = widget.label ?? strings.copy;
    final doneLabel = widget.copiedLabel ?? strings.copied;
    final inverse = widget.tone == CopyButtonTone.inverse;
    final highlighted = widget.emphasis && !inverse;

    final idleBackground = inverse
        ? Colors.transparent
        : highlighted
        ? palette.accent
        : palette.surface;
    final idleForeground = inverse
        ? palette.codeInk
        : highlighted
        ? palette.accentInk
        : palette.ink;
    final idleBorder = inverse
        ? palette.codeInk.withValues(alpha: 0.3)
        : highlighted
        ? palette.accent
        : palette.lineStrong;
    final hoverBackground = inverse
        ? palette.codeInk
        : highlighted
        ? Color.alphaBlend(palette.ink.withValues(alpha: 0.1), palette.accent)
        : palette.ink;
    final hoverForeground = inverse
        ? palette.codeBg
        : highlighted
        ? palette.accentInk
        : palette.paper;
    final copiedBackground = palette.accent;
    final copiedForeground = palette.accentInk;

    return Semantics(
      liveRegion: _copied,
      child: SizedBox(
        width: widget.large ? 158 : 104,
        height: widget.large ? 44 : 34,
        child: TextButton.icon(
          onPressed: _copy,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (_copied) {
                if (states.contains(WidgetState.hovered)) {
                  return Color.alphaBlend(
                    palette.ink.withValues(alpha: 0.08),
                    copiedBackground,
                  );
                }
                return copiedBackground;
              }
              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.pressed)) {
                return hoverBackground;
              }
              return idleBackground;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (_copied) return copiedForeground;
              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.pressed)) {
                return hoverForeground;
              }
              return idleForeground;
            }),
            overlayColor: WidgetStatePropertyAll(
              palette.accent.withValues(alpha: 0.18),
            ),
            side: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.focused)) {
                return BorderSide(
                  color: highlighted ? palette.ink : palette.accent,
                  width: 2,
                );
              }
              if (_copied) return BorderSide(color: copiedBackground);
              return BorderSide(color: idleBorder);
            }),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 10),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            textStyle: WidgetStatePropertyAll(
              theme.textTheme.labelMedium?.copyWith(
                fontSize: widget.large ? 13 : 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
              ),
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            switchInCurve: Curves.easeOutBack,
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Icon(
              _copied ? Icons.check_rounded : Icons.content_copy_rounded,
              key: ValueKey<bool>(_copied),
              size: widget.large ? 17 : 15,
            ),
          ),
          label: Text(_copied ? doneLabel : idleLabel, maxLines: 1),
        ),
      ),
    );
  }
}
