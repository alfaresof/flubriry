import 'dart:math' as math;

import 'package:flubriry/models/catalogue_state.dart';
import 'package:flubriry/models/catalogue_view.dart';
import 'package:flubriry/models/component_catalog.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final catalogueControllerProvider =
    NotifierProvider<CatalogueController, CatalogueState>(
      CatalogueController.new,
      name: 'catalogue',
    );

final filteredEntriesProvider = Provider<List<ComponentEntry>>((ref) {
  final filter = ref.watch(
    catalogueControllerProvider.select(
      (state) => (query: state.query, category: state.category),
    ),
  );
  return ComponentCatalog.filter(
    query: filter.query,
    category: filter.category,
  );
});

final catalogueViewProvider = Provider<CatalogueView>((ref) {
  final filtered = ref.watch(filteredEntriesProvider);
  final requestedPage = ref.watch(
    catalogueControllerProvider.select((state) => state.page),
  );
  final pageCount = math.max(
    1,
    (filtered.length + CatalogueController.pageSize - 1) ~/
        CatalogueController.pageSize,
  );
  final page = requestedPage.clamp(0, pageCount - 1);
  final offset = page * CatalogueController.pageSize;

  return CatalogueView(
    entries: filtered
        .skip(offset)
        .take(CatalogueController.pageSize)
        .toList(growable: false),
    pageIndex: page,
    pageCount: pageCount,
    filteredCount: filtered.length,
    totalCount: ComponentCatalog.all.length,
    pageSize: CatalogueController.pageSize,
  );
});

class CatalogueController extends Notifier<CatalogueState> {
  static const pageSize = 6;

  @override
  CatalogueState build() => const CatalogueState();

  void setQuery(String query) {
    if (query == state.query) return;
    state = state.copyWith(query: query, page: 0);
  }

  void setCategory(ComponentCategory? category) {
    if (category == state.category) return;
    state = CatalogueState(query: state.query, category: category, page: 0);
  }

  void clear() {
    if (state.query.isEmpty && state.category == null && state.page == 0) {
      return;
    }
    state = const CatalogueState();
  }

  void setPage(int page) {
    final filtered = ComponentCatalog.filter(
      query: state.query,
      category: state.category,
    );
    final pageCount = math.max(1, (filtered.length + pageSize - 1) ~/ pageSize);
    final next = page.clamp(0, pageCount - 1);
    if (next == state.page) return;
    state = state.copyWith(page: next);
  }
}
