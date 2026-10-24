import 'package:flubriry/models/component_catalog.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/theme/app_spacing.dart';
import 'package:flubriry/theme/app_typography.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/views/shared/preview_stage.dart';
import 'package:flutter/material.dart';

class LibraryHero extends StatelessWidget {
  const LibraryHero({super.key, required this.onBrowse, required this.onOpen});

  final VoidCallback onBrowse;
  final ValueChanged<ComponentEntry> onOpen;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strings = context.strings;
    final width = MediaQuery.sizeOf(context).width;
    final isArabic = context.isArabic;
    final showFeatured = width >= 1180;
    final titleSize = isArabic
        ? (width >= 1180
              ? 58.0
              : width >= 700
              ? 44.0
              : 34.0)
        : (width >= 1180
              ? 78.0
              : width >= 700
              ? 56.0
              : 40.0);
    final lineIndent = width >= 700 ? (isArabic ? 42.0 : 54.0) : 0.0;
    final squareSize = width >= 700 ? 13.0 : 9.0;
    final featured = ComponentCatalog.all.isEmpty
        ? null
        : ComponentCatalog.all.first;

    return PageBounds(
      child: Padding(
        padding: EdgeInsets.only(
          top: width < 600 ? 38 : 68,
          bottom: width < 600 ? 36 : 54,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.heroLineOne,
                    style: AppType.display(
                      context,
                      size: titleSize,
                      height: isArabic ? 1.38 : 0.97,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: lineIndent),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            strings.heroLineTwo,
                            style: AppType.display(
                              context,
                              size: titleSize,
                              height: isArabic ? 1.38 : 1.02,
                            ),
                          ),
                        ),
                        SizedBox(width: squareSize * 0.65),
                        Padding(
                          padding: EdgeInsets.only(bottom: titleSize * 0.18),
                          child: Container(
                            width: squareSize,
                            height: squareSize,
                            decoration: BoxDecoration(
                              color: palette.accent,
                              borderRadius: BorderRadius.circular(
                                squareSize * 0.3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Wrap(
                    spacing: 14,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _Meta(
                        text: strings.metaComponents(
                          ComponentCatalog.all.length,
                        ),
                      ),
                      const _MetaDot(),
                      _Meta(
                        text: strings.metaCategories(
                          ComponentCategory.values.length,
                        ),
                      ),
                      const _MetaDot(),
                      _Meta(text: strings.metaLicense),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _BrowseLink(onTap: onBrowse),
                ],
              ),
            ),
            if (showFeatured && featured != null) ...[
              const SizedBox(width: 44),
              SizedBox(
                width: 320,
                child: _FeaturedSpecimen(
                  entry: featured,
                  number: ComponentCatalog.all.indexOf(featured) + 1,
                  onOpen: () => onOpen(featured),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BrowseLink extends StatelessWidget {
  const _BrowseLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        hoverColor: palette.accentSoft,
        focusColor: palette.accent.withValues(alpha: 0.28),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
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
                context.strings.browseShelf,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: palette.ink,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(width: 7),
              Icon(
                Icons.arrow_downward_rounded,
                size: 15,
                color: palette.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      AppType.label(context, text),
      style: AppType.meta(context, size: 10.5, color: context.palette.muted),
    );
  }
}

class _MetaDot extends StatelessWidget {
  const _MetaDot();

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

class _FeaturedSpecimen extends StatefulWidget {
  const _FeaturedSpecimen({
    required this.entry,
    required this.number,
    required this.onOpen,
  });

  final ComponentEntry entry;
  final int number;
  final VoidCallback onOpen;

  @override
  State<_FeaturedSpecimen> createState() => _FeaturedSpecimenState();
}

class _FeaturedSpecimenState extends State<_FeaturedSpecimen> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strings = context.strings;
    final language = context.language;
    final meta = widget.entry.meta;
    final otherName = meta.name.resolveOther(language);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: palette.accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              AppType.label(context, strings.featuredLabel),
              style: AppType.meta(context, size: 10.5, color: palette.muted),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Transform.rotate(
          angle: -0.012,
          child: MouseRegion(
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: _hovered ? palette.lineStrong : palette.line,
                ),
                boxShadow: [
                  BoxShadow(
                    color: palette.shadow.withValues(
                      alpha: _hovered ? 0.17 : 0.1,
                    ),
                    blurRadius: _hovered ? 34 : 26,
                    offset: Offset(0, _hovered ? 17 : 13),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 188,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: PreviewStage(
                            color: categoryMat(context, meta.category),
                            padding: const EdgeInsets.all(22),
                            borderRadius: BorderRadius.zero,
                            child: meta.preview(context),
                          ),
                        ),
                        PositionedDirectional(
                          top: 12,
                          start: 14,
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
                          top: 12,
                          end: 14,
                          child: Text(
                            strings.twoDigits(widget.number),
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
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      16,
                      13,
                      12,
                      13,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meta.name.resolve(language),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                otherName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppType.meta(
                                  context,
                                  size: 10.5,
                                  color: palette.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: widget.onOpen,
                          tooltip: strings.featuredAction,
                          style: IconButton.styleFrom(
                            backgroundColor: palette.raised,
                            foregroundColor: palette.ink,
                            hoverColor: palette.accentSoft,
                            focusColor: palette.accent.withValues(alpha: 0.3),
                            minimumSize: const Size(38, 38),
                            maximumSize: const Size(38, 38),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                              side: BorderSide(color: palette.line),
                            ),
                          ),
                          icon: Transform.flip(
                            flipX: context.isArabic,
                            child: const Icon(
                              Icons.north_east_rounded,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
