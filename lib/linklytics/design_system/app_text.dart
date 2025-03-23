import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_sizes.dart';

enum TextType { xxs, xs, sm, md, lg, xl, xxl, bold, italic }

class AppText extends StatelessWidget {
  final String text;
  final TextType type;
  final Color? color;
  final bool bold;
  final bool italic;

  const AppText(
    this.text, {
    required this.type,
    this.bold = false,
    this.italic = false,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final style = _getTextStyle(type, bold, italic);
    return Text(
      text,
      style: style.copyWith(color: color ?? Colors.black),
    );
  }

  TextStyle _getTextStyle(TextType type, bool bold, bool italic) {
    switch (type) {
      case TextType.xxs:
        return _getStyle(AppSizes.txtXxs, bold, italic);
      case TextType.xs:
        return _getStyle(AppSizes.txtXs, bold, italic);
      case TextType.sm:
        return _getStyle(AppSizes.txtSm, bold, italic);
      case TextType.md:
        return _getStyle(AppSizes.txtMd, bold, italic);
      case TextType.lg:
        return _getStyle(AppSizes.txtLg, bold, italic);
      case TextType.xl:
        return const TextStyle(fontSize: AppSizes.txtXl, fontWeight: FontWeight.bold);
      case TextType.xxl:
        return const TextStyle(
            fontSize: AppSizes.txtXxxl, fontWeight: FontWeight.bold);
      case TextType.bold:
        return const TextStyle(fontSize: AppSizes.txtMd, fontWeight: FontWeight.bold);
      case TextType.italic:
        return const TextStyle(fontSize: AppSizes.txtMd, fontStyle: FontStyle.italic);
      }
  }

  TextStyle _getStyle(double size, bool isBold, bool isItalic) {
    return TextStyle(
      fontSize: size,
      fontWeight: isBold ? FontWeight.bold : null,
      fontStyle: isItalic ? FontStyle.italic : null,
    );
  }
}
