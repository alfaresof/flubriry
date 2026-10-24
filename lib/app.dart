import 'package:flubriry/controllers/app_settings_controller.dart';
import 'package:flubriry/services/document_metadata.dart';
import 'package:flubriry/theme/app_theme.dart';
import 'package:flubriry/router.dart';
import 'package:flubriry/views/shared/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlubriryApp extends ConsumerStatefulWidget {
  const FlubriryApp({super.key});

  @override
  ConsumerState<FlubriryApp> createState() => _FlubriryAppState();
}

class _FlubriryAppState extends ConsumerState<FlubriryApp> {
  late final _router = createRouter();

  @override
  void initState() {
    super.initState();
    updateDocumentLanguage(ref.read(appLanguageProvider));
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    final strings = ref.watch(appStringsProvider);

    ref.listen(appLanguageProvider, (previous, next) {
      updateDocumentLanguage(next);
    });

    return AppConfig(
      language: settings.language,
      strings: strings,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'flubriry',
        locale: settings.language.locale,
        supportedLocales: const [Locale('en'), Locale('ar')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        theme: AppTheme.build(
          brightness: Brightness.light,
          language: settings.language,
          accent: settings.accent,
        ),
        darkTheme: AppTheme.build(
          brightness: Brightness.dark,
          language: settings.language,
          accent: settings.accent,
        ),
        themeMode: settings.themeMode,
        themeAnimationDuration: const Duration(milliseconds: 280),
        themeAnimationCurve: Curves.easeOutCubic,
        routerConfig: _router,
      ),
    );
  }
}
