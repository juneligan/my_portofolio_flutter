import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.maxLines = 1,
    this.hintText
  });

  final TextEditingController? controller;
  final int maxLines;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: CustomColor.scaffoldBg),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16.0),
          filled: true,
          fillColor: CustomColor.whiteSecondary,
          focusedBorder: getInputBorder,
          enabledBorder: getInputBorder,
          border: getInputBorder,
          hintText: hintText,
          hintStyle: const TextStyle(color: CustomColor.hintDart),
        ));
  }

  OutlineInputBorder get getInputBorder {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none);
  }
}
