import 'package:flubriry/config/site.dart';
import 'package:flubriry/services/open_link.dart';
import 'package:flubriry/theme/app_typography.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flutter/material.dart';

/// A small clickable credit: the contributor's avatar and GitHub handle.
class ContributorBadge extends StatelessWidget {
  const ContributorBadge({super.key, required this.username, this.avatar});

  final String username;
  final String? avatar;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final url = 'https://github.com/$username';

    return Semantics(
      link: true,
      label: '@$username on GitHub',
      excludeSemantics: true,
      onTap: () => openExternal(context, url),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => openExternal(context, url),
          borderRadius: BorderRadius.circular(8),
          hoverColor: palette.accentSoft,
          focusColor: palette.accent.withValues(alpha: 0.28),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(3, 2, 6, 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Avatar(username: username, avatar: avatar),
                const SizedBox(width: 8),
                Text(
                  '@$username',
                  textDirection: TextDirection.ltr,
                  style: AppType.meta(
                    context,
                    size: 11,
                    color: palette.ink,
                    weight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 5),
                Transform.flip(
                  flipX: context.isArabic,
                  child: Icon(
                    Icons.arrow_outward_rounded,
                    size: 12,
                    color: palette.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.username, required this.avatar});

  final String username;
  final String? avatar;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final source = avatar;
    final Widget image;
    if (source != null) {
      image = source.startsWith('http')
          ? Image.network(
              source,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _Monogram(username: username),
            )
          : Image.asset(
              source,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _Monogram(username: username),
            );
    } else if (username == Site.owner) {
      image = Image.asset(Site.ownerAvatar, fit: BoxFit.cover);
    } else {
      image = Image.network(
        'https://github.com/$username.png?size=80',
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _Monogram(username: username),
      );
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: palette.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: image,
    );
  }
}

class _Monogram extends StatelessWidget {
  const _Monogram({required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final letter = username.isEmpty ? '?' : username[0].toUpperCase();
    return ColoredBox(
      color: palette.accentSoft,
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            fontFamily: AppType.sans,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: palette.accentStrong,
          ),
        ),
      ),
    );
  }
}
