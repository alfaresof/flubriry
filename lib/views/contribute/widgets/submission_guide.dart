import 'package:flubriry/config/site.dart';
import 'package:flubriry/models/component_catalog.dart';
import 'package:flubriry/services/open_link.dart';
import 'package:flubriry/theme/app_typography.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/views/shared/copy_button.dart';
import 'package:flutter/material.dart';

class SubmissionGuide extends StatelessWidget {
  const SubmissionGuide({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strings = context.strings;
    final wide = MediaQuery.sizeOf(context).width >= 940;

    final steps = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppType.label(context, strings.howItWorks),
          style: AppType.meta(context, size: 10, color: palette.muted),
        ),
        const SizedBox(height: 18),
        _Step(number: '1', title: strings.step1Title, body: strings.step1Body),
        const SizedBox(height: 20),
        _Step(number: '2', title: strings.step2Title, body: strings.step2Body),
        const SizedBox(height: 20),
        _Step(number: '3', title: strings.step3Title, body: strings.step3Body),
        const SizedBox(height: 22),
        const _TemplateLink(),
      ],
    );

    return Container(
      padding: EdgeInsets.all(wide ? 32 : 22),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: palette.line),
      ),
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: steps),
                const SizedBox(width: 40),
                const Expanded(flex: 6, child: _TerminalWithNote()),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                steps,
                const SizedBox(height: 26),
                const _TerminalWithNote(),
              ],
            ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.title, required this.body});

  final String number;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: palette.accentSoft,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            number,
            style: AppType.meta(
              context,
              size: 11,
              color: palette.accentStrong,
              weight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: palette.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                body,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: palette.muted,
                  fontSize: 12.5,
                  height: 1.65,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TemplateLink extends StatelessWidget {
  const _TemplateLink();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strings = context.strings;
    return Semantics(
      link: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => openExternal(context, Site.templateUrl),
          borderRadius: BorderRadius.circular(8),
          hoverColor: palette.accentSoft,
          focusColor: palette.accent.withValues(alpha: 0.28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  strings.openTemplate,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: palette.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(width: 7),
                Transform.flip(
                  flipX: context.isArabic,
                  child: Icon(
                    Icons.arrow_outward_rounded,
                    size: 14,
                    color: palette.accentStrong,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TerminalWithNote extends StatelessWidget {
  const _TerminalWithNote();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Terminal(),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 5,
              height: 5,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: palette.accent,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                context.strings.localGeneratorNote,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: palette.muted,
                  fontSize: 11,
                  height: 1.55,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Terminal extends StatelessWidget {
  const _Terminal();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strings = context.strings;
    final count = ComponentCatalog.all.length;
    final compact = MediaQuery.sizeOf(context).width < 600;

    final codeStyle = AppType.monoStyle(
      context,
      size: compact ? 11 : 12,
      color: palette.codeInk,
      height: 1.9,
    );
    final dimStyle = codeStyle.copyWith(
      color: palette.codeInk.withValues(alpha: 0.62),
    );
    // The terminal is always dark, so it uses a fixed readable code accent
    // instead of the current page accent.
    final codeAccent = const Color(0xFF8ED8FF);
    final accentStyle = codeStyle.copyWith(
      color: codeAccent,
      fontWeight: FontWeight.w500,
    );

    return Container(
      decoration: BoxDecoration(
        color: palette.codeBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.onContrast.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(18, 10, 10, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    AppType.label(context, strings.oneCommandLabel),
                    style: AppType.meta(
                      context,
                      size: 9.5,
                      color: palette.codeInk.withValues(alpha: 0.65),
                    ),
                  ),
                ),
                const CopyButton(
                  text: Site.generatorCommand,
                  tone: CopyButtonTone.inverse,
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: palette.onContrast.withValues(alpha: 0.12),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
            child: SelectionArea(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: strings.folderName,
                        style: codeStyle.copyWith(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(text: '\n', style: codeStyle),
                      TextSpan(
                        text: '  ${strings.placeholderComponentName}',
                        style: accentStyle,
                      ),
                      TextSpan(text: '\n  // <flubriry:code>', style: dimStyle),
                      TextSpan(
                        text: '\n  // </flubriry:code>\n\n',
                        style: dimStyle,
                      ),
                      TextSpan(text: r'$ ', style: accentStyle),
                      TextSpan(text: Site.generatorCommand, style: codeStyle),
                      TextSpan(
                        text: '\n${strings.generatorOutput(count)}',
                        style: codeStyle.copyWith(
                          color: const Color(0xFF8CC69B),
                        ),
                      ),
                    ],
                  ),
                  softWrap: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
