import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:flubriry/models/app_accent.dart';
import 'package:flubriry/models/app_language.dart';
import 'package:flubriry/models/app_settings_state.dart';
import 'package:flubriry/services/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Overridden once in `main` (and in tests) with a real instance.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden with SharedPreferences.',
  );
});

final appSettingsProvider =
    NotifierProvider<AppSettingsController, AppSettingsState>(
      AppSettingsController.new,
      name: 'appSettings',
    );

final appLanguageProvider = Provider<AppLanguage>((ref) {
  return ref.watch(appSettingsProvider.select((settings) => settings.language));
});

final appStringsProvider = Provider<AppStrings>((ref) {
  return AppStrings(ref.watch(appLanguageProvider));
});

class AppSettingsController extends Notifier<AppSettingsState> {
  static const _languageKey = 'flubriry.language';
  static const _themeKey = 'flubriry.theme';
  static const _accentKey = 'flubriry.accent';

  @override
  AppSettingsState build() {
    final preferences = ref.watch(sharedPreferencesProvider);
    final deviceLanguage =
        PlatformDispatcher.instance.locale.languageCode == 'ar'
        ? AppLanguage.arabic
        : AppLanguage.english;
    final storedTheme = preferences.getString(_themeKey);

    return AppSettingsState(
      language: AppLanguage.fromCode(
        preferences.getString(_languageKey) ?? deviceLanguage.code,
      ),
      themeMode: switch (storedTheme) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      },
      accent: AppAccent.fromId(preferences.getString(_accentKey)),
    );
  }

  SharedPreferences get _preferences => ref.read(sharedPreferencesProvider);

  void setLanguage(AppLanguage language) {
    if (language == state.language) return;
    state = state.copyWith(language: language);
    unawaited(_preferences.setString(_languageKey, language.code));
  }

  void setThemeMode(ThemeMode mode) {
    if (mode == state.themeMode) return;
    state = state.copyWith(themeMode: mode);
    unawaited(
      _preferences.setString(_themeKey, switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      }),
    );
  }

  void setAccent(AppAccent accent) {
    if (accent == state.accent) return;
    state = state.copyWith(accent: accent);
    unawaited(_preferences.setString(_accentKey, accent.id));
  }
}
