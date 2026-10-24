import 'package:flubriry/models/app_accent.dart';
import 'package:flutter/material.dart';

/// The cool paper-and-ink palette that holds the catalogue together.
///
/// The accent fields are replaced by the selected [AppAccent]; everything else
/// stays constant so the components keep their rhythm when colors change.
@immutable
class FlubPalette extends ThemeExtension<FlubPalette> {
  const FlubPalette({
    required this.paper,
    required this.surface,
    required this.raised,
    required this.ink,
    required this.muted,
    required this.faint,
    required this.line,
    required this.lineStrong,
    required this.stage,
    required this.accent,
    required this.accentStrong,
    required this.accentInk,
    required this.accentSoft,
    required this.success,
    required this.successSoft,
    required this.matButtons,
    required this.matInputs,
    required this.matNavigation,
    required this.matDisplay,
    required this.matStates,
    required this.contrast,
    required this.onContrast,
    required this.codeBg,
    required this.codeInk,
    required this.shadow,
  });

  final Color paper;
  final Color surface;
  final Color raised;
  final Color ink;
  final Color muted;
  final Color faint;
  final Color line;
  final Color lineStrong;
  final Color stage;
  final Color accent;
  final Color accentStrong;
  final Color accentInk;
  final Color accentSoft;
  final Color success;
  final Color successSoft;
  final Color matButtons;
  final Color matInputs;
  final Color matNavigation;
  final Color matDisplay;
  final Color matStates;
  final Color contrast;
  final Color onContrast;
  final Color codeBg;
  final Color codeInk;
  final Color shadow;

  static const lightBase = FlubPalette(
    paper: Color(0xFFF4F8FC),
    surface: Color(0xFFFBFDFF),
    raised: Color(0xFFFFFFFF),
    ink: Color(0xFF071A2B),
    muted: Color(0xFF566879),
    faint: Color(0xFF8A9AAA),
    line: Color(0xFFDDE8F2),
    lineStrong: Color(0xFFBCCDDB),
    stage: Color(0xFFEDF4FA),
    accent: Color(0xFF027DFD),
    accentStrong: Color(0xFF02569B),
    accentInk: Color(0xFF041A2B),
    accentSoft: Color(0xFFD9ECFF),
    success: Color(0xFF0E8A63),
    successSoft: Color(0xFFD8F2E8),
    matButtons: Color(0xFFD9ECFF),
    matInputs: Color(0xFFDDF3F8),
    matNavigation: Color(0xFFE9E3FF),
    matDisplay: Color(0xFFDDF1E6),
    matStates: Color(0xFFFFE7DC),
    contrast: Color(0xFF071A2B),
    onContrast: Color(0xFFF5FAFF),
    codeBg: Color(0xFF06131F),
    codeInk: Color(0xFFEAF3FB),
    shadow: Color(0xFF071A2B),
  );

  static const darkBase = FlubPalette(
    paper: Color(0xFF07121C),
    surface: Color(0xFF0C1B27),
    raised: Color(0xFF112433),
    ink: Color(0xFFEAF3FB),
    muted: Color(0xFF9FB0BF),
    faint: Color(0xFF6C8190),
    line: Color(0xFF1C3040),
    lineStrong: Color(0xFF2F4B60),
    stage: Color(0xFF0E1C29),
    accent: Color(0xFF54C5F8),
    accentStrong: Color(0xFF8ED8FF),
    accentInk: Color(0xFF041A2B),
    accentSoft: Color(0xFF103653),
    success: Color(0xFF6FD6AE),
    successSoft: Color(0xFF123A2C),
    matButtons: Color(0xFF0F2A44),
    matInputs: Color(0xFF0E3038),
    matNavigation: Color(0xFF201C3B),
    matDisplay: Color(0xFF11342A),
    matStates: Color(0xFF3A261D),
    contrast: Color(0xFF0F2231),
    onContrast: Color(0xFFEAF3FB),
    codeBg: Color(0xFF050D15),
    codeInk: Color(0xFFE7F0F9),
    shadow: Color(0xFF000000),
  );

  static FlubPalette forMode({
    required Brightness brightness,
    required AppAccent accent,
  }) {
    final base = brightness == Brightness.dark ? darkBase : lightBase;
    final colors = accent.colorsFor(brightness);
    return base.copyWith(
      accent: colors.primary,
      accentStrong: colors.strong,
      accentInk: colors.onPrimary,
      accentSoft: colors.soft,
    );
  }

  @override
  FlubPalette copyWith({
    Color? paper,
    Color? surface,
    Color? raised,
    Color? ink,
    Color? muted,
    Color? faint,
    Color? line,
    Color? lineStrong,
    Color? stage,
    Color? accent,
    Color? accentStrong,
    Color? accentInk,
    Color? accentSoft,
    Color? success,
    Color? successSoft,
    Color? matButtons,
    Color? matInputs,
    Color? matNavigation,
    Color? matDisplay,
    Color? matStates,
    Color? contrast,
    Color? onContrast,
    Color? codeBg,
    Color? codeInk,
    Color? shadow,
  }) {
    return FlubPalette(
      paper: paper ?? this.paper,
      surface: surface ?? this.surface,
      raised: raised ?? this.raised,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      faint: faint ?? this.faint,
      line: line ?? this.line,
      lineStrong: lineStrong ?? this.lineStrong,
      stage: stage ?? this.stage,
      accent: accent ?? this.accent,
      accentStrong: accentStrong ?? this.accentStrong,
      accentInk: accentInk ?? this.accentInk,
      accentSoft: accentSoft ?? this.accentSoft,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      matButtons: matButtons ?? this.matButtons,
      matInputs: matInputs ?? this.matInputs,
      matNavigation: matNavigation ?? this.matNavigation,
      matDisplay: matDisplay ?? this.matDisplay,
      matStates: matStates ?? this.matStates,
      contrast: contrast ?? this.contrast,
      onContrast: onContrast ?? this.onContrast,
      codeBg: codeBg ?? this.codeBg,
      codeInk: codeInk ?? this.codeInk,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  FlubPalette lerp(ThemeExtension<FlubPalette>? other, double t) {
    if (other is! FlubPalette) return this;
    return FlubPalette(
      paper: Color.lerp(paper, other.paper, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      raised: Color.lerp(raised, other.raised, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      faint: Color.lerp(faint, other.faint, t)!,
      line: Color.lerp(line, other.line, t)!,
      lineStrong: Color.lerp(lineStrong, other.lineStrong, t)!,
      stage: Color.lerp(stage, other.stage, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentStrong: Color.lerp(accentStrong, other.accentStrong, t)!,
      accentInk: Color.lerp(accentInk, other.accentInk, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
      matButtons: Color.lerp(matButtons, other.matButtons, t)!,
      matInputs: Color.lerp(matInputs, other.matInputs, t)!,
      matNavigation: Color.lerp(matNavigation, other.matNavigation, t)!,
      matDisplay: Color.lerp(matDisplay, other.matDisplay, t)!,
      matStates: Color.lerp(matStates, other.matStates, t)!,
      contrast: Color.lerp(contrast, other.contrast, t)!,
      onContrast: Color.lerp(onContrast, other.onContrast, t)!,
      codeBg: Color.lerp(codeBg, other.codeBg, t)!,
      codeInk: Color.lerp(codeInk, other.codeInk, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}
