import 'package:flubriry/models/component_catalog.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('component catalogue', () {
    test('ships sixteen ordered components with unique ids', () {
      expect(ComponentCatalog.all, hasLength(16));
      expect(
        ComponentCatalog.all.map((entry) => entry.meta.id).toSet(),
        hasLength(16),
      );
      expect(
        ComponentCatalog.all.map((entry) => entry.meta.order).toList(),
        orderedEquals(
          [...ComponentCatalog.all.map((entry) => entry.meta.order)]..sort(),
        ),
      );
    });

    test('every component has copy-ready source without generator markers', () {
      for (final entry in ComponentCatalog.all) {
        expect(entry.code, isNotEmpty, reason: entry.meta.id);
        expect(
          entry.code.startsWith('// flubriry · ${entry.meta.id}'),
          isTrue,
          reason: entry.meta.id,
        );
        expect(entry.code.contains('<flubriry:code>'), isFalse);
        expect(entry.code.contains('</flubriry:code>'), isFalse);
        expect(entry.code.contains('class '), isTrue);
        expect(entry.sourcePath, startsWith('lib/components/'));
      }
    });

    test('filters by id, both languages, tags, and shelf', () {
      expect(
        ComponentCatalog.filter(query: 'squircle').single.meta.id,
        'squircle-button',
      );
      expect(
        ComponentCatalog.filter(query: 'زر').map((entry) => entry.meta.id),
        containsAll(['squircle-button', 'filter-pill']),
      );
      expect(
        ComponentCatalog.filter(category: ComponentCategory.buttons),
        hasLength(3),
      );
      expect(
        ComponentCatalog.filter(query: 'figma').single.meta.id,
        'squircle-button',
      );
      expect(ComponentCatalog.filter(query: 'no-such-specimen'), isEmpty);
    });

    test('counts every shelf', () {
      final counts = ComponentCatalog.counts;
      expect(counts[ComponentCategory.buttons], 3);
      expect(counts[ComponentCategory.inputs], 2);
      expect(counts[ComponentCategory.navigation], 3);
      expect(counts[ComponentCategory.display], 4);
      expect(counts[ComponentCategory.states], 4);
    });
  });
}
