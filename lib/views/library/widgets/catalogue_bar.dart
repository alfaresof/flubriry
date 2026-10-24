import 'package:flubriry/controllers/catalogue_controller.dart';
import 'package:flubriry/models/component_catalog.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/theme/app_spacing.dart';
import 'package:flubriry/theme/app_typography.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatalogueBar extends ConsumerWidget {
  const CatalogueBar({super.key, required this.searchFocus});

  final FocusNode searchFocus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 980;
    final view = ref.watch(catalogueViewProvider);
    final selectedCategory = ref.watch(
      catalogueControllerProvider.select((state) => state.category),
    );
    final counts = ComponentCatalog.counts;

    final search = SearchField(focusNode: searchFocus);
    final tabs = _CategoryTabs(
      counts: counts,
      selected: selectedCategory,
      onChanged: (category) =>
          ref.read(catalogueControllerProvider.notifier).setCategory(category),
    );

    return PageBounds(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: 370, child: search),
                  const SizedBox(width: 22),
                  Expanded(child: tabs),
                  const SizedBox(width: 16),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ResultCount(
                      start: view.start,
                      end: view.end,
                      total: view.filteredCount,
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  search,
                  const SizedBox(height: 14),
                  tabs,
                  const SizedBox(height: 10),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: _ResultCount(
                      start: view.start,
                      end: view.end,
                      total: view.filteredCount,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class SearchField extends ConsumerStatefulWidget {
  const SearchField({super.key, required this.focusNode});

  final FocusNode focusNode;

  @override
  ConsumerState<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<SearchField> {
  late final TextEditingController _controller;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(catalogueControllerProvider).query,
    );
    widget.focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_onFocusChanged);
      widget.focusNode.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (widget.focusNode.hasFocus != _focused) {
      setState(() => _focused = widget.focusNode.hasFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    final strings = context.strings;
    final narrow = MediaQuery.sizeOf(context).width < 600;
    final query = ref.watch(
      catalogueControllerProvider.select((state) => state.query),
    );

    ref.listen(catalogueControllerProvider.select((state) => state.query), (
      previous,
      next,
    ) {
      if (_controller.text != next) {
        _controller.value = TextEditingValue(
          text: next,
          selection: TextSelection.collapsed(offset: next.length),
        );
      }
    });

    void update(String value) {
      ref.read(catalogueControllerProvider.notifier).setQuery(value);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 46,
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: _focused ? palette.ink : palette.line,
          width: _focused ? 1.4 : 1,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(
            Icons.search_rounded,
            size: 18,
            color: _focused ? palette.ink : palette.muted,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              key: const ValueKey('catalogue-search'),
              controller: _controller,
              focusNode: widget.focusNode,
              onChanged: update,
              onSubmitted: (_) => widget.focusNode.unfocus(),
              textInputAction: TextInputAction.search,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: palette.ink,
                fontSize: 14,
                height: 1.3,
              ),
              cursorColor: palette.accentStrong,
              decoration: InputDecoration(
                hintText: strings.searchHint,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: palette.muted,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (query.isNotEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 6),
              child: IconButton(
                onPressed: () {
                  update('');
                  widget.focusNode.requestFocus();
                },
                tooltip: strings.searchClear,
                style: IconButton.styleFrom(
                  foregroundColor: palette.muted,
                  hoverColor: palette.accentSoft,
                  focusColor: palette.accent.withValues(alpha: 0.28),
                  minimumSize: const Size(30, 30),
                  maximumSize: const Size(30, 30),
                  padding: EdgeInsets.zero,
                ),
                icon: const Icon(Icons.close_rounded, size: 16),
              ),
            )
          else if (!narrow && !_focused)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 10),
              child: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: palette.raised,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: palette.line),
                ),
                child: Text(
                  '/',
                  style: AppType.meta(
                    context,
                    size: 10.5,
                    color: palette.muted,
                  ),
                ),
              ),
            )
          else
            const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({
    required this.counts,
    required this.selected,
    required this.onChanged,
  });

  final Map<ComponentCategory, int> counts;
  final ComponentCategory? selected;
  final ValueChanged<ComponentCategory?> onChanged;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final total = counts.values.fold<int>(0, (sum, value) => sum + value);
    final entries = <(String, int, ComponentCategory?)>[
      (strings.allCategory, total, null),
      for (final category in ComponentCategory.values)
        (strings.categoryLabel(category), counts[category] ?? 0, category),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final (label, count, category) in entries)
            _CategoryTab(
              label: label,
              count: count,
              selected: selected == category,
              onTap: () => onChanged(category),
            ),
        ],
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  const _CategoryTab({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    final strings = context.strings;

    return Semantics(
      button: true,
      selected: selected,
      label: '$label, $count',
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          hoverColor: palette.accentSoft,
          focusColor: palette.accent.withValues(alpha: 0.28),
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 10,
              end: 10,
              top: 8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: selected ? palette.ink : palette.muted,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: 13,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      strings.twoDigits(count),
                      style: AppType.meta(
                        context,
                        size: 9.5,
                        color: selected
                            ? palette.ink.withValues(alpha: 0.6)
                            : palette.muted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  width: selected ? 26 : 0,
                  height: 2,
                  decoration: BoxDecoration(
                    color: palette.accent,
                    borderRadius: BorderRadius.circular(2),
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

class _ResultCount extends StatelessWidget {
  const _ResultCount({
    required this.start,
    required this.end,
    required this.total,
  });

  final int start;
  final int end;
  final int total;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Semantics(
      liveRegion: true,
      child: Text(
        AppType.label(context, strings.showingRange(start, end, total)),
        style: AppType.meta(context, size: 10, color: context.palette.muted),
      ),
    );
  }
}
