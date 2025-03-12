import 'package:flutter/material.dart';

enum TextType { xs, sm, md, lg, xl, bold, italic }

class AppText extends StatelessWidget {
  final String text;
  final TextType type;
  final Color? color;
  final bool bold;
  final bool italic;

  const AppText({
    required this.text,
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
      case TextType.xs:
        return TextStyle(
          fontSize: 12,
          fontWeight: bold ? FontWeight.bold : null,
          fontStyle: italic ? FontStyle.italic : null,
        );
      case TextType.sm:
        return TextStyle(fontSize: 14,
          fontWeight: bold ? FontWeight.bold : null,
          fontStyle: italic ? FontStyle.italic : null,);
      case TextType.md:
        return TextStyle(fontSize: 16,
          fontWeight: bold ? FontWeight.bold : null,
          fontStyle: italic ? FontStyle.italic : null,);
      case TextType.lg:
        return TextStyle(fontSize: 18,
          fontWeight: bold ? FontWeight.bold : null,
          fontStyle: italic ? FontStyle.italic : null,);
      case TextType.xl:
        return const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
      case TextType.bold:
        return const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
      case TextType.italic:
        return const TextStyle(fontSize: 16, fontStyle: FontStyle.italic);
      default:
        return const TextStyle(fontSize: 16);
    }
  }
}
