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
    required this.contributor,
    this.contributorAvatar,
  });

  final String id;
  final int order;
  final ComponentCategory category;
  final LocalizedText name;
  final LocalizedText description;
  final WidgetBuilder preview;
  final List<String> tags;
  final List<String> dependencies;

  /// GitHub handle of the person who contributed this component.
  final String contributor;

  /// Optional local asset or https URL for the contributor avatar. When null,
  /// the owner portrait or the GitHub avatar is used.
  final String? contributorAvatar;
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
