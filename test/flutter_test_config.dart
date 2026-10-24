import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Widget tests use the real families so width and wrapping checks reflect
/// the shipped page instead of the square Ahem test font.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await _loadFonts();
  await testMain();
}

Future<void> _loadFonts() async {
  final sans = FontLoader('IBMPlexSansArabic')
    ..addFont(
      rootBundle.load(
        'assets/fonts/ibm-plex-sans-arabic/IBMPlexSansArabic-Regular.ttf',
      ),
    )
    ..addFont(
      rootBundle.load(
        'assets/fonts/ibm-plex-sans-arabic/IBMPlexSansArabic-Medium.ttf',
      ),
    )
    ..addFont(
      rootBundle.load(
        'assets/fonts/ibm-plex-sans-arabic/IBMPlexSansArabic-SemiBold.ttf',
      ),
    )
    ..addFont(
      rootBundle.load(
        'assets/fonts/ibm-plex-sans-arabic/IBMPlexSansArabic-Bold.ttf',
      ),
    );
  final serif = FontLoader('InstrumentSerif')
    ..addFont(
      rootBundle.load(
        'assets/fonts/instrument-serif/InstrumentSerif-Regular.ttf',
      ),
    )
    ..addFont(
      rootBundle.load(
        'assets/fonts/instrument-serif/InstrumentSerif-Italic.ttf',
      ),
    );
  final mono = FontLoader('IBMPlexMono')
    ..addFont(
      rootBundle.load('assets/fonts/ibm-plex-mono/IBMPlexMono-Regular.ttf'),
    )
    ..addFont(
      rootBundle.load('assets/fonts/ibm-plex-mono/IBMPlexMono-Medium.ttf'),
    );
  await Future.wait([sans.load(), serif.load(), mono.load()]);
}
