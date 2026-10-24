import 'dart:ui' show Locale;

/// The two languages the catalogue ships in.
enum AppLanguage {
  english('en'),
  arabic('ar');

  const AppLanguage(this.code);

  final String code;

  bool get isArabic => this == AppLanguage.arabic;

  Locale get locale => Locale(code);

  static AppLanguage fromCode(String? code) {
    return code == 'ar' ? AppLanguage.arabic : AppLanguage.english;
  }
}
