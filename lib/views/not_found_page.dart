import 'package:flubriry/theme/app_typography.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/views/shared/brand_mark.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strings = context.strings;

    return Title(
      title: strings.notFoundTitle,
      color: palette.accent,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const BrandMark(),
                  const SizedBox(height: 28),
                  Text(
                    strings.notFoundTitle,
                    textAlign: TextAlign.center,
                    style: AppType.display(
                      context,
                      size: context.isArabic ? 32 : 42,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    strings.notFoundBody,
                    textAlign: TextAlign.center,
                    style: AppType.body(
                      context,
                      size: 14.5,
                      color: palette.muted,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => context.go('/'),
                    style: FilledButton.styleFrom(
                      backgroundColor: palette.ink,
                      foregroundColor: palette.paper,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: Text(strings.goHome),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
