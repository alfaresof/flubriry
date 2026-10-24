import 'package:flubriry/models/component_category.dart';

/// The catalogue's view state: what is being searched, which shelf is open,
/// and which page is visible.
class CatalogueState {
  const CatalogueState({this.query = '', this.category, this.page = 0});

  final String query;
  final ComponentCategory? category;
  final int page;

  CatalogueState copyWith({
    String? query,
    ComponentCategory? category,
    int? page,
    bool clearCategory = false,
  }) {
    return CatalogueState(
      query: query ?? this.query,
      category: clearCategory ? null : (category ?? this.category),
      page: page ?? this.page,
    );
  }
}
