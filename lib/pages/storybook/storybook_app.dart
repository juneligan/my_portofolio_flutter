
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class StorybookApp extends StatelessWidget {
  static const String storybookPath = '/storybook';
  const StorybookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Storybook(
      stories: [
        // Buttons
        Story(
          name: 'Buttons/Primary',
          builder: (context) => ElevatedButton(
            onPressed: () {},
            child: const Text('Primary Button'),
          ),
        ),
        Story(
          name: 'Buttons/Secondary',
          builder: (context) => OutlinedButton(
            onPressed: () {},
            child: const Text('Secondary Button'),
          ),
        ),
        Story(
          name: 'Buttons/Error',
          builder: (context) => ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Error Button'),
          ),
        ),
        Story(
          name: 'Buttons/Warning',
          builder: (context) => ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Warning Button'),
          ),
        ),

        // Typography
        Story(
          name: 'Typography/Title',
          builder: (context) => const Text(
            'Large Title',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Story(
          name: 'Typography/BodyText',
          builder: (context) => const Text(
            'This is a paragraph text example.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}