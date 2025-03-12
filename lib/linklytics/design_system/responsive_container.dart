import 'package:flutter/material.dart';

enum ScreenSize { xs, sm, md, lg, xl }

class ResponsiveContainer extends StatelessWidget {
  final Widget child;

  const ResponsiveContainer({super.key, required this.child});

  static ScreenSize getScreenSize(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 480) {
      return ScreenSize.xs;
    } else if (width < 768) {
      return ScreenSize.sm;
    } else if (width < 1024) {
      return ScreenSize.md;
    } else if (width < 1440) {
      return ScreenSize.lg;
    } else {
      return ScreenSize.xl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        ScreenSize screenSize = getScreenSize(context);
        double maxWidth;

        switch (screenSize) {
          case ScreenSize.xs:
            maxWidth = constraints.maxWidth * 0.9;
            break;
          case ScreenSize.sm:
            maxWidth = constraints.maxWidth * 0.85;
            break;
          case ScreenSize.md:
            maxWidth = constraints.maxWidth * 0.8;
            break;
          case ScreenSize.lg:
            maxWidth = 1200;
            break;
          case ScreenSize.xl:
            maxWidth = 1400;
            break;
        }

        return Center(
          child: Container(
            width: maxWidth,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: child,
          ),
        );
      },
    );
  }
}
