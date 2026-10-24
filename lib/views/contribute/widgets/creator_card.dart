import 'package:flubriry/theme/app_typography.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/views/shared/social_accounts.dart';
import 'package:flutter/material.dart';

class CreatorCard extends StatelessWidget {
  const CreatorCard({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final strings = context.strings;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppType.label(context, strings.creatorEyebrow),
            style: AppType.meta(context, size: 9.5, color: palette.muted),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              ExcludeSemantics(
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: palette.line),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/images/creator.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.creatorName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: palette.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      strings.creatorHandle,
                      textDirection: TextDirection.ltr,
                      style: AppType.meta(
                        context,
                        size: 11,
                        color: palette.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            strings.creatorBio,
            style: theme.textTheme.bodySmall?.copyWith(
              color: palette.muted,
              fontSize: 12.5,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            AppType.label(context, strings.accountsLabel),
            style: AppType.meta(context, size: 9, color: palette.muted),
          ),
          const SizedBox(height: 8),
          const SocialAccounts(
            showHandle: false,
            showLabels: true,
            compact: false,
          ),
        ],
      ),
    );
  }
}
