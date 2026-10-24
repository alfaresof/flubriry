import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/theme/app_typography.dart';
import 'package:flubriry/views/shared/copy_button.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/views/shared/preview_stage.dart';
import 'package:flutter/material.dart';

class ComponentCard extends StatefulWidget {
  const ComponentCard({
    super.key,
    required this.entry,
    required this.number,
    required this.onOpen,
  });

  final ComponentEntry entry;
  final int number;
  final VoidCallback onOpen;

  @override
  State<ComponentCard> createState() => _ComponentCardState();
}

class _ComponentCardState extends State<ComponentCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strings = context.strings;
    final language = context.language;
    final meta = widget.entry.meta;
    final mat = categoryMat(context, meta.category);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: _hovered ? palette.lineStrong : palette.line,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: palette.shadow.withValues(alpha: 0.14),
                    blurRadius: 30,
                    offset: const Offset(0, 16),
                  ),
                ]
              : const [],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Expanded(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: widget.onOpen,
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: PreviewStage(
                          color: mat,
                          borderRadius: BorderRadius.zero,
                          padding: const EdgeInsets.all(22),
                          child: meta.preview(context),
                        ),
                      ),
                      PositionedDirectional(
                        top: 13,
                        start: 15,
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
                        top: 13,
                        end: 15,
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
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: palette.line)),
              ),
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meta.name.resolve(language),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          meta.name.resolveOther(language),
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
                  CopyButton(
                    key: ValueKey('copy-${meta.id}'),
                    text: widget.entry.code,
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    key: ValueKey('open-${meta.id}'),
                    onPressed: widget.onOpen,
                    tooltip: strings.openComponent,
                    style: IconButton.styleFrom(
                      backgroundColor: palette.raised,
                      foregroundColor: palette.ink,
                      hoverColor: palette.accentSoft,
                      focusColor: palette.accent.withValues(alpha: 0.3),
                      minimumSize: const Size(38, 38),
                      maximumSize: const Size(38, 38),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: palette.line),
                      ),
                    ),
                    icon: const Icon(Icons.open_in_full_rounded, size: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
