import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/registry.g.dart';

abstract final class ComponentCatalog {
  static final List<ComponentEntry> all = _build();

  static List<ComponentEntry> _build() {
    final entries = [...generatedRegistry]
      ..sort((a, b) {
        final byOrder = a.meta.order.compareTo(b.meta.order);
        return byOrder != 0 ? byOrder : a.meta.id.compareTo(b.meta.id);
      });
    assert(
      entries.map((entry) => entry.meta.id).toSet().length == entries.length,
      'Component ids must be unique.',
    );
    return List.unmodifiable(entries);
  }

  static ComponentEntry? byId(String id) {
    for (final entry in all) {
      if (entry.meta.id == id) return entry;
    }
    return null;
  }

  static Map<ComponentCategory, int> get counts {
    final counts = {
      for (final category in ComponentCategory.values) category: 0,
    };
    for (final entry in all) {
      counts[entry.meta.category] = counts[entry.meta.category]! + 1;
    }
    return counts;
  }

  static List<ComponentEntry> filter({
    String query = '',
    ComponentCategory? category,
  }) {
    final tokens = _tokens(query);
    return all
        .where((entry) {
          if (category != null && entry.meta.category != category) return false;
          if (tokens.isEmpty) return true;
          final haystack = _searchable(entry.meta);
          return tokens.every(haystack.contains);
        })
        .toList(growable: false);
  }

  static List<String> _tokens(String query) {
    return _normalize(query)
        .split(' ')
        .where((token) => token.isNotEmpty)
        .toList(growable: false);
  }

  static String _searchable(ComponentMeta meta) {
    return _normalize(
      [
        meta.id.replaceAll('-', ' '),
        meta.name.en,
        meta.name.ar,
        meta.description.en,
        meta.description.ar,
        meta.category.id,
        ...meta.tags,
        ...meta.dependencies,
      ].join(' '),
    );
  }

  /// Folds Arabic variants and strips diacritics so amateur spelling still
  /// finds the shelf item.
  static String _normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp('[أإآٱ]'), 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll(RegExp(r'[\u064B-\u0652]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
