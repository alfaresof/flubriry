import 'package:flubriry/config/site.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/services/open_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum GithubButtonVariant { ink, accent, quiet }

/// The one link that appears on every surface of the catalogue.
class GithubButton extends StatelessWidget {
  const GithubButton({
    super.key,
    this.variant = GithubButtonVariant.ink,
    this.compact = false,
    this.label,
    this.url,
  });

  final GithubButtonVariant variant;
  final bool compact;
  final String? label;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    final strings = context.strings;
    final text =
        label ?? (compact ? strings.github : strings.contributeOnGithub);

    final (background, foreground, hover, border) = switch (variant) {
      GithubButtonVariant.ink => (
        palette.ink,
        palette.paper,
        Color.alphaBlend(palette.paper.withValues(alpha: 0.12), palette.ink),
        palette.ink,
      ),
      GithubButtonVariant.accent => (
        palette.accent,
        palette.accentInk,
        Color.alphaBlend(palette.ink.withValues(alpha: 0.1), palette.accent),
        palette.accent,
      ),
      GithubButtonVariant.quiet => (
        Colors.transparent,
        palette.ink,
        palette.accentSoft,
        palette.lineStrong,
      ),
    };

    return TextButton(
      onPressed: () => openExternal(context, url ?? Site.repoUrl),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.pressed)) {
            return hover;
          }
          return background;
        }),
        foregroundColor: WidgetStatePropertyAll(foreground),
        overlayColor: WidgetStatePropertyAll(
          palette.accent.withValues(alpha: 0.16),
        ),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return BorderSide(color: palette.accent, width: 2);
          }
          return BorderSide(color: border);
        }),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: compact ? 12 : 16),
        ),
        minimumSize: WidgetStatePropertyAll(Size(0, compact ? 36 : 42)),
        maximumSize: const WidgetStatePropertyAll(Size.infinite),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        ),
        textStyle: WidgetStatePropertyAll(
          theme.textTheme.labelLarge?.copyWith(
            fontSize: compact ? 12 : 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/github.svg',
            width: compact ? 15 : 16,
            height: compact ? 15 : 16,
            colorFilter: ColorFilter.mode(foreground, BlendMode.srcIn),
          ),
          const SizedBox(width: 8),
          Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
