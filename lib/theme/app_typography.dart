import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Type rules for the catalogue.
///
/// The Latin display voice is Instrument Serif. Arabic keeps IBM Plex Sans
/// Arabic at a heavier weight, with no tracking that could disturb joining.
abstract final class AppType {
  static const latinDisplay = 'InstrumentSerif';
  static const sans = 'IBMPlexSansArabic';
  static const mono = 'IBMPlexMono';

  static TextStyle display(
    BuildContext context, {
    double size = 88,
    Color? color,
    double? height,
    bool italic = false,
    FontWeight? arabicWeight,
  }) {
    final palette = context.palette;
    final isArabic = context.isArabic;
    return TextStyle(
      fontFamily: isArabic ? sans : latinDisplay,
      fontFamilyFallback: const [sans],
      fontSize: size,
      height: height ?? (isArabic ? 1.32 : 0.98),
      letterSpacing: isArabic ? 0 : size * -0.022,
      fontWeight: isArabic
          ? (arabicWeight ?? FontWeight.w700)
          : FontWeight.w400,
      fontStyle: isArabic || !italic ? FontStyle.normal : FontStyle.italic,
      color: color ?? palette.ink,
    );
  }

  static TextStyle wordmark(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: latinDisplay,
      fontSize: 28,
      height: 1,
      letterSpacing: -0.7,
      color: color ?? context.palette.ink,
    );
  }

  static TextStyle body(
    BuildContext context, {
    double size = 15,
    Color? color,
    FontWeight weight = FontWeight.w400,
    double? height,
  }) {
    return TextStyle(
      fontFamily: sans,
      fontFamilyFallback: const [mono],
      fontSize: size,
      height: height ?? 1.65,
      fontWeight: weight,
      color: color ?? context.palette.ink,
    );
  }

  /// Small catalogue metadata. Arabic switches to the sans because Plex Mono
  /// has no Arabic coverage, and drops tracking so the script stays connected.
  static TextStyle meta(
    BuildContext context, {
    double size = 11,
    Color? color,
    FontWeight weight = FontWeight.w500,
  }) {
    final isArabic = context.isArabic;
    return TextStyle(
      fontFamily: isArabic ? sans : mono,
      fontFamilyFallback: const [sans],
      fontSize: size,
      height: 1.3,
      letterSpacing: isArabic ? 0 : 0.8,
      fontWeight: weight,
      color: color ?? context.palette.muted,
    );
  }

  static TextStyle monoStyle(
    BuildContext context, {
    double size = 12,
    Color? color,
    FontWeight weight = FontWeight.w400,
    double? height,
  }) {
    return TextStyle(
      fontFamily: mono,
      fontFamilyFallback: const [sans],
      fontSize: size,
      height: height ?? 1.6,
      letterSpacing: 0,
      fontWeight: weight,
      color: color ?? context.palette.codeInk,
    );
  }

  static TextStyle codeStyle(
    FlubPalette palette, {
    double size = 13,
    Color? color,
    FontWeight weight = FontWeight.w400,
    double height = 1.65,
  }) {
    return TextStyle(
      fontFamily: mono,
      fontSize: size,
      height: height,
      letterSpacing: 0,
      fontWeight: weight,
      color: color ?? palette.codeInk,
    );
  }

  /// Latin labels get the catalogue's small-caps feel; Arabic never does.
  static String label(BuildContext context, String text) =>
      context.isArabic ? text : text.toUpperCase();
}
