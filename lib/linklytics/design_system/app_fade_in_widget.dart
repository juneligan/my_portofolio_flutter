import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class AppFadeInWidget extends ConsumerWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double offsetX;
  final double offsetY;
  /// Upward (offsetY < 0)
  /// Downward (offsetY > 0)
  /// Leftward (offsetX < 0)
  /// Rightward (offsetX > 0)

  const AppFadeInWidget({
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.offsetX = 0,
    this.offsetY = 20, // Default downward fade
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TweenAnimationBuilder(
      tween: Tween<Offset>(
        begin: Offset(offsetX / 100, offsetY / 100),
        end: Offset.zero,
      ),
      duration: duration,
      curve: Curves.easeOut,
      builder: (context, Offset value, child) {
        return Transform.translate(
          offset: Offset(value.dx * 100, value.dy * 100),
          child: Opacity(
            opacity: (1 - value.distance),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

final List<Story> fadeInWidgetStories = [
  Story(
    name: 'Animations/Fade In Widget',
    builder: (context) {
      final duration = context.knobs
          .slider(label: 'Duration (ms)', initial: 600, min: 100, max: 2000)
          .toInt();
      final delay = context.knobs
          .slider(label: 'Delay (ms)', initial: 0, min: 0, max: 2000)
          .toInt();
      final offsetX = context.knobs
          .slider(label: 'Offset X', initial: 0, min: -100, max: 100)
          .toDouble();
      final offsetY = context.knobs
          .slider(label: 'Offset Y', initial: 20, min: -100, max: 100)
          .toDouble();

      return Scaffold(
        appBar: AppBar(title: Text('Storybook - FadeInWidget')),
        body: Center(
          child: AppFadeInWidget(
            duration: Duration(milliseconds: duration),
            delay: Duration(milliseconds: delay),
            offsetX: offsetX,
            offsetY: offsetY,
            child: Text(
              'Hello, Storybook!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    },
  ),
];