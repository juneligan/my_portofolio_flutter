import 'dart:async';

class OtpTimerState {
  final int secondsRemaining;
  final bool isOtpResendEnabled;
  final Timer? timer;

  OtpTimerState({
    this.secondsRemaining = 180, // Default 3 minutes
    this.isOtpResendEnabled = false,
    this.timer,
  });

  OtpTimerState copyWith({
    int? secondsRemaining,
    bool? isOtpResendEnabled,
    Timer? timer,
  }) {
    return OtpTimerState(
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isOtpResendEnabled: isOtpResendEnabled ?? this.isOtpResendEnabled,
      timer: timer ?? this.timer,
    );
  }
}
