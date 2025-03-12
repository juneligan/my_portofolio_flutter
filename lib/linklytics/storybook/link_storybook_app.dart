import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_button.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_fade_in_widget.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_hyperlink.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_sized_box.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_spacing.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text_field.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/fade_in_text.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/responsive_container.dart';
import 'package:my_portfolio_flutter/linklytics/storybook/text_field_with_error_story.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class LinkStorybookApp extends StatelessWidget {
  static const String storybookPath = '/storybook';

  const LinkStorybookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Storybook(
      stories: [
        // Buttons
        Story(
          name: 'Buttons/Primary',
          builder: (context) => AppButton(
              label: 'Primary', onPressed: () {}, type: ButtonType.primary),
        ),
        Story(
          name: 'Buttons/Secondary',
          builder: (context) => AppButton(
            label: 'Secondary',
            onPressed: () {},
            type: ButtonType.secondary,
          ),
        ),
        Story(
            name: 'Buttons/Error',
            builder: (context) => AppButton(
                  label: 'Error',
                  onPressed: () {},
                  type: ButtonType.error,
                )),
        ...appButtonStories,

        // Animations
        ...fadeInWidgetStories,

        // Typography
        Story(
          name: 'Typography/Title',
          builder: (context) => Text(
            'Large Title',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        ...fadeInTextStories,

        Story(
          name: 'Typography/BodyText',
          builder: (context) => const Text(
            'This is a paragraph text example.',
            style: TextStyle(fontSize: 16),
          ),
        ),
        // -------TEXT FORM FIELD
        Story(
          name: 'TextField/Primary',
          builder: (context) => AppTextField(
            controller: TextEditingController(),
            label: "Email Address",
            variant: InputVariant.primary, // Blue Border
          ),
        ),
        Story(
          name: 'TextField/Secondary',
          builder: (context) => AppTextField(
            controller: TextEditingController(),
            label: "Search",
            variant: InputVariant.secondary, // Grey Border
            prefixIcon: Icon(Icons.search),
          ),
        ),
        Story(
          name: 'TextField/Danger',
          builder: (context) => AppTextField(
            controller: TextEditingController(),
            label: "Password",
            variant: InputVariant.danger, // Red Border
            obscureText: true,
          ),
        ),
        Story(
          name: 'TextField/Success',
          builder: (context) => AppTextField(
            controller: TextEditingController(),
            label: "OTP Code",
            variant: InputVariant.success, // Green Border
            textInputAction: TextInputAction.done,
            onSubmitted: (value) => print("Submitted OTP: $value"),
          ),
        ),
        Story(
          name: 'TextField/Error Handling',
          builder: (context) => Center(child: TextFieldWithErrorStory()),
        ),


        // Hyperlink Component
        ...appHyperlinkStories,

        // Spacing Showcase
        Story(
          name: 'Spacing/Example',
          builder: (context) => Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Container(
              color: Colors.blue,
              width: 100,
              height: 100,
            ),
          ),
        ),
        Story(
          name: "Layout/ResponsiveContainer",
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text("Responsive Container Example")),
            body: ResponsiveContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "This is a responsive container",
                    style: Theme.of(context).textTheme.labelLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "It adapts based on screen size!",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        ...appSizedBoxStories,
      ],
    );
  }
}
