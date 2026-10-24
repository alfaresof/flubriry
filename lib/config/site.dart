abstract final class Site {
  static const owner = 'alfaresof';
  static const repo = 'flubriry';
  static const repoUrl = 'https://github.com/$owner/$repo';
  static const githubProfileUrl = 'https://github.com/$owner';
  static const xUrl = 'https://x.com/$owner';
  static const ownerAvatar = 'assets/images/creator.jpg';
  static const newComponentUrl = '$repoUrl/new/main/lib/components';
  static const templateUrl = '$repoUrl/blob/main/lib/components/_template.dart';
  static const pullsUrl = '$repoUrl/pulls';
  static const licenseUrl = '$repoUrl/blob/main/LICENSE';
  static const generatorCommand = 'dart run tool/generate_registry.dart';

  /// Drop the final mark in `assets/brand/` and point this at it.
  /// SVG and PNG are both supported. Leave null to use the drawn `f` mark.
  // ignore: unnecessary_nullable_for_final_variable_declarations
  static const String? logoAsset = 'assets/brand/logo.svg';

  static String sourceUrl(String path) => '$repoUrl/blob/main/$path';
}
