import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text_styles.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final String description;

  const FeatureCard({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.featureTitle),
              const SizedBox(height: 10),
              Text(description, style: AppTextStyles.featureDescription),
            ],
          ),
        ),
      ),
    );
  }
}
