import 'package:flubriry/config/site.dart';
import 'package:flubriry/services/open_link.dart';
import 'package:flubriry/theme/app_typography.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialAccounts extends StatelessWidget {
  const SocialAccounts({
    super.key,
    this.showHandle = true,
    this.showLabels = false,
    this.compact = true,
  });

  final bool showHandle;
  final bool showLabels;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showHandle) ...[
          Text(
            strings.creatorHandle,
            textDirection: TextDirection.ltr,
            style: AppType.meta(
              context,
              size: 10,
              color: context.palette.muted,
            ),
          ),
          const SizedBox(width: 10),
        ],
        _SocialButton(
          asset: 'assets/icons/github.svg',
          label: strings.followOnGithub,
          url: Site.githubProfileUrl,
          showLabel: showLabels,
          compact: compact,
        ),
        const SizedBox(width: 6),
        _SocialButton(
          asset: 'assets/icons/x.svg',
          label: strings.followOnX,
          url: Site.xUrl,
          showLabel: showLabels,
          compact: compact,
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.asset,
    required this.label,
    required this.url,
    required this.showLabel,
    required this.compact,
  });

  final String asset;
  final String label;
  final String url;
  final bool showLabel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    final iconColor = palette.ink;

    return Semantics(
      link: true,
      label: '$label — ${context.strings.creatorHandle}',
      excludeSemantics: true,
      onTap: () => openExternal(context, url),
      child: Material(
        color: palette.surface,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => openExternal(context, url),
          hoverColor: palette.accentSoft,
          focusColor: palette.accent.withValues(alpha: 0.28),
          child: Container(
            height: compact ? 32 : 38,
            padding: EdgeInsets.symmetric(horizontal: showLabel ? 12 : 0),
            constraints: BoxConstraints(minWidth: compact ? 32 : 38),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: palette.line),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  asset,
                  width: 13,
                  height: 13,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
                if (showLabel) ...[
                  const SizedBox(width: 7),
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: palette.ink,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
