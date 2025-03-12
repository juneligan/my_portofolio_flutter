import 'package:flutter/material.dart';

import 'app_sizes.dart';

class AppTextStyles {
  static TextTheme textTheme = const TextTheme(
    displayLarge: TextStyle(fontSize: AppSizes.xl, fontWeight: FontWeight.bold, color: Colors.black),
    displayMedium: TextStyle(fontSize: AppSizes.lg, fontWeight: FontWeight.bold, color: Colors.black),
    bodyLarge: TextStyle(fontSize: AppSizes.md, color: Colors.black54),
    bodyMedium: TextStyle(fontSize: AppSizes.smd, color: Colors.black87),
    labelLarge: TextStyle(fontSize: AppSizes.md, fontWeight: FontWeight.bold, color: Colors.white),
  );

  // Custom Text Styles
  static const TextStyle navBarTitle = TextStyle(fontSize: AppSizes.lg, fontWeight: FontWeight.bold, color: Colors.white);
  static const TextStyle navBarItem = TextStyle(fontSize: AppSizes.md, color: Colors.white);
  static const TextStyle featureTitle = TextStyle(fontSize: AppSizes.smd, fontWeight: FontWeight.bold);
  static const TextStyle featureDescription = TextStyle(fontSize: AppSizes.smd);
  static const TextStyle buttonText = TextStyle(fontSize: AppSizes.md, fontWeight: FontWeight.bold, color: Colors.white);
}
