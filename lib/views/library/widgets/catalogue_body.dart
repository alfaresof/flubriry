import 'package:flubriry/controllers/catalogue_controller.dart';
import 'package:flubriry/models/component_catalog.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/theme/app_spacing.dart';
import 'package:flubriry/views/library/widgets/component_card.dart';
import 'package:flubriry/views/library/widgets/pagination_bar.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/components/empty_nest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CatalogueBody extends ConsumerWidget {
  const CatalogueBody({
    super.key,
    required this.onOpen,
    required this.onPageChanged,
  });

  final ValueChanged<ComponentEntry> onOpen;
  final VoidCallback onPageChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(catalogueViewProvider);
    final width = MediaQuery.sizeOf(context).width;
    final strings = context.strings;

    if (view.isEmpty) {
      final noComponents = view.totalCount == 0;
      return PageBounds(
        child: Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 32),
          child: Center(
            child: EmptyNest(
              title: noComponents
                  ? strings.noComponentsTitle
                  : strings.emptyTitle,
              message: noComponents
                  ? strings.noComponentsBody
                  : strings.emptyBody,
              actionLabel: noComponents
                  ? strings.contributeCta
                  : strings.clearFilters,
              onAction: noComponents
                  ? () => context.go('/contribute')
                  : () {
                      ref.read(catalogueControllerProvider.notifier).clear();
                    },
            ),
          ),
        ),
      );
    }

    final columns = width >= 1120 ? 3 : (width >= 700 ? 2 : 1);
    final cardHeight = width >= 1120
        ? 404.0
        : width >= 700
        ? 388.0
        : 356.0;

    return PageBounds(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 6, bottom: 8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              mainAxisExtent: cardHeight,
            ),
            itemCount: view.entries.length,
            itemBuilder: (context, index) {
              final entry = view.entries[index];
              final catalogueNumber = ComponentCatalog.all.indexOf(entry) + 1;
              return _Reveal(
                key: ValueKey(entry.meta.id),
                index: index,
                child: ComponentCard(
                  entry: entry,
                  number: catalogueNumber,
                  onOpen: () => onOpen(entry),
                ),
              );
            },
          ),
          if (view.pageCount > 1)
            PaginationBar(
              view: view,
              onChanged: (page) {
                ref.read(catalogueControllerProvider.notifier).setPage(page);
                onPageChanged();
              },
            ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}

/// One staggered entrance for each shelf page, then the cards stay put.
class _Reveal extends StatefulWidget {
  const _Reveal({super.key, required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<_Reveal> createState() => _RevealState();
}

class _RevealState extends State<_Reveal> {
  bool _shown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(Duration(milliseconds: 34 * widget.index), () {
        if (mounted) setState(() => _shown = true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final shown = _shown || reduceMotion;
    return AnimatedOpacity(
      opacity: shown ? 1 : 0,
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      child: AnimatedSlide(
        offset: shown ? Offset.zero : const Offset(0, 0.035),
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
