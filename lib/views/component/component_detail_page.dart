import 'package:flubriry/config/site.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/services/open_link.dart';
import 'package:flubriry/theme/app_spacing.dart';
import 'package:flubriry/theme/app_typography.dart';
import 'package:flubriry/views/shared/contributor_badge.dart';
import 'package:flubriry/views/shared/copy_button.dart';
import 'package:flubriry/views/shared/github_button.dart';
import 'package:flubriry/models/component_catalog.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/views/shared/dart_code_view.dart';
import 'package:flubriry/views/shared/detail_header.dart';
import 'package:flubriry/views/shared/preview_stage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ComponentDetailPage extends StatefulWidget {
  const ComponentDetailPage({super.key, required this.entry});

  final ComponentEntry entry;

  @override
  State<ComponentDetailPage> createState() => _ComponentDetailPageState();
}

class _ComponentDetailPageState extends State<ComponentDetailPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  void _goHome() => context.go('/');

  ComponentEntry _previous() {
    final all = ComponentCatalog.all;
    if (all.length <= 1) return widget.entry;
    final index = all.indexOf(widget.entry);
    return all[(index - 1 + all.length) % all.length];
  }

  ComponentEntry _next() {
    final all = ComponentCatalog.all;
    if (all.length <= 1) return widget.entry;
    final index = all.indexOf(widget.entry);
    return all[(index + 1) % all.length];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 1024;
    final height = wide ? 560.0 : 400.0;
    final entry = widget.entry;
    final strings = context.strings;
    final number = ComponentCatalog.all.indexOf(entry) + 1;
    final previous = _previous();
    final next = _next();

    return Title(
      title: context.strings.componentPageTitle(
        widget.entry.meta.name.resolve(context.language),
      ),
      color: context.palette.accent,
      child: Scaffold(
        body: Scrollbar(
          controller: _scrollController,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: DetailHeaderDelegate(
                  height: DetailHeader.heightFor(width),
                  child: DetailHeader(onBack: _goBack, onHome: _goHome),
                ),
              ),
              SliverToBoxAdapter(
                child: PageBounds(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: width < 600 ? 30 : 50,
                      bottom: width < 600 ? 48 : 72,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _DetailIntro(entry: entry, number: number, wide: wide),
                        const SizedBox(height: 30),
                        if (wide)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: _PreviewPanel(
                                  entry: entry,
                                  number: number,
                                  height: height,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                flex: 6,
                                child: _CodePanel(entry: entry, height: height),
                              ),
                            ],
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _PreviewPanel(
                                entry: entry,
                                number: number,
                                height: width < 600 ? 330 : 380,
                              ),
                              const SizedBox(height: 20),
                              _CodePanel(
                                entry: entry,
                                height: width < 600 ? 430 : 480,
                              ),
                            ],
                          ),
                        const SizedBox(height: 24),
                        _Facts(entry: entry),
                        const SizedBox(height: 24),
                        if (wide)
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: _AdjacentPanel(
                                    entry: previous,
                                    label: strings.previousComponent,
                                    forward: false,
                                    onTap: () => context.pushReplacement(
                                      '/component/${previous.meta.id}',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _AdjacentPanel(
                                    entry: next,
                                    label: strings.nextComponent,
                                    forward: true,
                                    onTap: () => context.pushReplacement(
                                      '/component/${next.meta.id}',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _AdjacentPanel(
                                entry: previous,
                                label: strings.previousComponent,
                                forward: false,
                                onTap: () => context.pushReplacement(
                                  '/component/${previous.meta.id}',
                                ),
                              ),
                              const SizedBox(height: 12),
                              _AdjacentPanel(
                                entry: next,
                                label: strings.nextComponent,
                                forward: true,
                                onTap: () => context.pushReplacement(
                                  '/component/${next.meta.id}',
                                ),
                              ),
                            ],
                          ),
                      ],
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

class _DetailIntro extends StatelessWidget {
  const _DetailIntro({
    required this.entry,
    required this.number,
    required this.wide,
  });

  final ComponentEntry entry;
  final int number;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strings = context.strings;
    final language = context.language;
    final meta = entry.meta;
    final titleSize = wide
        ? (language.isArabic ? 46.0 : 64.0)
        : (language.isArabic ? 34.0 : 42.0);

    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 7,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              AppType.label(context, strings.categoryLabel(meta.category)),
              style: AppType.meta(context, size: 10.5, color: palette.muted),
            ),
            const _Dot(),
            Text(
              AppType.label(context, strings.componentNumber(number)),
              style: AppType.meta(context, size: 10.5, color: palette.muted),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          meta.name.resolve(language),
          style: AppType.display(
            context,
            size: titleSize,
            height: language.isArabic ? 1.35 : 0.98,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          meta.name.resolveOther(language),
          style: AppType.meta(context, size: 11.5, color: palette.muted),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (wide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: titleBlock),
              const SizedBox(width: 24),
              _DetailActions(entry: entry),
            ],
          )
        else ...[
          titleBlock,
          const SizedBox(height: 20),
          _DetailActions(entry: entry),
        ],
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Text(
            meta.description.resolve(language),
            style: AppType.body(
              context,
              size: 16,
              color: palette.muted,
              height: language.isArabic ? 1.85 : 1.7,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailActions extends StatelessWidget {
  const _DetailActions({required this.entry});

  final ComponentEntry entry;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        CopyButton(
          text: entry.code,
          large: true,
          emphasis: true,
          label: strings.copyCode,
        ),
        GithubButton(
          variant: GithubButtonVariant.quiet,
          label: strings.viewOnGithub,
          url: Site.sourceUrl(entry.sourcePath),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      decoration: BoxDecoration(
        color: context.palette.lineStrong,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _PreviewPanel extends StatelessWidget {
  const _PreviewPanel({
    required this.entry,
    required this.number,
    required this.height,
  });

  final ComponentEntry entry;
  final int number;
  final double height;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strings = context.strings;
    final meta = entry.meta;
    final narrow = MediaQuery.sizeOf(context).width < 600;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: PreviewStage(
                    color: stageColor(context),
                    borderRadius: BorderRadius.zero,
                    padding: EdgeInsets.all(narrow ? 24 : 36),
                    child: meta.preview(context),
                  ),
                ),
                PositionedDirectional(
                  top: 15,
                  start: 17,
                  child: Text(
                    AppType.label(
                      context,
                      strings.categoryLabel(meta.category),
                    ),
                    style: AppType.meta(
                      context,
                      size: 9.5,
                      color: palette.ink.withValues(alpha: 0.68),
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: 15,
                  end: 17,
                  child: Text(
                    strings.twoDigits(number),
                    style: AppType.meta(
                      context,
                      size: 9.5,
                      color: palette.ink.withValues(alpha: 0.68),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: palette.line)),
            ),
            padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
            child: Row(
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
                  AppType.label(context, strings.previewLabel),
                  style: AppType.meta(context, size: 10, color: palette.muted),
                ),
                const Spacer(),
                if (!narrow)
                  Text(
                    strings.previewHint,
                    style: AppType.meta(
                      context,
                      size: 10,
                      color: palette.muted,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CodePanel extends StatelessWidget {
  const _CodePanel({required this.entry, required this.height});

  final ComponentEntry entry;
  final double height;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strings = context.strings;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: palette.codeBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(18, 9, 10, 9),
            child: Row(
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: palette.accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    entry.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.monoStyle(
                      context,
                      size: 11,
                      color: palette.codeInk.withValues(alpha: 0.72),
                    ),
                  ),
                ),
                CopyButton(
                  text: entry.code,
                  tone: CopyButtonTone.inverse,
                  label: strings.copy,
                ),
              ],
            ),
          ),
          Container(height: 1, color: palette.codeInk.withValues(alpha: 0.12)),
          Expanded(
            child: SelectionArea(child: DartCodeView(code: entry.code)),
          ),
        ],
      ),
    );
  }
}

class _Facts extends StatelessWidget {
  const _Facts({required this.entry});

  final ComponentEntry entry;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strings = context.strings;
    final meta = entry.meta;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.line),
      ),
      child: Wrap(
        spacing: 48,
        runSpacing: 22,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          _Fact(
            label: strings.dependenciesLabel,
            value: meta.dependencies.isEmpty
                ? strings.pureFlutter
                : meta.dependencies.join(' · '),
          ),
          _Fact(
            label: strings.contributedBy,
            value: '',
            child: ContributorBadge(
              username: meta.contributor,
              avatar: meta.contributorAvatar,
            ),
          ),
          _Fact(
            label: strings.fileLabel,
            value: entry.fileName,
            onTap: () =>
                openExternal(context, Site.sourceUrl(entry.sourcePath)),
          ),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({
    required this.label,
    required this.value,
    this.onTap,
    this.child,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final valueWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            value,
            style: AppType.monoStyle(
              context,
              size: 11.5,
              color: palette.ink,
              weight: FontWeight.w500,
            ),
          ),
        ),
        if (onTap != null) ...[
          const SizedBox(width: 7),
          Transform.flip(
            flipX: context.isArabic,
            child: Icon(
              Icons.arrow_outward_rounded,
              size: 13,
              color: palette.muted,
            ),
          ),
        ],
      ],
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 340),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppType.label(context, label),
            style: AppType.meta(context, size: 9.5, color: palette.muted),
          ),
          const SizedBox(height: 7),
          if (child != null)
            child!
          else if (onTap == null)
            valueWidget
          else
            Semantics(
              link: true,
              label: value,
              excludeSemantics: true,
              onTap: onTap,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(6),
                hoverColor: palette.accentSoft,
                focusColor: palette.accent.withValues(alpha: 0.28),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: valueWidget,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AdjacentPanel extends StatelessWidget {
  const _AdjacentPanel({
    required this.entry,
    required this.label,
    required this.forward,
    required this.onTap,
  });

  final ComponentEntry entry;
  final String label;
  final bool forward;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strings = context.strings;
    final meta = entry.meta;

    return Semantics(
      button: true,
      label: '$label: ${meta.name.resolve(context.language)}',
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: palette.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          hoverColor: palette.accentSoft,
          focusColor: palette.accent.withValues(alpha: 0.28),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(22, 18, 18, 18),
            child: Row(
              children: [
                if (!forward) ...[
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: palette.accentSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Transform.flip(
                      flipX: context.isArabic,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 17,
                        color: palette.accentStrong,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppType.label(context, label),
                        style: AppType.meta(
                          context,
                          size: 9.5,
                          color: palette.muted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        meta.name.resolve(context.language),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        AppType.label(
                          context,
                          strings.categoryLabel(meta.category),
                        ),
                        style: AppType.meta(
                          context,
                          size: 9.5,
                          color: palette.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (forward) ...[
                  const SizedBox(width: 14),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: palette.accent,
                      shape: BoxShape.circle,
                    ),
                    child: Transform.flip(
                      flipX: context.isArabic,
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: palette.accentInk,
                      ),
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
