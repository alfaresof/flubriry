#!/usr/bin/env dart

//
// Builds lib/registry.g.dart from the files in lib/components.
//
//   dart run tool/generate_registry.dart
//
// Every component file must expose a top-level `final ComponentMeta
// componentMeta` and wrap its copyable source in:
//
//   // <flubriry:code>
//   ...
//   // </flubriry:code>
//
// Files whose name starts with an underscore are ignored.

import 'dart:io';

const _componentsDirectory = 'lib/components';
const _registryPath = 'lib/registry.g.dart';
const _repoUrl = 'https://github.com/alfaresof/flubriry';
const _codeOpen = '// <flubriry:code>';
const _codeClose = '// </flubriry:code>';

void main(List<String> arguments) {
  final root = Directory.current;
  if (!File('${root.path}/pubspec.yaml').existsSync()) {
    _fail(
      'Run this from the project root (the folder that contains pubspec.yaml).',
    );
  }

  final componentsDirectory = Directory('${root.path}/$_componentsDirectory');
  if (!componentsDirectory.existsSync()) {
    _fail('Missing $_componentsDirectory.');
  }

  final files =
      componentsDirectory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .where((file) => !_fileName(file.path).startsWith('_'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final components = <_ComponentSource>[];
  final seenIds = <String, String>{};

  for (final file in files) {
    final source = file.readAsStringSync();
    final path = _relativePath(root, file);
    final component = _parse(source, path);
    final existing = seenIds[component.id];
    if (existing != null) {
      _fail('Duplicate component id "${component.id}" in $path and $existing.');
    }
    seenIds[component.id] = path;
    components.add(component);
  }

  components.sort((a, b) {
    final byOrder = a.order.compareTo(b.order);
    return byOrder != 0 ? byOrder : a.path.compareTo(b.path);
  });

  final output = StringBuffer()
    ..writeln('// GENERATED CODE — do not edit by hand.')
    ..writeln('// Run `dart run tool/generate_registry.dart` instead.')
    ..writeln()
    ..writeln("import 'package:flubriry/models/component_meta.dart';")
    ..writeln();

  for (var index = 0; index < components.length; index++) {
    final importPath = components[index].path.startsWith('lib/')
        ? components[index].path.substring(4)
        : components[index].path;
    output.writeln("import 'package:flubriry/$importPath' as component$index;");
  }

  for (var index = 0; index < components.length; index++) {
    output
      ..writeln()
      ..writeln('const String _code$index = r\'\'\'')
      ..writeln(components[index].copyableCode)
      ..writeln('\'\'\';');
  }

  output
    ..writeln()
    ..writeln('final List<ComponentEntry> generatedRegistry = [')
    ..writeln(
      '  // ${components.length} components, ordered by their metadata.',
    );

  for (var index = 0; index < components.length; index++) {
    final component = components[index];
    output
      ..writeln('  ComponentEntry(')
      ..writeln('    meta: component$index.componentMeta,')
      ..writeln('    code: _code$index,')
      ..writeln("    sourcePath: '${component.path}',")
      ..writeln('  ),');
  }
  output
    ..writeln('];')
    ..writeln();

  final registry = File('${root.path}/$_registryPath')
    ..writeAsStringSync(output.toString());

  final format = Process.runSync(Platform.resolvedExecutable, [
    'format',
    registry.path,
  ]);
  if (format.exitCode != 0) {
    stderr.write(format.stderr);
    _fail('Generated the registry but could not format it.');
  }

  stdout.writeln(
    'Registered ${components.length} components in $_registryPath',
  );
  for (final component in components) {
    final dependencyNote = component.dependencies.isEmpty
        ? 'pure Flutter'
        : component.dependencies.join(', ');
    stdout.writeln(
      '  ${component.id.padRight(18)} ${component.path}  ($dependencyNote)',
    );
  }
}

class _ComponentSource {
  _ComponentSource({
    required this.id,
    required this.order,
    required this.path,
    required this.copyableCode,
    required this.dependencies,
  });

  final String id;
  final int order;
  final String path;
  final String copyableCode;
  final List<String> dependencies;
}

_ComponentSource _parse(String source, String path) {
  final codeStart = source.indexOf(_codeOpen);
  final codeEnd = source.indexOf(_codeClose);
  if (codeStart == -1 || codeEnd == -1 || codeEnd <= codeStart) {
    _fail('Missing or malformed $_codeOpen / $_codeClose markers in $path.');
  }

  final metaStart = source.indexOf('ComponentMeta componentMeta');
  if (metaStart == -1) {
    _fail('Missing `final ComponentMeta componentMeta = ...` in $path.');
  }
  final meta = source.substring(metaStart);

  final id = RegExp(r"id:\s*'([^']+)'").firstMatch(meta)?.group(1);
  if (id == null || id.isEmpty) {
    _fail('Missing component id in $path.');
  }
  if (!RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$').hasMatch(id)) {
    _fail(
      'Invalid component id "$id" in $path. Use lowercase words separated by '
      'hyphens, e.g. "my-component".',
    );
  }

  final orderText = RegExp(r'order:\s*(\d+)').firstMatch(meta)?.group(1);
  if (orderText == null) {
    _fail('Missing numeric order in $path.');
  }

  final dependencies = <String>[];
  final dependencyMatch = RegExp(r'dependencies:\s*const\s*\[([\s\S]*?)\]')
      .firstMatch(meta);
  if (dependencyMatch != null) {
    for (final match in RegExp(
      r"'([^']+)'",
    ).allMatches(dependencyMatch.group(1)!)) {
      dependencies.add(match.group(1)!);
    }
  }

  final imports = <String>{};
  for (final match in RegExp(
    r'^import\s+[^;]+;',
    multiLine: true,
  ).allMatches(source)) {
    final directive = match.group(0)!;
    if (directive.contains('package:flubriry/')) continue;
    final uri = RegExp(r'''import\s+['"]([^'"]+)['"]''')
        .firstMatch(directive)
        ?.group(1);
    if (uri == null ||
        (!uri.startsWith('dart:') && !uri.startsWith('package:'))) {
      _fail(
        'Relative imports are not allowed in $path. A copied component must '
        'stand on its own — use SDK or published packages only.',
      );
    }
    imports.add(directive);
  }
  final sortedImports = imports.toList()..sort(_compareImports);

  final snippet = source
      .substring(codeStart + _codeOpen.length, codeEnd)
      .trim();

  final header = <String>[
    '// flubriry · $id',
    '// $_repoUrl',
    if (dependencies.isNotEmpty) '// Requires: ${dependencies.join(', ')}',
  ];

  final copyable = <String>[
    ...header,
    '',
    ...sortedImports,
    if (sortedImports.isNotEmpty) '',
    snippet,
  ].join('\n');

  if (copyable.contains("'''")) {
    _fail(
      'The copyable source in $path contains a triple quote, which cannot be '
      'embedded in the generated registry. Use a different quote style.',
    );
  }

  return _ComponentSource(
    id: id,
    order: int.parse(orderText),
    path: path,
    copyableCode: copyable,
    dependencies: dependencies,
  );
}

int _compareImports(String a, String b) {
  int rank(String directive) {
    if (directive.startsWith("import 'dart:")) return 0;
    if (directive.startsWith("import 'package:flutter/")) return 1;
    if (directive.startsWith("import 'package:")) return 2;
    return 3;
  }

  final byRank = rank(a).compareTo(rank(b));
  return byRank != 0 ? byRank : a.compareTo(b);
}

String _fileName(String path) => path.split(Platform.pathSeparator).last;

String _relativePath(Directory root, File file) {
  final rootPath = root.absolute.path.endsWith(Platform.pathSeparator)
      ? root.absolute.path
      : '${root.absolute.path}${Platform.pathSeparator}';
  final absolute = file.absolute.path;
  return absolute.startsWith(rootPath)
      ? absolute.substring(rootPath.length)
      : file.path;
}

Never _fail(String message) {
  stderr.writeln('flubriry: $message');
  exit(1);
}
