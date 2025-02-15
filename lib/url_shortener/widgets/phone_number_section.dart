import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/url_shortener/constants/colors.dart';
import 'package:my_portfolio_flutter/widgets/custom_text_field.dart';

class PhoneNumberSection extends StatelessWidget {
  const PhoneNumberSection({
    super.key,
    this.controller,
    this.onSubmit,
    this.enabled = true,
    this.onPressed,
    this.errorText,
    this.isLoading = false,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onSubmit;
  final bool enabled;
  final VoidCallback? onPressed;
  final String? errorText;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return Container(
        height: screenHeight - 100,
        color: CustomColor.bgLight1,
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 60),
        child: Column(children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 300,
              maxWidth: 300,
              minHeight: 100,
            ),
            child: Column(
              children: [
                CustomTextField(
                  hintText: "+639",
                  controller: controller,
                  onSubmitted: onSubmit,
                  enabled: enabled,
                  // Disable if OTP timer is running
                  errorText: errorText,
                ),
                if (isLoading) const CircularProgressIndicator(), // ---> Loading indicator for login
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Submit",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
