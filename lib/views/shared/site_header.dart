import 'package:flubriry/models/site_section.dart';
import 'package:flubriry/theme/app_spacing.dart';
import 'package:flubriry/theme/app_typography.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/views/shared/appearance_button.dart';
import 'package:flubriry/views/shared/brand_mark.dart';
import 'package:flubriry/views/shared/github_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SiteHeader extends StatelessWidget {
  const SiteHeader({
    super.key,
    required this.onBrandTap,
    this.current = SiteSection.components,
  });

  final VoidCallback onBrandTap;
  final SiteSection current;

  static double heightFor(double width) => width < 600 ? 64 : 74;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strings = context.strings;
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 430;
    final mobileNav = width < 700;
    final showTagline = width >= 1120;

    return Container(
      height: heightFor(width),
      decoration: BoxDecoration(
        color: palette.paper,
        border: Border(bottom: BorderSide(color: palette.line)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width < 700 ? 16 : pageGutter(width),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.maxContentWidth,
            ),
            child: Row(
              children: [
                BrandMark(onTap: onBrandTap, compact: compact),
                if (showTagline) ...[
                  const SizedBox(width: 18),
                  Container(width: 1, height: 22, color: palette.lineStrong),
                  const SizedBox(width: 18),
                  Flexible(
                    child: Text(
                      strings.brandTagline,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.meta(
                        context,
                        size: 11,
                        color: palette.muted,
                      ).copyWith(letterSpacing: context.isArabic ? 0 : 0.2),
                    ),
                  ),
                ],
                const Spacer(),
                if (mobileNav)
                  _NavLink(
                    label: current == SiteSection.components
                        ? strings.contributeNav
                        : strings.componentsNav,
                    onTap: () => context.go(
                      current == SiteSection.components ? '/contribute' : '/',
                    ),
                  )
                else ...[
                  _NavLink(
                    label: strings.componentsNav,
                    selected: current == SiteSection.components,
                    onTap: () => context.go('/'),
                  ),
                  const SizedBox(width: 2),
                  _NavLink(
                    label: strings.contributeNav,
                    selected: current == SiteSection.contribute,
                    onTap: () => context.go('/contribute'),
                  ),
                ],
                const SizedBox(width: 12),
                const AppearanceButton(),
                const SizedBox(width: 8),
                GithubButton(compact: width < 1120),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool selected;

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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
                  Container(
                    width: 5,
                    height: 5,
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
                    fontSize: 12.5,
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

class SiteHeaderDelegate extends SliverPersistentHeaderDelegate {
  const SiteHeaderDelegate({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SiteHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
