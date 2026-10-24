import 'package:flubriry/models/app_language.dart';

/// A short string that travels with the catalogue in both languages.
class LocalizedText {
  const LocalizedText(this.en, this.ar);

  final String en;
  final String ar;

  String resolve(AppLanguage language) => language.isArabic ? ar : en;

  String resolveOther(AppLanguage language) => language.isArabic ? en : ar;
}
