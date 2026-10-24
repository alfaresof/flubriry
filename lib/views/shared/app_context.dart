import 'package:flubriry/models/app_accent.dart';
import 'package:flubriry/models/app_language.dart';
import 'package:flubriry/services/app_strings.dart';
import 'package:flubriry/theme/app_colors.dart';
import 'package:flubriry/views/shared/app_config.dart';
import 'package:flutter/material.dart';

extension AppContextX on BuildContext {
  AppLanguage get language => AppConfig.of(this).language;

  AppStrings get strings => AppConfig.of(this).strings;

  FlubPalette get palette {
    final theme = Theme.of(this);
    return theme.extension<FlubPalette>() ??
        FlubPalette.forMode(
          brightness: theme.brightness,
          accent: AppAccent.flutter,
        );
  }

  bool get isArabic => language.isArabic;

  bool get isDesktop => MediaQuery.sizeOf(this).width >= 900;
}
