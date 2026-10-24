import 'package:flubriry/config/site.dart';
import 'package:flubriry/models/site_section.dart';
import 'package:flubriry/services/open_link.dart';
import 'package:flubriry/theme/app_spacing.dart';
import 'package:flubriry/theme/app_typography.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/views/shared/brand_mark.dart';
import 'package:flubriry/views/shared/social_accounts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({
    super.key,
    required this.onBrandTap,
    required this.onBackToTop,
    this.current = SiteSection.components,
  });

  final VoidCallback onBrandTap;
  final VoidCallback onBackToTop;
  final SiteSection current;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strings = context.strings;
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 900;

    final brand = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BrandMark(onTap: onBrandTap),
        const SizedBox(width: 16),
        Container(width: 1, height: 22, color: palette.lineStrong),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            strings.footerTagline,
            style: AppType.body(
              context,
              size: 12.5,
              color: palette.muted,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: palette.accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );

    final links = Wrap(
      spacing: 2,
      runSpacing: 2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _FooterLink(
          label: strings.componentsNav,
          selected: current == SiteSection.components,
          onTap: () => context.go('/'),
        ),
        _FooterLink(
          label: strings.contributeNav,
          selected: current == SiteSection.contribute,
          onTap: () => context.go('/contribute'),
        ),
        _FooterLink(
          label: strings.repositoryLabel,
          selected: false,
          onTap: () => openExternal(context, Site.repoUrl),
        ),
        const SizedBox(width: 10),
        const SocialAccounts(),
      ],
    );

    final topRight = wide
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              links,
              const SizedBox(width: 18),
              _BackToTop(onTap: onBackToTop),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              links,
              const SizedBox(height: 14),
              _BackToTop(onTap: onBackToTop),
            ],
          );

    return Container(
      decoration: BoxDecoration(
        color: palette.paper,
        border: Border(top: BorderSide(color: palette.line)),
      ),
      child: PageBounds(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (wide)
                Row(
                  children: [
                    Expanded(child: brand),
                    topRight,
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [brand, const SizedBox(height: 18), topRight],
                ),
              const SizedBox(height: 24),
              Container(height: 1, color: palette.line),
              const SizedBox(height: 16),
              if (wide)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        strings.footerNote,
                        style: AppType.body(
                          context,
                          size: 11.5,
                          color: palette.muted,
                          height: 1.5,
                        ),
                      ),
                    ),
                    Text(
                      '© ${DateTime.now().year} flubriry',
                      textDirection: TextDirection.ltr,
                      style: AppType.meta(
                        context,
                        size: 10,
                        color: palette.muted,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const _LicenseLink(),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.footerNote,
                      style: AppType.body(
                        context,
                        size: 11.5,
                        color: palette.muted,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          '© ${DateTime.now().year} flubriry',
                          textDirection: TextDirection.ltr,
                          style: AppType.meta(
                            context,
                            size: 10,
                            color: palette.muted,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const _LicenseLink(),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      onTap: selected ? null : onTap,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: selected ? null : onTap,
          borderRadius: BorderRadius.circular(8),
          hoverColor: palette.accentSoft,
          focusColor: palette.accent.withValues(alpha: 0.28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: palette.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: selected ? palette.ink : palette.muted,
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    letterSpacing: 0,
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

class _BackToTop extends StatelessWidget {
  const _BackToTop({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: palette.muted,
        overlayColor: palette.accentSoft,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        minimumSize: const Size(0, 34),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        textStyle: Theme.of(context).textTheme.labelMedium,
      ),
      icon: const Icon(Icons.arrow_upward_rounded, size: 15),
      label: Text(context.strings.backToTop),
    );
  }
}

class _LicenseLink extends StatelessWidget {
  const _LicenseLink();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: () => openExternal(context, Site.licenseUrl),
      borderRadius: BorderRadius.circular(6),
      hoverColor: palette.accentSoft,
      focusColor: palette.accent.withValues(alpha: 0.28),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        child: Text(
          'MIT License',
          textDirection: TextDirection.ltr,
          style: AppType.meta(
            context,
            size: 10,
            color: palette.muted,
            weight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
