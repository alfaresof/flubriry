import 'package:flubriry/models/app_language.dart';
import 'package:flubriry/services/app_strings.dart';
import 'package:flutter/widgets.dart';

/// The localization slice of the app state, exposed once at the root so any
/// leaf view can read its copy without carrying a Riverpod ref.
class AppConfig extends InheritedWidget {
  const AppConfig({
    super.key,
    required this.language,
    required this.strings,
    required super.child,
  });

  final AppLanguage language;
  final AppStrings strings;

  static AppConfig of(BuildContext context) {
    final config = context.dependOnInheritedWidgetOfExactType<AppConfig>();
    assert(config != null, 'AppConfig was not found above this context.');
    return config!;
  }

  @override
  bool updateShouldNotify(AppConfig oldWidget) {
    return oldWidget.language != language;
  }
}
