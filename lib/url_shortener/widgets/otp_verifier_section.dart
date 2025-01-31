import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/url_shortener/constants/colors.dart';
import 'package:my_portfolio_flutter/widgets/custom_text_field.dart';

class OtpVerifierSection extends StatelessWidget {
  const OtpVerifierSection({
    super.key,
    this.onTap,
    this.isResendEnabled = true,
    this.secondsRemaining = 0,
    this.changeNumberCallback,
    this.isSectionEnabled = true,
    this.onPressed,
    this.errorText,
  });

  final bool isSectionEnabled;
  final GestureTapCallback? onTap;
  final bool isResendEnabled;
  final int secondsRemaining;
  final GestureTapCallback? changeNumberCallback;
  final VoidCallback? onPressed;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return Container(
      height: screenHeight - 100,
      key: key,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CustomColor.bgLight1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 300,
          maxWidth: 300,
          minHeight: 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: isSectionEnabled ? 1.0 : 0.3,
              child: IgnorePointer(
                ignoring: !isSectionEnabled,
                child: CustomTextField(
                  hintText: "Enter OTP",
                  errorText: errorText,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
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
                child: const Text("Verify OTP",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: onTap,
                child: Text(
                  isResendEnabled
                      ? "Resend OTP"
                      : "Retry in $secondsRemaining seconds",
                  style: TextStyle(
                      fontSize: 16,
                      color: isResendEnabled ? Colors.green : Colors.grey,
                      decoration:
                          isResendEnabled ? TextDecoration.underline : null),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: isResendEnabled ? changeNumberCallback : null,
                child: Text(
                  "Change Phone Number",
                  style: TextStyle(
                      fontSize: 16,
                      color: isResendEnabled ? Colors.blue : Colors.grey,
                      decoration:
                          isResendEnabled ? TextDecoration.underline : null),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
