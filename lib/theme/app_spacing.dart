import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
  static const section = 96.0;

  static const maxContentWidth = 1240.0;
}

double pageGutter(double width) {
  if (width < 600) return 20;
  if (width < 1000) return 32;
  return 48;
}

/// Keeps every section on the same invisible column.
class PageBounds extends StatelessWidget {
  const PageBounds({
    super.key,
    required this.child,
    this.maxWidth = AppSpacing.maxContentWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: pageGutter(MediaQuery.sizeOf(context).width),
          ),
          child: child,
        ),
      ),
    );
  }
}
