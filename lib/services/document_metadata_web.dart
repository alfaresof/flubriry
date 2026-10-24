import 'package:flubriry/models/app_language.dart';
import 'package:web/web.dart' as web;

void updateDocumentLanguage(AppLanguage language) {
  final root = web.document.documentElement;
  root
    ?..setAttribute('lang', language.code)
    ..setAttribute('dir', language.isArabic ? 'rtl' : 'ltr');
}
