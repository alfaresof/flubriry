import 'package:flubriry/controllers/app_settings_controller.dart';
import 'package:flubriry/models/app_accent.dart';
import 'package:flubriry/models/app_language.dart';
import 'package:flubriry/theme/app_typography.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppearanceButton extends ConsumerWidget {
  const AppearanceButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.palette;
    final strings = context.strings;

    return IconButton(
      onPressed: () => showDialog<void>(
        context: context,
        barrierColor: palette.ink.withValues(alpha: 0.34),
        builder: (_) => const AppearanceDialog(),
      ),
      tooltip: strings.appearance,
      style: IconButton.styleFrom(
        backgroundColor: palette.surface,
        foregroundColor: palette.ink,
        hoverColor: palette.accentSoft,
        focusColor: palette.accent.withValues(alpha: 0.28),
        padding: EdgeInsets.zero,
        minimumSize: const Size(40, 36),
        maximumSize: const Size(40, 36),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
          side: BorderSide(color: palette.line),
        ),
      ),
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.palette_outlined, size: 18),
          PositionedDirectional(
            end: -2,
            bottom: -2,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: palette.accent,
                shape: BoxShape.circle,
                border: Border.all(color: palette.surface, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppearanceDialog extends ConsumerWidget {
  const AppearanceDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.palette;
    final strings = context.strings;
    final language = context.language;
    final theme = Theme.of(context);
    final settings = ref.watch(appSettingsProvider);
    final controller = ref.read(appSettingsProvider.notifier);

    return Dialog(
      backgroundColor: palette.surface,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: palette.line),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 380,
          maxHeight: MediaQuery.sizeOf(context).height * 0.86,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.appearance,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: context.isArabic ? 0 : -0.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          strings.appearanceSubtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: palette.muted,
                            fontSize: 12.5,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: strings.close,
                    style: IconButton.styleFrom(
                      foregroundColor: palette.muted,
                      hoverColor: palette.accentSoft,
                      focusColor: palette.accent.withValues(alpha: 0.28),
                      minimumSize: const Size(32, 32),
                      maximumSize: const Size(32, 32),
                      padding: EdgeInsets.zero,
                    ),
                    icon: const Icon(Icons.close_rounded, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _SectionLabel(text: strings.themeLabel),
              const SizedBox(height: 8),
              _ChoiceGroup<ThemeMode>(
                selected: settings.themeMode,
                options: [
                  (ThemeMode.system, strings.themeAuto),
                  (ThemeMode.light, strings.themeLight),
                  (ThemeMode.dark, strings.themeDark),
                ],
                onChanged: controller.setThemeMode,
              ),
              const SizedBox(height: 22),
              _SectionLabel(text: strings.accentLabel),
              const SizedBox(height: 8),
              _AccentGrid(
                selected: settings.accent,
                language: language,
                onChanged: controller.setAccent,
              ),
              const SizedBox(height: 9),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: palette.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      strings.accentHint,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: palette.muted,
                        fontSize: 11.5,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _SectionLabel(text: strings.languageLabel),
              const SizedBox(height: 8),
              _ChoiceGroup<String>(
                selected: settings.language.code,
                options: [
                  ('en', strings.languageEnglish),
                  ('ar', strings.languageArabic),
                ],
                onChanged: (code) {
                  controller.setLanguage(
                    code == 'ar' ? AppLanguage.arabic : AppLanguage.english,
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 44,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: palette.ink,
                    foregroundColor: palette.paper,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    textStyle: theme.textTheme.labelLarge,
                  ),
                  child: Text(strings.done),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      AppType.label(context, text),
      style: AppType.meta(context, size: 9.5, color: context.palette.muted),
    );
  }
}

class _ChoiceGroup<T> extends StatelessWidget {
  const _ChoiceGroup({
    required this.selected,
    required this.options,
    required this.onChanged,
  });

  final T selected;
  final List<(T, String)> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: palette.paper,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: palette.line),
      ),
      child: Row(
        children: [
          for (final (value, label) in options)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Semantics(
                  button: true,
                  selected: selected == value,
                  label: label,
                  excludeSemantics: true,
                  onTap: () => onChanged(value),
                  child: Material(
                    color: selected == value
                        ? palette.accent
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => onChanged(value),
                      borderRadius: BorderRadius.circular(9),
                      hoverColor: palette.accentSoft,
                      focusColor: palette.accent.withValues(alpha: 0.28),
                      child: SizedBox(
                        height: 36,
                        child: Center(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: selected == value
                                  ? palette.accentInk
                                  : palette.muted,
                              fontSize: 12.5,
                              fontWeight: selected == value
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AccentGrid extends StatelessWidget {
  const _AccentGrid({
    required this.selected,
    required this.language,
    required this.onChanged,
  });

  final AppAccent selected;
  final AppLanguage language;
  final ValueChanged<AppAccent> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - 8) / 2;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final accent in AppAccent.values)
              SizedBox(
                key: ValueKey('accent-${accent.id}'),
                width: width,
                child: Semantics(
                  button: true,
                  selected: selected == accent,
                  label: accent.name.resolve(language),
                  excludeSemantics: true,
                  onTap: () => onChanged(accent),
                  child: Material(
                    color: selected == accent
                        ? palette.accentSoft
                        : palette.raised,
                    borderRadius: BorderRadius.circular(11),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => onChanged(accent),
                      borderRadius: BorderRadius.circular(11),
                      hoverColor: palette.accent.withValues(alpha: 0.1),
                      focusColor: palette.accent.withValues(alpha: 0.24),
                      child: Container(
                        height: 46,
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          10,
                          6,
                          10,
                          6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(
                            color: selected == accent
                                ? palette.accent
                                : palette.line,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: accent
                                    .colorsFor(theme.brightness)
                                    .primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: palette.lineStrong,
                                  width: 0.5,
                                ),
                              ),
                              child: selected == accent
                                  ? Icon(
                                      Icons.check_rounded,
                                      size: 13,
                                      color: accent
                                          .colorsFor(theme.brightness)
                                          .onPrimary,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                accent.name.resolve(language),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: palette.ink,
                                  fontSize: 11.5,
                                  fontWeight: selected == accent
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
