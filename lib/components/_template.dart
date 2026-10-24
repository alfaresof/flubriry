// ─────────────────────────────────────────────────────────────────────────────
// flubriry · component template
//
// 1. Copy this file to lib/components/your_component.dart
// 2. Rename YourComponent and _YourPreview. Keep the metadata variable named
//    exactly `componentMeta` — the generator looks for it.
// 3. Keep the <flubriry:code> markers. Everything between them is what users
//    copy from the catalogue.
// 4. Run: dart run tool/generate_registry.dart
//
// Files that start with an underscore are ignored by the generator.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/models/localized_text.dart';

// <flubriry:code>
/// Replace this with your component. It should compile on its own with only
/// the imports above the markers.
class YourComponent extends StatelessWidget {
  const YourComponent({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return FilledButton.tonal(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: colors.primaryContainer,
        foregroundColor: colors.onPrimaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(label),
    );
  }
}
// </flubriry:code>

final ComponentMeta componentMeta = ComponentMeta(
  id: 'your-component',
  order: 999,
  category: ComponentCategory.display,
  name: const LocalizedText('Your Component', 'مكونك'),
  description: const LocalizedText(
    'One sentence about what makes this component worth borrowing.',
    'جملة واحدة عمّا يجعل هذا المكون جديرًا بالاقتباس.',
  ),
  tags: const ['your', 'tags', 'وسوم'],
  preview: (context) => _YourPreview(),
);

class _YourPreview extends StatelessWidget {
  const _YourPreview();

  @override
  Widget build(BuildContext context) {
    return YourComponent(label: context.strings.demoContinue, onPressed: () {});
  }
}
