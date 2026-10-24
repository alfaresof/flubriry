import 'package:flubriry/views/shared/app_context.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens an external link and leaves a quiet, themed note if the browser
/// refuses.
Future<void> openExternal(BuildContext context, String url) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  final errorText = context.strings.linkError;
  try {
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened) throw StateError('launchUrl returned false');
  } on Object {
    messenger?.showSnackBar(SnackBar(content: Text(errorText)));
  }
}
