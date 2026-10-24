import 'package:flubriry/controllers/catalogue_controller.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/models/site_section.dart';
import 'package:flubriry/views/library/widgets/catalogue_bar.dart';
import 'package:flubriry/views/library/widgets/catalogue_body.dart';
import 'package:flubriry/views/library/widgets/library_hero.dart';
import 'package:flubriry/views/shared/site_footer.dart';
import 'package:flubriry/views/shared/site_header.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  final _scrollController = ScrollController();
  final _searchFocus = FocusNode();
  final _catalogueKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
    );
  }

  void _scrollToCatalogue() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _catalogueKey.currentContext;
      if (context == null) return;
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 440),
        curve: Curves.easeOutCubic,
        alignment: 0.12,
      );
    });
  }

  void _open(ComponentEntry entry) {
    _searchFocus.unfocus();
    context.push('/component/${entry.meta.id}');
  }

  bool _isEditingText() {
    final focused = FocusManager.instance.primaryFocus?.context;
    if (focused == null) return false;
    return focused.widget is EditableText ||
        focused.findAncestorWidgetOfExactType<EditableText>() != null;
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.slash && !_isEditingText()) {
      _searchFocus.requestFocus();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape &&
        _searchFocus.hasFocus) {
      final controller = ref.read(catalogueControllerProvider.notifier);
      final hasQuery = ref.read(catalogueControllerProvider).query.isNotEmpty;
      if (hasQuery) {
        controller.setQuery('');
      } else {
        _searchFocus.unfocus();
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Title(
      title: context.strings.siteTitle,
      color: context.palette.accent,
      child: Scaffold(
        body: Focus(
          autofocus: true,
          skipTraversal: true,
          onKeyEvent: _handleKey,
          child: Scrollbar(
            controller: _scrollController,
            child: CustomScrollView(
              controller: _scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SiteHeaderDelegate(
                    height: SiteHeader.heightFor(width),
                    child: SiteHeader(
                      onBrandTap: _scrollToTop,
                      current: SiteSection.components,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: LibraryHero(
                    onBrowse: _scrollToCatalogue,
                    onOpen: _open,
                  ),
                ),
                SliverToBoxAdapter(
                  child: CatalogueBar(searchFocus: _searchFocus),
                ),
                SliverToBoxAdapter(
                  child: CatalogueBody(
                    key: _catalogueKey,
                    onOpen: _open,
                    onPageChanged: _scrollToCatalogue,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SiteFooter(
                    current: SiteSection.components,
                    onBrandTap: _scrollToTop,
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
