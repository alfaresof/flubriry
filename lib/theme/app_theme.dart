import 'package:flubriry/models/app_accent.dart';
import 'package:flubriry/models/app_language.dart';
import 'package:flubriry/theme/app_colors.dart';
import 'package:flubriry/theme/app_typography.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData build({
    required Brightness brightness,
    required AppLanguage language,
    required AppAccent accent,
  }) {
    final palette = FlubPalette.forMode(brightness: brightness, accent: accent);
    final isArabic = language.isArabic;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: palette.accent,
      onPrimary: palette.accentInk,
      primaryContainer: palette.accentSoft,
      onPrimaryContainer: palette.ink,
      secondary: palette.ink,
      onSecondary: palette.paper,
      secondaryContainer: palette.raised,
      onSecondaryContainer: palette.ink,
      error: brightness == Brightness.light
          ? const Color(0xFFC74838)
          : const Color(0xFFFF8A7A),
      onError: brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF2A0904),
      surface: palette.surface,
      onSurface: palette.ink,
      surfaceContainerHighest: palette.raised,
      outline: palette.lineStrong,
      outlineVariant: palette.line,
      shadow: palette.shadow,
      scrim: palette.shadow,
      inverseSurface: palette.ink,
      onInverseSurface: palette.paper,
      inversePrimary: palette.accent,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
    ).textTheme;
    final textTheme = base
        .apply(
          fontFamily: AppType.sans,
          bodyColor: palette.ink,
          displayColor: palette.ink,
        )
        .copyWith(
          displayLarge: TextStyle(
            fontFamily: isArabic ? AppType.sans : AppType.latinDisplay,
            fontFamilyFallback: const [AppType.sans],
            fontSize: isArabic ? 54 : 82,
            height: isArabic ? 1.28 : 0.98,
            letterSpacing: isArabic ? 0 : -1.7,
            fontWeight: isArabic ? FontWeight.w700 : FontWeight.w400,
            color: palette.ink,
          ),
          displayMedium: TextStyle(
            fontFamily: isArabic ? AppType.sans : AppType.latinDisplay,
            fontFamilyFallback: const [AppType.sans],
            fontSize: isArabic ? 42 : 58,
            height: isArabic ? 1.3 : 1,
            letterSpacing: isArabic ? 0 : -1.2,
            fontWeight: isArabic ? FontWeight.w700 : FontWeight.w400,
            color: palette.ink,
          ),
          headlineLarge: TextStyle(
            fontFamily: AppType.sans,
            fontSize: isArabic ? 28 : 30,
            height: isArabic ? 1.4 : 1.2,
            fontWeight: FontWeight.w700,
            color: palette.ink,
          ),
          headlineMedium: TextStyle(
            fontFamily: AppType.sans,
            fontSize: isArabic ? 23 : 24,
            height: isArabic ? 1.45 : 1.25,
            fontWeight: FontWeight.w600,
            color: palette.ink,
          ),
          titleLarge: TextStyle(
            fontFamily: AppType.sans,
            fontSize: 20,
            height: isArabic ? 1.45 : 1.3,
            fontWeight: FontWeight.w600,
            color: palette.ink,
          ),
          titleMedium: TextStyle(
            fontFamily: AppType.sans,
            fontSize: 16,
            height: isArabic ? 1.5 : 1.35,
            fontWeight: FontWeight.w600,
            color: palette.ink,
          ),
          titleSmall: TextStyle(
            fontFamily: AppType.sans,
            fontSize: 14,
            height: isArabic ? 1.5 : 1.35,
            fontWeight: FontWeight.w600,
            color: palette.ink,
          ),
          bodyLarge: TextStyle(
            fontFamily: AppType.sans,
            fontSize: 16,
            height: 1.7,
            fontWeight: FontWeight.w400,
            color: palette.ink,
          ),
          bodyMedium: TextStyle(
            fontFamily: AppType.sans,
            fontSize: 14.5,
            height: 1.65,
            fontWeight: FontWeight.w400,
            color: palette.ink,
          ),
          bodySmall: TextStyle(
            fontFamily: AppType.sans,
            fontSize: 12.5,
            height: 1.55,
            fontWeight: FontWeight.w400,
            color: palette.muted,
          ),
          labelLarge: TextStyle(
            fontFamily: AppType.sans,
            fontSize: 13,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: palette.ink,
          ),
          labelMedium: TextStyle(
            fontFamily: AppType.sans,
            fontSize: 12,
            height: 1.2,
            fontWeight: FontWeight.w500,
            color: palette.ink,
          ),
          labelSmall: TextStyle(
            fontFamily: AppType.sans,
            fontSize: 11,
            height: 1.2,
            letterSpacing: isArabic ? 0 : 0.4,
            fontWeight: FontWeight.w500,
            color: palette.muted,
          ),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: palette.paper,
      canvasColor: palette.paper,
      cardColor: palette.surface,
      dividerColor: palette.line,
      fontFamily: AppType.sans,
      textTheme: textTheme,
      primaryTextTheme: textTheme.apply(
        bodyColor: palette.onContrast,
        displayColor: palette.onContrast,
      ),
      iconTheme: IconThemeData(color: palette.ink, size: 20),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: palette.ink.withValues(alpha: 0.045),
      focusColor: palette.accent.withValues(alpha: 0.26),
      disabledColor: palette.muted.withValues(alpha: 0.55),
      unselectedWidgetColor: palette.muted,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: palette.accentStrong,
        selectionColor: palette.accent.withValues(alpha: 0.32),
        selectionHandleColor: palette.accentStrong,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: palette.ink,
          borderRadius: BorderRadius.circular(7),
        ),
        textStyle: TextStyle(
          fontFamily: AppType.sans,
          fontSize: 12,
          height: 1.4,
          fontWeight: FontWeight.w500,
          color: palette.paper,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        waitDuration: const Duration(milliseconds: 450),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          fontFamily: AppType.sans,
          color: palette.muted,
          fontSize: 14,
        ),
        border: InputBorder.none,
        isDense: true,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thickness: WidgetStateProperty.all(8),
        radius: const Radius.circular(4),
        thumbColor: WidgetStateProperty.all(
          palette.muted.withValues(alpha: 0.35),
        ),
        crossAxisMargin: 4,
        mainAxisMargin: 4,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: palette.line),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: palette.ink,
        contentTextStyle: TextStyle(
          fontFamily: AppType.sans,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: palette.paper,
        ),
        actionTextColor: palette.accent,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: const EdgeInsets.all(16),
      ),
      extensions: [palette],
    );
  }
}
