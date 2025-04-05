import 'dart:async';

import 'package:flutter/material.dart';

class OtpLoginState {
  final TextEditingController phoneController;
  final TextEditingController otpController;
  final Timer? timer;
  final bool isLogin;
  final bool showVerifier;
  final int secondsRemaining;
  final bool isOtpResendEnabled;
  final bool isOtpSectionEnabled;
  final bool isLoading;
  final String? phoneError;
  final String? otpError;

  OtpLoginState({
    required this.phoneController,
    required this.otpController,
    this.timer,
    this.isLogin = true,
    this.showVerifier = false,
    this.secondsRemaining = 180,
    this.isOtpResendEnabled = false,
    this.isOtpSectionEnabled = false,
    this.isLoading = false,
    this.phoneError,
    this.otpError,
  });

  OtpLoginState copyWith({
    TextEditingController? phoneController,
    TextEditingController? otpController,
    Timer? timer,
    bool? isLogin,
    bool? showVerifier,
    int? secondsRemaining,
    bool? isOtpResendEnabled,
    bool? isOtpSectionEnabled,
    bool? isLoading,
    String? phoneError,
    String? otpError,
  }) {
    return OtpLoginState(
      phoneController: phoneController ?? this.phoneController,
      otpController: otpController ?? this.otpController,
      timer: timer ?? this.timer,
      isLogin: isLogin ?? this.isLogin,
      showVerifier: showVerifier ?? this.showVerifier,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isOtpResendEnabled: isOtpResendEnabled ?? this.isOtpResendEnabled,
      isOtpSectionEnabled: isOtpSectionEnabled ?? this.isOtpSectionEnabled,
      isLoading: isLoading ?? this.isLoading,
      phoneError: phoneError,
      otpError: otpError,
    );
  }

  reset() {
    copyWith(
      showVerifier: false,
      isOtpResendEnabled: false,
      isOtpSectionEnabled: false,
      isLoading: false,
      isLogin: true,
      phoneController: TextEditingController(text: "+639"),
      otpController: TextEditingController(),
    );
  }
}
