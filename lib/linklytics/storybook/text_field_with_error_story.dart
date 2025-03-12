import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_button.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text_field.dart';

typedef ErrorCallback = void Function(String? error);

class TextFieldWithErrorStory extends StatefulWidget {
  @override
  _TextFieldWithErrorStoryState createState() => _TextFieldWithErrorStoryState();
}

class _TextFieldWithErrorStoryState extends State<TextFieldWithErrorStory> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  void _validateInput() {
    setState(() {
      _errorText = _controller.text.isEmpty ? "This field cannot be empty" : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: _controller,
          label: "Enter something",
          errorText: _errorText,
        ),
        const SizedBox(height: 10),
        AppButton(
          label: "Validate",
          onPressed: _validateInput,
        ),
      ],
    );
  }
}