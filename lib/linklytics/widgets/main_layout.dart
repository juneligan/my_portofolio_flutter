import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_spacing.dart';
import 'package:my_portfolio_flutter/linklytics/widgets/custom_app_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar(),
        ),
        body: Column(
          children: [
            /// 🔹 Allow the child to take up all available space
            Expanded(
              child: child,
            ),
            _buildFooter(), // ✅ Footer stays at the bottom
          ],
        ), // This will change dynamica
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(AppSpacing.md),
      child: const Center(
          child: Text('© 2025 Linklytics - All rights reserved')),
    );
  }
}
