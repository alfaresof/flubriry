import 'package:flutter/material.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/models/localized_text.dart';

// <flubriry:code>
/// A quiet labelled field: label above, helper below, and a solid accent
/// focus ring that wraps the whole note.
class FieldNote extends StatefulWidget {
  const FieldNote({
    super.key,
    required this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.onSubmitted,
    this.autofillHints,
  });

  final String label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;

  @override
  State<FieldNote> createState() => _FieldNoteState();
}

class _FieldNoteState extends State<FieldNote> {
  late final FocusNode _focusNode;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocus);
  }

  void _handleFocus() {
    if (_focused == _focusNode.hasFocus) return;
    setState(() => _focused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final hasError = widget.errorText != null;
    final noteColor = hasError ? colors.error : colors.primary;
    final borderColor = hasError
        ? colors.error
        : _focused
        ? colors.primary
        : colors.outlineVariant;

    return Semantics(
      label: widget.label,
      textField: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colors.onSurface,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 170),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: _focused || hasError
                  ? noteColor.withValues(alpha: 0.16)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(17),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 170),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: borderColor,
                  width: _focused || hasError ? 1.4 : 1,
                ),
              ),
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                keyboardType: widget.keyboardType,
                obscureText: widget.obscureText,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                autofillHints: widget.autofillHints,
                cursorColor: colors.primary,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurface,
                  fontSize: 14.5,
                  height: 1.35,
                ),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.62),
                    fontSize: 14.5,
                  ),
                  prefixIcon: widget.prefixIcon == null
                      ? null
                      : Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 14,
                            end: 10,
                          ),
                          child: Icon(
                            widget.prefixIcon,
                            size: 19,
                            color: _focused
                                ? colors.primary
                                : colors.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: widget.prefixIcon == null ? 15 : 4,
                    vertical: 15,
                  ),
                ),
              ),
            ),
          ),
          if (widget.errorText != null || widget.helperText != null) ...[
            const SizedBox(height: 7),
            Text(
              widget.errorText ?? widget.helperText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: hasError
                    ? colors.error
                    : colors.onSurface.withValues(alpha: 0.68),
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
// </flubriry:code>

final ComponentMeta componentMeta = ComponentMeta(
  id: 'field-note',
  order: 40,
  category: ComponentCategory.inputs,
  name: const LocalizedText('Field Note', 'حقل الملاحظة'),
  description: const LocalizedText(
    'A labelled field with its helper kept close. Focus wraps the whole note in a solid accent ring instead of a glow.',
    'حقل بعنوان وملاحظة قريبة منه. يحيط التركيز بالحقل بحلقة واضحة بلون التمييز بدلًا من توهّج.',
  ),
  tags: const [
    'input',
    'text field',
    'form',
    'focus',
    'helper',
    'حقل',
    'نموذج',
    'تركيز',
  ],
  contributor: 'alfaresof',
  preview: (context) => const _FieldPreview(),
);

class _FieldPreview extends StatelessWidget {
  const _FieldPreview();

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return SizedBox(
      width: 292,
      child: FieldNote(
        label: strings.demoEmailLabel,
        hint: strings.demoEmailHint,
        helperText: strings.demoEmailHelper,
        prefixIcon: Icons.alternate_email_rounded,
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}
