import 'package:flubriry/theme/app_spacing.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/views/shared/appearance_button.dart';
import 'package:flubriry/views/shared/brand_mark.dart';
import 'package:flubriry/views/shared/github_button.dart';
import 'package:flutter/material.dart';

class DetailHeader extends StatelessWidget {
  const DetailHeader({super.key, required this.onBack, required this.onHome});

  final VoidCallback onBack;
  final VoidCallback onHome;

  static double heightFor(double width) => width < 600 ? 64 : 74;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strings = context.strings;
    final width = MediaQuery.sizeOf(context).width;
    final showBackLabel = width >= 700;
    final showBrand = width >= 940;

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
                if (showBackLabel)
                  TextButton.icon(
                    onPressed: onBack,
                    style: TextButton.styleFrom(
                      foregroundColor: palette.ink,
                      overlayColor: palette.accentSoft,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(0, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: Theme.of(context).textTheme.labelMedium,
                    ),
                    icon: Transform.flip(
                      flipX: context.isArabic,
                      child: const Icon(Icons.arrow_back_rounded, size: 17),
                    ),
                    label: Text(strings.backToLibrary),
                  )
                else
                  IconButton(
                    onPressed: onBack,
                    tooltip: strings.backToLibrary,
                    style: IconButton.styleFrom(
                      backgroundColor: palette.surface,
                      foregroundColor: palette.ink,
                      hoverColor: palette.accentSoft,
                      focusColor: palette.accent.withValues(alpha: 0.28),
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(38, 38),
                      maximumSize: const Size(38, 38),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                        side: BorderSide(color: palette.line),
                      ),
                    ),
                    icon: Transform.flip(
                      flipX: context.isArabic,
                      child: const Icon(Icons.arrow_back_rounded, size: 18),
                    ),
                  ),
                if (showBrand) ...[
                  const SizedBox(width: 16),
                  Container(width: 1, height: 22, color: palette.lineStrong),
                  const SizedBox(width: 16),
                  BrandMark(onTap: onHome),
                ],
                const Spacer(),
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

class DetailHeaderDelegate extends SliverPersistentHeaderDelegate {
  const DetailHeaderDelegate({required this.height, required this.child});

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
  bool shouldRebuild(covariant DetailHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
