import 'package:flubriry/models/app_accent.dart';
import 'package:flubriry/models/app_language.dart';
import 'package:flutter/material.dart';

/// The three persisted preferences. Everything else is view state.
@immutable
class AppSettingsState {
  const AppSettingsState({
    required this.language,
    required this.themeMode,
    required this.accent,
  });

  final AppLanguage language;
  final ThemeMode themeMode;
  final AppAccent accent;

  AppSettingsState copyWith({
    AppLanguage? language,
    ThemeMode? themeMode,
    AppAccent? accent,
  }) {
    return AppSettingsState(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      accent: accent ?? this.accent,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AppSettingsState &&
        other.language == language &&
        other.themeMode == themeMode &&
        other.accent == accent;
  }

  @override
  int get hashCode => Object.hash(language, themeMode, accent);
}
