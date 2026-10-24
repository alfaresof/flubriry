import 'package:figma_squircle/figma_squircle.dart';
import 'package:flubriry/config/site.dart';
import 'package:flubriry/theme/app_typography.dart';
import 'package:flubriry/views/shared/app_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.onTap, this.compact = false});

  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final markSize = compact ? 26.0 : 30.0;
    final logoAsset = Site.logoAsset;

    final Widget mark;
    if (logoAsset == null) {
      mark = Container(
        width: markSize,
        height: markSize,
        decoration: ShapeDecoration(
          color: palette.accent,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: markSize * 0.3,
              cornerSmoothing: 0.62,
            ),
          ),
        ),
        child: Center(
          child: Transform.translate(
            offset: const Offset(0, -1),
            child: Text(
              'f',
              style: TextStyle(
                fontFamily: AppType.latinDisplay,
                fontStyle: FontStyle.italic,
                fontSize: markSize * 0.76,
                height: 1,
                color: palette.accentInk,
              ),
            ),
          ),
        ),
      );
    } else {
      mark = SizedBox(
        width: markSize,
        height: markSize,
        child: logoAsset.endsWith('.svg')
            ? SvgPicture.asset(logoAsset, fit: BoxFit.contain)
            : Image.asset(logoAsset, fit: BoxFit.contain),
      );
    }

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        SizedBox(width: compact ? 7 : 9),
        Text(
          'flubriry',
          style: AppType.wordmark(context)
              .copyWith(fontSize: compact ? 24 : 28),
        ),
      ],
    );

    if (onTap == null) return content;

    return Semantics(
      button: true,
      label: 'flubriry',
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          focusColor: palette.accent.withValues(alpha: 0.24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
            child: content,
          ),
        ),
      ),
    );
  }
}
