import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_predefined_size.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

/// A design system component for consistent spacing
class AppSizedBox extends StatelessWidget {
  final double height;
  final double width;

  const AppSizedBox._({Key? key, this.height = 0, this.width = 0}) : super(key: key);

  // Predefined sizes
  factory AppSizedBox.xs({bool horizontal = false}) =>
      AppSizedBox._(height: horizontal ? 0 : AppPredefinedSize.xs, width: horizontal ? AppPredefinedSize.xs : 0);

  factory AppSizedBox.sm({bool horizontal = false}) =>
      AppSizedBox._(height: horizontal ? 0 : AppPredefinedSize.sm, width: horizontal ? AppPredefinedSize.sm : 0);

  factory AppSizedBox.md({bool horizontal = false}) =>
      AppSizedBox._(height: horizontal ? 0 : AppPredefinedSize.md, width: horizontal ? AppPredefinedSize.md : 0);

  factory AppSizedBox.lg({bool horizontal = false}) =>
      AppSizedBox._(height: horizontal ? 0 : AppPredefinedSize.lg, width: horizontal ? AppPredefinedSize.lg : 0);

  factory AppSizedBox.xl({bool horizontal = false}) =>
      AppSizedBox._(height: horizontal ? 0 : AppPredefinedSize.xl, width: horizontal ? AppPredefinedSize.xl : 0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, width: width);
  }
}


/// Storybook examples
final List<Story> appSizedBoxStories = [
  Story(
    name: 'Spacing/XS',
    builder: (context) => Column(
      children: [Text('XS Spacing'), AppSizedBox.xs(), Text('Next Element')],
    ),
  ),
  Story(
    name: 'Spacing/SM',
    builder: (context) => Column(
      children: [Text('SM Spacing'), AppSizedBox.sm(), Text('Next Element')],
    ),
  ),
  Story(
    name: 'Spacing/MD',
    builder: (context) => Column(
      children: [Text('MD Spacing'), AppSizedBox.md(), Text('Next Element')],
    ),
  ),
  Story(
    name: 'Spacing/LG',
    builder: (context) => Column(
      children: [Text('LG Spacing'), AppSizedBox.lg(), Text('Next Element')],
    ),
  ),
  Story(
    name: 'Spacing/XL',
    builder: (context) => Column(
      children: [Text('XL Spacing'), AppSizedBox.xl(), Text('Next Element')],
    ),
  ),
];