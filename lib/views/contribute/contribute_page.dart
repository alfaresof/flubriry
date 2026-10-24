import 'package:flubriry/config/site.dart';
import 'package:flubriry/models/site_section.dart';
import 'package:flubriry/theme/app_spacing.dart';
import 'package:flubriry/theme/app_typography.dart';
import 'package:flubriry/views/contribute/widgets/creator_card.dart';
import 'package:flubriry/views/contribute/widgets/submission_guide.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/views/shared/github_button.dart';
import 'package:flubriry/views/shared/site_footer.dart';
import 'package:flubriry/views/shared/site_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContributePage extends StatefulWidget {
  const ContributePage({super.key});

  @override
  State<ContributePage> createState() => _ContributePageState();
}

class _ContributePageState extends State<ContributePage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _goHome() => context.go('/');

  void _scrollToTop() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final palette = context.palette;
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 940;

    return Title(
      title: '${strings.contributeNav} — flubriry',
      color: palette.accent,
      child: Scaffold(
        body: SelectionArea(
          child: Scrollbar(
            controller: _scrollController,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SiteHeaderDelegate(
                    height: SiteHeader.heightFor(width),
                    child: SiteHeader(
                      current: SiteSection.contribute,
                      onBrandTap: _goHome,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: PageBounds(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: width < 600 ? 38 : 66,
                        bottom: 34,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.contributeTitle,
                            style: AppType.display(
                              context,
                              size: wide
                                  ? (context.isArabic ? 46 : 64)
                                  : (context.isArabic ? 34 : 40),
                              height: context.isArabic ? 1.4 : 1.02,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 620),
                            child: Text(
                              strings.contributeIntro,
                              style: AppType.body(
                                context,
                                size: 16,
                                color: palette.muted,
                                height: context.isArabic ? 1.9 : 1.7,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              GithubButton(
                                variant: GithubButtonVariant.accent,
                                label: strings.contributeCta,
                                url: Site.newComponentUrl,
                              ),
                              GithubButton(
                                variant: GithubButtonVariant.quiet,
                                label: strings.repositoryLabel,
                                url: Site.repoUrl,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: PageBounds(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SubmissionGuide(),
                        const SizedBox(height: 26),
                        const _RulesStrip(),
                        const SizedBox(height: 54),
                        if (wide)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(flex: 5, child: CreatorCard()),
                              const SizedBox(width: 20),
                              const Expanded(flex: 6, child: _ClosingCard()),
                            ],
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const CreatorCard(),
                              const SizedBox(height: 18),
                              const _ClosingCard(),
                            ],
                          ),
                        const SizedBox(height: 54),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SiteFooter(
                    current: SiteSection.contribute,
                    onBrandTap: _goHome,
                    onBackToTop: _scrollToTop,
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

class _RulesStrip extends StatelessWidget {
  const _RulesStrip();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strings = context.strings;
    final rules = [
      strings.ruleStandalone,
      strings.ruleBilingual,
      strings.ruleThemeAware,
      strings.ruleAccessible,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppType.label(context, strings.rulesTitle),
          style: AppType.meta(context, size: 10, color: palette.muted),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 22,
          runSpacing: 10,
          children: [
            for (final rule in rules)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: palette.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    rule,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: palette.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class _ClosingCard extends StatelessWidget {
  const _ClosingCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strings = context.strings;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: palette.contrast,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.onContrast.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.readyToAdd,
            style: AppType.display(
              context,
              size: 34,
              color: palette.onContrast,
              height: context.isArabic ? 1.5 : 1.05,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            strings.contributeClosing,
            style: AppType.body(
              context,
              size: 13.5,
              color: palette.onContrast.withValues(alpha: 0.78),
              height: context.isArabic ? 1.9 : 1.65,
            ),
          ),
          const SizedBox(height: 22),
          GithubButton(
            variant: GithubButtonVariant.accent,
            label: strings.openPullRequest,
            url: Site.pullsUrl,
          ),
        ],
      ),
    );
  }
}
