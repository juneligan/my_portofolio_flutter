import 'package:flutter/material.dart';

import 'app_spacing.dart';

/// Define input field styles
enum InputVariant { primary, secondary, danger, success }

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final InputVariant variant;
  final FocusNode? focusNode;
  final String? errorText;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.variant = InputVariant.primary,
    this.focusNode,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      style: const TextStyle(fontSize: AppSpacing.md),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: _getBorder(),
        // Fixed: Returns OutlineInputBorder
        enabledBorder: _getBorder(),
        focusedBorder: _getFocusedBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        errorText: errorText,
      ),
    );
  }

  /// Get different border styles based on variant
  OutlineInputBorder _getBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: _getBorderColor(), width: 1.5),
    );
  }

  /// Get a stronger border when the field is focused
  OutlineInputBorder _getFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: _getBorderColor(), width: 2.0),
    );
  }

  /// Get different border colors based on variant
  Color _getBorderColor() {
    switch (variant) {
      case InputVariant.primary:
        return Colors.blue;
      case InputVariant.secondary:
        return Colors.grey;
      case InputVariant.danger:
        return Colors.red;
      case InputVariant.success:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}
