import 'dart:ui' show Brightness, Color;

import 'localized_text.dart';

class AccentColors {
  const AccentColors({
    required this.primary,
    required this.onPrimary,
    required this.strong,
    required this.soft,
  });

  final Color primary;
  final Color onPrimary;
  final Color strong;
  final Color soft;
}

/// The curated accent palette. The first option is Flutter blue; switching
/// one updates the whole catalogue because every component reads the theme.
enum AppAccent {
  flutter(
    'flutter',
    LocalizedText('Flutter blue', 'أزرق فلاتر'),
    AccentColors(
      primary: Color(0xFF027DFD),
      onPrimary: Color(0xFF041A2B),
      strong: Color(0xFF02569B),
      soft: Color(0xFFD9ECFF),
    ),
    AccentColors(
      primary: Color(0xFF54C5F8),
      onPrimary: Color(0xFF041A2B),
      strong: Color(0xFF8ED8FF),
      soft: Color(0xFF103653),
    ),
  ),
  sky(
    'sky',
    LocalizedText('Flutter sky', 'سماوي فلاتر'),
    AccentColors(
      primary: Color(0xFF13B9FD),
      onPrimary: Color(0xFF041A2B),
      strong: Color(0xFF00738C),
      soft: Color(0xFFD3F4FA),
    ),
    AccentColors(
      primary: Color(0xFF54E0F0),
      onPrimary: Color(0xFF041A2B),
      strong: Color(0xFF9CF1FA),
      soft: Color(0xFF123E45),
    ),
  ),
  violet(
    'violet',
    LocalizedText('Violet', 'بنفسجي'),
    AccentColors(
      primary: Color(0xFF6C4BFF),
      onPrimary: Color(0xFFFFFFFF),
      strong: Color(0xFF4A2FD1),
      soft: Color(0xFFE8E2FF),
    ),
    AccentColors(
      primary: Color(0xFFA99CFF),
      onPrimary: Color(0xFF17103A),
      strong: Color(0xFFC9C0FF),
      soft: Color(0xFF241F4A),
    ),
  ),
  mint(
    'mint',
    LocalizedText('Mint', 'نعناعي'),
    AccentColors(
      primary: Color(0xFF00A879),
      onPrimary: Color(0xFF04281E),
      strong: Color(0xFF007653),
      soft: Color(0xFFD9F4E9),
    ),
    AccentColors(
      primary: Color(0xFF5AD6AE),
      onPrimary: Color(0xFF04281E),
      strong: Color(0xFF8BE6C6),
      soft: Color(0xFF103A2C),
    ),
  ),
  amber(
    'amber',
    LocalizedText('Amber', 'كهرماني'),
    AccentColors(
      primary: Color(0xFFF6B62C),
      onPrimary: Color(0xFF241700),
      strong: Color(0xFF8B5B00),
      soft: Color(0xFFF8E3B8),
    ),
    AccentColors(
      primary: Color(0xFFFFC24B),
      onPrimary: Color(0xFF241700),
      strong: Color(0xFFFFD37A),
      soft: Color(0xFF3A2D18),
    ),
  ),
  rose(
    'rose',
    LocalizedText('Rose', 'وردي'),
    AccentColors(
      primary: Color(0xFFD62F5D),
      onPrimary: Color(0xFFFFFFFF),
      strong: Color(0xFFA30B3D),
      soft: Color(0xFFFFE0E8),
    ),
    AccentColors(
      primary: Color(0xFFFF8FAE),
      onPrimary: Color(0xFF3A0B1B),
      strong: Color(0xFFFFB3C7),
      soft: Color(0xFF3E1C28),
    ),
  );

  const AppAccent(this.id, this.name, this.light, this.dark);

  final String id;
  final LocalizedText name;
  final AccentColors light;
  final AccentColors dark;

  AccentColors colorsFor(Brightness brightness) {
    return brightness == Brightness.dark ? dark : light;
  }

  static AppAccent fromId(String? id) {
    for (final accent in values) {
      if (accent.id == id) return accent;
    }
    return AppAccent.flutter;
  }
}
