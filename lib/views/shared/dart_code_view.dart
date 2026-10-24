import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/theme/app_typography.dart';
import 'package:flutter/material.dart';

class DartCodeView extends StatefulWidget {
  const DartCodeView({super.key, required this.code});

  final String code;

  @override
  State<DartCodeView> createState() => _DartCodeViewState();
}

class _DartCodeViewState extends State<DartCodeView> {
  final _controller = ScrollController();

  static const _fontSize = 12.5;
  static const _lineHeight = 1.72;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final lines = widget.code.split('\n');
    final base = AppType.codeStyle(
      palette,
      size: _fontSize,
      height: _lineHeight,
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scrollbar(
        controller: _controller,
        child: SingleChildScrollView(
          controller: _controller,
          padding: const EdgeInsetsDirectional.fromSTEB(14, 16, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < lines.length; index++)
                _CodeLine(
                  number: index + 1,
                  spans: _highlight(lines[index], base),
                  base: base,
                  isEmpty: lines[index].isEmpty,
                  numberColor: palette.codeInk.withValues(alpha: 0.55),
                  lineHeight: _fontSize * _lineHeight,
                ),
            ],
          ),
        ),
      ),
    );
  }

  static const _commentColor = Color(0xFF9C9284);
  static const _keywordColor = Color(0xFFFFC24B);
  static const _stringColor = Color(0xFFCADBAF);
  static const _numberColor = Color(0xFFE0C2EE);
  static const _typeColor = Color(0xFFB3D1E2);

  static const _keywords = {
    'abstract',
    'as',
    'assert',
    'async',
    'await',
    'base',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'continue',
    'covariant',
    'default',
    'deferred',
    'do',
    'dynamic',
    'else',
    'enum',
    'export',
    'extends',
    'extension',
    'external',
    'factory',
    'false',
    'final',
    'finally',
    'for',
    'Function',
    'get',
    'hide',
    'if',
    'implements',
    'import',
    'in',
    'interface',
    'is',
    'late',
    'library',
    'mixin',
    'new',
    'null',
    'on',
    'operator',
    'part',
    'required',
    'rethrow',
    'return',
    'sealed',
    'set',
    'show',
    'static',
    'super',
    'switch',
    'sync',
    'this',
    'throw',
    'true',
    'try',
    'typedef',
    'var',
    'void',
    'when',
    'while',
    'with',
    'yield',
  };

  static const _builtInTypes = {
    'bool',
    'double',
    'int',
    'num',
    'String',
    'Object',
    'List',
    'Map',
    'Set',
    'Future',
    'Stream',
    'Iterable',
    'void',
    'Null',
  };

  static final _identifierStart = RegExp(r'[A-Za-z_$]');
  static final _identifierPart = RegExp(r'[A-Za-z0-9_$]');
  static final _digit = RegExp(r'[0-9]');
  static final _numberPart = RegExp(r'[0-9a-fA-FxX.]');

  List<InlineSpan> _highlight(String line, TextStyle base) {
    final spans = <InlineSpan>[];
    var index = 0;

    InlineSpan span(String text, Color color, {FontWeight? weight}) {
      return TextSpan(
        text: text,
        style: base.copyWith(color: color, fontWeight: weight),
      );
    }

    while (index < line.length) {
      if (line.startsWith('//', index)) {
        spans.add(span(line.substring(index), _commentColor));
        break;
      }

      final char = line[index];
      if (char == "'" || char == '"') {
        final quote = char;
        var cursor = index + 1;
        while (cursor < line.length) {
          if (line[cursor] == '\\') {
            cursor += 2;
            continue;
          }
          if (line[cursor] == quote) {
            cursor++;
            break;
          }
          cursor++;
        }
        cursor = cursor.clamp(0, line.length);
        spans.add(span(line.substring(index, cursor), _stringColor));
        index = cursor;
        continue;
      }

      if (_digit.hasMatch(char)) {
        var cursor = index + 1;
        while (cursor < line.length && _numberPart.hasMatch(line[cursor])) {
          cursor++;
        }
        spans.add(span(line.substring(index, cursor), _numberColor));
        index = cursor;
        continue;
      }

      if (char == '@') {
        var cursor = index + 1;
        while (cursor < line.length && _identifierPart.hasMatch(line[cursor])) {
          cursor++;
        }
        spans.add(
          span(
            line.substring(index, cursor),
            _keywordColor,
            weight: FontWeight.w500,
          ),
        );
        index = cursor;
        continue;
      }

      if (_identifierStart.hasMatch(char)) {
        var cursor = index + 1;
        while (cursor < line.length && _identifierPart.hasMatch(line[cursor])) {
          cursor++;
        }
        final word = line.substring(index, cursor);
        final isKeyword = _keywords.contains(word);
        final isType =
            _builtInTypes.contains(word) ||
            (word.isNotEmpty &&
                word[0] == word[0].toUpperCase() &&
                word[0] != word[0].toLowerCase());
        spans.add(
          span(
            word,
            isKeyword
                ? _keywordColor
                : isType
                ? _typeColor
                : base.color ?? const Color(0xFFF3EBDD),
            weight: isKeyword ? FontWeight.w500 : null,
          ),
        );
        index = cursor;
        continue;
      }

      spans.add(span(char, base.color ?? const Color(0xFFF3EBDD)));
      index++;
    }

    return spans;
  }
}

class _CodeLine extends StatelessWidget {
  const _CodeLine({
    required this.number,
    required this.spans,
    required this.base,
    required this.isEmpty,
    required this.numberColor,
    required this.lineHeight,
  });

  final int number;
  final List<InlineSpan> spans;
  final TextStyle base;
  final bool isEmpty;
  final Color numberColor;
  final double lineHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 30,
          child: Text(
            '$number',
            textAlign: TextAlign.right,
            style: base.copyWith(color: numberColor),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: isEmpty
              ? SizedBox(height: lineHeight)
              : Text.rich(TextSpan(children: spans), style: base),
        ),
      ],
    );
  }
}
