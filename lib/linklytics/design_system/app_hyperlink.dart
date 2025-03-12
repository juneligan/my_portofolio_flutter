import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class AppHyperlink extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final TextStyle? style;
  final TextType? type;
  final Color? color;

  const AppHyperlink({
    super.key,
    required this.text,
    this.onTap,
    this.style,
    this.type,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AppText(text: text, type: type ?? TextType.md, color: color,)
          // Text(
          //   text,
          //   style: style ??
          //       const TextStyle(
          //         color: Colors.blue,
          //         decoration: TextDecoration.underline,
          //       ),
          // ),
          ),
    );
  }
}

/// Storybook examples
final List<Story> appHyperlinkStories = [
  Story(
    name: 'Hyperlink/Default',
    builder: (context) {
      ValueNotifier<bool> isVisible = ValueNotifier(false);
      return Column(
        children: [
          AppHyperlink(
            text: 'Click Me',
            onTap: () => isVisible.value = !isVisible.value,
          ),
          ValueListenableBuilder(
            valueListenable: isVisible,
            builder: (context, value, child) =>
                value ? Text('Hyperlink Clicked!') : SizedBox.shrink(),
          ),
        ],
      );
    },
  ),
  Story(
    name: 'Hyperlink/Custom Style',
    builder: (context) {
      ValueNotifier<bool> isVisible = ValueNotifier(false);
      return Column(
        children: [
          AppHyperlink(
            text: 'Custom Link',
            onTap: () => isVisible.value = !isVisible.value,
            style: const TextStyle(
                color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ValueListenableBuilder(
            valueListenable: isVisible,
            builder: (context, value, child) => value
                ? const Text('Custom Hyperlink Clicked!',
                    style: TextStyle(color: Colors.red))
                : SizedBox.shrink(),
          ),
        ],
      );
    },
  ),
  Story(
    name: 'Hyperlink/Knobs',
    builder: (context) {
      final text = context.knobs.text(label: 'Text', initial: 'Click Me');
      final color = context.knobs.options(
        label: 'Color',
        options: const [
          Option(label: 'Blue', value: Colors.blue),
          Option(label: 'Red', value: Colors.red),
          Option(label: 'Green', value: Colors.green),
        ],
        initial: Colors.blue,
      );
      final isVisible =
          context.knobs.boolean(label: 'Show Message', initial: false);

      return Column(
        children: [
          AppHyperlink(
            text: text,
            onTap: () {},
            style: TextStyle(color: color),
          ),
          if (isVisible)
            Text('Hyperlink Clicked!', style: TextStyle(color: color)),
        ],
      );
    },
  ),
];
