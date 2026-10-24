import 'package:flutter/widgets.dart';

import 'component_category.dart';
import 'localized_text.dart';

/// Everything a catalogue card needs to know about a component.
///
/// Each file in `lib/components` exposes one of these as `componentMeta`.
/// The preview stays in the component file so the catalogue can render the
/// real thing instead of a screenshot.
class ComponentMeta {
  const ComponentMeta({
    required this.id,
    required this.order,
    required this.category,
    required this.name,
    required this.description,
    required this.preview,
    this.tags = const [],
    this.dependencies = const [],
    this.origin,
  });

  final String id;
  final int order;
  final ComponentCategory category;
  final LocalizedText name;
  final LocalizedText description;
  final WidgetBuilder preview;
  final List<String> tags;
  final List<String> dependencies;

  /// Where the component was first made, e.g. "Qafelah".
  final String? origin;
}

/// A [ComponentMeta] paired with its copy-ready Dart source.
class ComponentEntry {
  const ComponentEntry({
    required this.meta,
    required this.code,
    required this.sourcePath,
  });

  final ComponentMeta meta;
  final String code;
  final String sourcePath;

  String get fileName => sourcePath.split('/').last;
}
