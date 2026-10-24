import 'package:flutter/material.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flubriry/models/component_category.dart';
import 'package:flubriry/models/component_meta.dart';
import 'package:flubriry/models/localized_text.dart';

// <flubriry:code>
/// A confirmation bar with one clear next step.
class SoftToast extends StatelessWidget {
  const SoftToast({
    super.key,
    required this.message,
    this.icon = Icons.check_rounded,
    this.actionLabel,
    this.onAction,
    this.maxWidth = 380,
  });

  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Semantics(
      container: true,
      liveRegion: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: colors.onSurface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.22),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: colors.onPrimary),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.surface,
                    fontSize: 13.5,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (actionLabel != null)
                Material(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(9),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onAction,
                    borderRadius: BorderRadius.circular(9),
                    focusColor: colors.onPrimary.withValues(alpha: 0.25),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Text(
                        actionLabel!,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colors.onPrimary,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
// </flubriry:code>

final ComponentMeta componentMeta = ComponentMeta(
  id: 'soft-toast',
  order: 100,
  category: ComponentCategory.states,
  name: const LocalizedText('Soft Toast', 'تنبيه ناعم'),
  description: const LocalizedText(
    'A confirmation bar with one clear next step. Dark on paper, cream in the dark, and never wider than it needs to be.',
    'شريط تأكيد بخطوة واحدة واضحة. داكن على الورق، فاتح في الوضع الداكن، ولا يتّسع أكثر من حاجته.',
  ),
  tags: const [
    'toast',
    'snackbar',
    'feedback',
    'confirmation',
    'undo',
    'تنبيه',
    'تأكيد',
    'تراجع',
  ],
  origin: 'Qafelah',
  preview: (context) => const _ToastPreview(),
);

class _ToastPreview extends StatefulWidget {
  const _ToastPreview();

  @override
  State<_ToastPreview> createState() => _ToastPreviewState();
}

class _ToastPreviewState extends State<_ToastPreview> {
  bool _visible = true;
  int _round = 0;

  void _show() {
    setState(() {
      _visible = true;
      _round++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final theme = Theme.of(context);
    return SizedBox(
      width: 314,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 58,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.18),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _visible
                  ? SoftToast(
                      key: ValueKey<int>(_round),
                      message: strings.demoToastMessage,
                      actionLabel: strings.demoUndo,
                      onAction: () => setState(() => _visible = false),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _show,
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.onSurface.withValues(
                alpha: 0.82,
              ),
              textStyle: theme.textTheme.labelMedium,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: const StadiumBorder(),
            ),
            child: Text(strings.demoToastReplay),
          ),
        ],
      ),
    );
  }
}
