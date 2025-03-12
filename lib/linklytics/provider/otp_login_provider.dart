import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio_flutter/linklytics/be_api/api_route_names.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_sized_box.dart';
import 'package:telephone_check/telephone_check.dart';
import 'otp_login_state.dart';

final otpLoginProvider =
    StateNotifierProvider<OtpLoginNotifier, OtpLoginState>((ref) {
  return OtpLoginNotifier(ref);
});

final otpVerificationTimerProvider = StateProvider<int>((ref) => 20);

class OtpLoginNotifier extends StateNotifier<OtpLoginState> {
  final Ref ref;
  Timer? _timer;

  OtpLoginNotifier(this.ref)
      : super(OtpLoginState(
          phoneController: TextEditingController(text: "+639"),
          otpController: TextEditingController(),
        ));

  final timerState = otpVerificationTimerProvider;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiRouteNames.baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    headers: {'ContentType': 'application/json'},
  ));

  void sendOtp(String phNumber, BuildContext context) async {
    if (_prePhoneNumberValidation(phNumber) != null) {
      return;
    }
    final dialogContext = context; // ✅ Store context before async call
    showLoading(dialogContext);
    try {
      Response response = await _dio.post(
        ApiRouteNames.otpLoginRegistration,
        data: {'phoneNumber': phNumber},
      );
      if ((mounted && dialogContext.mounted) || dialogContext.mounted) {
        // ✅ Check both widget and context
        Navigator.of(dialogContext, rootNavigator: true).pop();
      }
      if (response.statusCode == 200) {
        state = state.copyWith(
          showVerifier: true,
          secondsRemaining: 20,
          isOtpResendEnabled: false,
          isOtpSectionEnabled: true,
          isLoading: false,
          isLogin: false,
        );
        _startTimer();
      }
    } on DioException catch (e) {
      state = state.copyWith(phoneError: "something went wrong");
      if (mounted && dialogContext.mounted) {
        // ✅ Check both widget and context
        Navigator.of(dialogContext, rootNavigator: true).pop();
      }
      print(e.toString());
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.headers);
        print(e.response!.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(content: Text("Something went wrong. Try again.")),
      );
    }
  }

  void _startTimer() {
    // Cancel any existing timer
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remainingTime = ref.read(otpVerificationTimerProvider);

      if (remainingTime > 0) {
        ref.read(otpVerificationTimerProvider.notifier).state =
            remainingTime - 1;
      } else {
        state = state.copyWith(isOtpResendEnabled: true);
        timer.cancel();
        ref.read(otpVerificationTimerProvider.notifier).state = 20;
      }
    });
  }

  String? _prePhoneNumberValidation(phNumber) {
    String? phoneError;
    if (!TelephoneChecker.isValid(phNumber)) {
      phoneError = "Invalid phone number";
    }
    bool validWithPlusSign = phNumber.startsWith("+639");
    bool validDigitsOnly = phNumber.startsWith("639");
    if (!(validWithPlusSign || validDigitsOnly)) {
      phoneError = "Invalid! PH mobile numbers only";
    }
    if ((validWithPlusSign && phNumber.length < 13) ||
        (validDigitsOnly && phNumber.length < 12)) {
      phoneError = "Invalid! numbers range is 12-13";
    } else if ((validWithPlusSign && phNumber.length > 13) ||
        (validDigitsOnly && phNumber.length > 12)) {
      phoneError = "Invalid! more than the required digits";
    }

    state = state.copyWith(phoneError: phoneError);
    return phoneError;
  }

  void verifyOtp(BuildContext context, VoidCallback navigateToDashboard) async {
    String otpError = "";
    String? otp = state.otpController.text;
    if (otp.isEmpty) {
      otpError = "OTP is required";
    } else if (otp.length != 6) {
      otpError = "OTP is a 6 digit number";
    }
    if (otpError.isNotEmpty) {
      state = state.copyWith(otpError: otpError);
      return;
    }
    final dialogContext = context; // ✅ Store context before async call
    showLoading(dialogContext);
    try {
      Response response = await _dio.post(
        ApiRouteNames.otpAuthentication,
        data: {
          'phoneNumber': state.phoneController.text,
          'otp': otp
        },
      );
      // Close the loading dialog
      Navigator.of(context, rootNavigator: true).pop();
      if (response.statusCode == 200) {
        if (mounted && dialogContext.mounted) {
          ScaffoldMessenger.of(dialogContext).showSnackBar(
            SnackBar(
                content: Text(state.isLogin
                    ? "Login successful"
                    : "Registration successful")),
          );
        }
        navigateToDashboard();
      }
    } on DioException catch (_) {
      // Close the loading dialog
      if (mounted && dialogContext.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Something went wrong. Try again.")),
        );
      }
    }
  }

  void showLoading(BuildContext dialogContext) {
    showDialog(
      context: dialogContext,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              AppSizedBox.xl(),
              const Text("Processing..."),
            ],
          ),
        );
      },
    );
  }

  void reset() {}

  @override
  void dispose() {
    _timer?.cancel(); // Ensure the timer is disposed when provider is destroyed
    super.dispose();
  }
}
