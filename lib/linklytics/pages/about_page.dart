import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: AppText(
      'This is the About Page',
      type: TextType.xl,
    ));
  }
}
