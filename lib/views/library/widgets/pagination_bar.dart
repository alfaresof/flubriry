import 'package:flubriry/models/catalogue_view.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flutter/material.dart';

class PaginationBar extends StatelessWidget {
  const PaginationBar({super.key, required this.view, required this.onChanged});

  final CatalogueView view;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strings = context.strings;
    final pages = _pageWindow(view.pageIndex, view.pageCount);

    return Semantics(
      container: true,
      label: strings.pageOf(view.pageIndex + 1, view.pageCount),
      child: Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ArrowButton(
              icon: Icons.chevron_left_rounded,
              tooltip: strings.previousPage,
              enabled: view.pageIndex > 0,
              onTap: () => onChanged(view.pageIndex - 1),
            ),
            const SizedBox(width: 7),
            for (final page in pages) ...[
              if (page == null)
                SizedBox(
                  width: 26,
                  child: Center(
                    child: Text(
                      '…',
                      style: TextStyle(color: palette.muted, fontSize: 13),
                    ),
                  ),
                )
              else
                _PageButton(
                  key: ValueKey('page-${page + 1}'),
                  page: page,
                  selected: page == view.pageIndex,
                  onTap: () => onChanged(page),
                ),
              const SizedBox(width: 7),
            ],
            _ArrowButton(
              icon: Icons.chevron_right_rounded,
              tooltip: strings.nextPage,
              enabled: view.pageIndex < view.pageCount - 1,
              onTap: () => onChanged(view.pageIndex + 1),
            ),
          ],
        ),
      ),
    );
  }

  List<int?> _pageWindow(int current, int count) {
    if (count <= 7) {
      return [for (var i = 0; i < count; i++) i];
    }
    final visible = <int>{
      0,
      count - 1,
      current - 1,
      current,
      current + 1,
    }.where((value) => value >= 0 && value < count).toList()..sort();
    final output = <int?>[];
    for (var i = 0; i < visible.length; i++) {
      if (i > 0 && visible[i] != visible[i - 1] + 1) output.add(null);
      output.add(visible[i]);
    }
    return output;
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    super.key,
    required this.page,
    required this.selected,
    required this.onTap,
  });

  final int page;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    final label = context.strings.pageNumber(page + 1);

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: selected ? palette.accent : palette.surface,
        borderRadius: BorderRadius.circular(9),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          focusColor: palette.accent.withValues(alpha: 0.26),
          hoverColor: selected
              ? palette.onContrast.withValues(alpha: 0.1)
              : palette.accentSoft,
          child: Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: selected ? palette.accent : palette.line,
              ),
            ),
            child: Text(
              '${page + 1}',
              style: theme.textTheme.labelMedium?.copyWith(
                color: selected ? palette.accentInk : palette.ink,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.icon,
    required this.tooltip,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      button: true,
      enabled: enabled,
      label: tooltip,
      excludeSemantics: true,
      onTap: enabled ? onTap : null,
      child: Tooltip(
        message: tooltip,
        excludeFromSemantics: true,
        child: Material(
          color: palette.surface,
          borderRadius: BorderRadius.circular(9),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: enabled ? onTap : null,
            focusColor: palette.accent.withValues(alpha: 0.26),
            hoverColor: enabled ? palette.accentSoft : Colors.transparent,
            child: Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: palette.line),
              ),
              child: Transform.flip(
                flipX: context.isArabic,
                child: Icon(
                  icon,
                  size: 17,
                  color: enabled
                      ? palette.ink
                      : palette.muted.withValues(alpha: 0.4),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
