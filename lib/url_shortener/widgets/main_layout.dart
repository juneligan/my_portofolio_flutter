import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/url_shortener/widgets/custom_app_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: const PreferredSize(
          preferredSize: const Size.fromHeight(60),
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
        ), // This will change dynamically
          // body: Material(child: child), // Only the body changes dynamically
          // bottomNavigationBar: SizedBox(
          //   height: 60, // Set the fixed height for the footer
          //   child: _buildFooter(),
          // ), // Footer remains fixed
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(10),
      child: const Center(
          child: Text('© 2025 Linklytics - All rights reserved')),
    );
  }
}
