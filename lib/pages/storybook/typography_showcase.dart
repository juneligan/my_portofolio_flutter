import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text.dart';

class TypographyShowcase extends ConsumerWidget {
  const TypographyShowcase({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Typography Showcase")),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(text: "Extra Small Text", type: TextType.xs),
            SizedBox(height: 5),
            AppText(text: "Small Text", type: TextType.sm),
            SizedBox(height: 5),
            AppText(text: "Medium Text", type: TextType.md),
            SizedBox(height: 5),
            AppText(text: "Large Text", type: TextType.lg),
            SizedBox(height: 5),
            AppText(text: "Extra Large Text", type: TextType.xl),
            SizedBox(height: 5),
            AppText(text: "Bold Text", type: TextType.bold),
            SizedBox(height: 5),
            AppText(text: "Italic Text", type: TextType.italic),
          ],
        ),
      ),
    );
  }
}
