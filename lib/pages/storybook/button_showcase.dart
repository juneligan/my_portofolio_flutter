import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_button.dart';

class ButtonShowcase extends ConsumerWidget {
  const ButtonShowcase({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Button Showcase")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Primary Button", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppButton('Primary', onPressed: () {}, type: ButtonType.primary),
            const SizedBox(height: 10),

            const Text("Secondary Button", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppButton('Secondary', onPressed: () {}, type: ButtonType.secondary),
            const SizedBox(height: 10),

            const Text("Tertiary Button (Outlined)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppButton('Tertiary', onPressed: () {}, type: ButtonType.tertiary, isOutlined: true),
            const SizedBox(height: 10),

            const Text("Warning Button", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppButton( 'Warning', onPressed: () {}, type: ButtonType.warning),
            const SizedBox(height: 10),

            const Text("Error Button", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppButton( 'Error', onPressed: () {}, type: ButtonType.error),
            const SizedBox(height: 10),

            const Text("Disabled Button", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppButton('Disabled', onPressed: () {}, isDisabled: true),
          ],
        ),
      ),
    );
  }
}
