import 'package:flubriry/models/component_meta.dart';

/// One rendered page of the catalogue.
class CatalogueView {
  const CatalogueView({
    required this.entries,
    required this.pageIndex,
    required this.pageCount,
    required this.filteredCount,
    required this.totalCount,
    required this.pageSize,
  });

  final List<ComponentEntry> entries;
  final int pageIndex;
  final int pageCount;
  final int filteredCount;
  final int totalCount;
  final int pageSize;

  bool get isEmpty => filteredCount == 0;

  int get start => filteredCount == 0 ? 0 : pageIndex * pageSize + 1;

  int get end {
    final candidate = (pageIndex + 1) * pageSize;
    return candidate > filteredCount ? filteredCount : candidate;
  }
}
