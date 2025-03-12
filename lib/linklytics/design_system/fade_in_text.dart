import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class FadeInText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final bool moveDownward; // true = downward, false = upward

  const FadeInText({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 600),
    this.moveDownward = true, // Default: move downward
  });

  @override
  _FadeInTextState createState() => _FadeInTextState();
}

class _FadeInTextState extends State<FadeInText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.moveDownward ? -0.5 : 0.5), // Up or Down
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Text(
          widget.text,
          style: widget.style ?? const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

final List<Story> fadeInTextStories = [
  Story(
    name: 'Typography/FadeInText',
    builder: (context) => Center(
      child: FadeInText(
        text: context.knobs.text(label: 'Text', initial: 'Login Here'),
        duration: Duration(
          milliseconds: context.knobs.sliderInt(
            label: 'Duration (ms)',
            initial: 600,
            min: 100,
            max: 2000,
          ),
        ),
        moveDownward: context.knobs.boolean(
          label: 'Move Downward',
          initial: true,
        ),
        style: TextStyle(
          fontSize: context.knobs.slider(
            label: 'Font Size',
            initial: 24,
            min: 12,
            max: 48,
          ),
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    ),
  )
];