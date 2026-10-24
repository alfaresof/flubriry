import 'package:flubriry/app.dart';
import 'package:flubriry/controllers/app_settings_controller.dart';
import 'package:flubriry/models/app_accent.dart';
import 'package:flubriry/models/app_language.dart';
import 'package:flubriry/models/component_catalog.dart';
import 'package:flubriry/views/shared/appearance_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> pumpCatalogue(
  WidgetTester tester, {
  Size size = const Size(1440, 1000),
  AppLanguage language = AppLanguage.english,
  AppAccent accent = AppAccent.flutter,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  SharedPreferences.setMockInitialValues({
    'flubriry.language': language.code,
    'flubriry.accent': accent.id,
  });
  final preferences = await SharedPreferences.getInstance();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      child: const FlubriryApp(),
    ),
  );
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();

  return ProviderScope.containerOf(tester.element(find.byType(FlubriryApp)));
}

void main() {
  testWidgets('searches, clears, and copies from the shelf', (tester) async {
    String? clipboard;
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') {
        clipboard =
            (call.arguments as Map<Object?, Object?>)['text'] as String?;
        return null;
      }
      if (call.method == 'Clipboard.getData') {
        return <String, Object?>{'text': clipboard};
      }
      return null;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );

    await pumpCatalogue(tester);
    expect(find.text('Stand out with components'), findsOneWidget);
    expect(find.byType(SelectionArea), findsNothing);
    expect(find.text('Field Note'), findsOneWidget);
    expect(find.text('Tandem Button'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('catalogue-search')));
    await tester.enterText(
      find.byKey(const ValueKey('catalogue-search')),
      'field',
    );
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.text('Field Note'), findsOneWidget);
    expect(find.text('Tandem Button'), findsNothing);
    expect(find.textContaining('SHOWING 1'), findsOneWidget);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Tandem Button'), findsOneWidget);

    final copy = find.byKey(const ValueKey('copy-squircle-button'));
    await tester.ensureVisible(copy);
    await tester.pumpAndSettle();
    await tester.tap(copy);
    await tester.pump();

    expect(find.text('Copied'), findsOneWidget);
    expect(clipboard, ComponentCatalog.byId('squircle-button')!.code);
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('pages through the catalogue and opens a component', (
    tester,
  ) async {
    await pumpCatalogue(tester);

    expect(find.text('Segment Switch'), findsNothing);

    final pageTwo = find.byKey(const ValueKey('page-2'));
    await tester.ensureVisible(pageTwo);
    await tester.pumpAndSettle();
    await tester.tap(pageTwo);
    await tester.pumpAndSettle();

    expect(find.text('Segment Switch'), findsOneWidget);
    expect(find.text('Crew Row'), findsNothing);

    final pageThree = find.byKey(const ValueKey('page-3'));
    await tester.ensureVisible(pageThree);
    await tester.pumpAndSettle();
    await tester.tap(pageThree);
    await tester.pumpAndSettle();
    expect(find.text('Crew Row'), findsOneWidget);

    final pageOne = find.byKey(const ValueKey('page-1'));
    await tester.ensureVisible(pageOne);
    await tester.pumpAndSettle();
    await tester.tap(pageOne);
    await tester.pumpAndSettle();

    final open = find.byKey(const ValueKey('open-squircle-button'));
    await tester.ensureVisible(open);
    await tester.pumpAndSettle();
    await tester.tap(open);
    await tester.pumpAndSettle();

    expect(find.text('Copy code'), findsOneWidget);
    expect(find.byType(SelectionArea), findsOneWidget);
    expect(
      find.ancestor(
        of: find.text('Copy code'),
        matching: find.byType(SelectionArea),
      ),
      findsNothing,
    );
    expect(find.text('squircle_button.dart'), findsWidgets);
    expect(find.text('NEXT COMPONENT'), findsOneWidget);
    expect(find.text('PREVIOUS COMPONENT'), findsOneWidget);

    await tester.tap(find.text('All components'));
    await tester.pumpAndSettle();
    expect(find.text('Copy code'), findsNothing);
    expect(find.byKey(const ValueKey('open-squircle-button')), findsOneWidget);
  });

  testWidgets('interactive previews do not open the detail page', (
    tester,
  ) async {
    await pumpCatalogue(tester);

    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(2));
    await tester.ensureVisible(fields.last);
    await tester.pumpAndSettle();
    await tester.tap(fields.last);
    await tester.pumpAndSettle();

    expect(find.text('Copy code'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('appearance dialog changes theme and accent for the app', (
    tester,
  ) async {
    await pumpCatalogue(tester);

    await tester.tap(find.byTooltip('Appearance'));
    await tester.pumpAndSettle();
    expect(find.text('Appearance'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('accent-sky')));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(AppearanceDialog)))
          .colorScheme
          .primary,
      AppAccent.sky.light.primary,
    );

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(AppearanceDialog))).brightness,
      Brightness.dark,
    );

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Stand out with components')))
          .brightness,
      Brightness.dark,
    );
  });

  testWidgets('opens the full contribute page from the navbar', (tester) async {
    await pumpCatalogue(tester);

    await tester.tap(find.text('Contribute'));
    await tester.pumpAndSettle();

    expect(
      find.text('Contribute with us and add your components.'),
      findsOneWidget,
    );
    expect(find.text('HOW IT WORKS'), findsOneWidget);
    await tester.drag(
      find.byType(CustomScrollView).last,
      const Offset(0, -1500),
    );
    await tester.pumpAndSettle();
    expect(find.text('@alfaresof'), findsWidgets);
    expect(find.text('Open a pull request'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('switches language and theme on a phone', (tester) async {
    await pumpCatalogue(
      tester,
      size: const Size(390, 844),
      language: AppLanguage.arabic,
    );

    expect(find.text('تفرّد بمكونات'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('تفرّد بمكونات'))),
      TextDirection.rtl,
    );

    await tester.tap(find.byTooltip('المظهر'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(find.text('Stand out with components'), findsOneWidget);
    expect(find.byType(SelectionArea), findsNothing);
    expect(
      Directionality.of(tester.element(find.text('Stand out with components'))),
      TextDirection.ltr,
    );

    await tester.tap(find.byTooltip('Appearance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Stand out with components')))
          .brightness,
      Brightness.dark,
    );
    expect(tester.takeException(), isNull);
  });
}
