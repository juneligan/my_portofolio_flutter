import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'otp_timer_state.dart';
final otpTimerProvider = StateNotifierProvider<OtpTimerNotifier, OtpTimerState>(
      (ref) => OtpTimerNotifier(),
);


class OtpTimerNotifier extends StateNotifier<OtpTimerState> {
  OtpTimerNotifier() : super(OtpTimerState());


  void startTimer() {
    state.timer?.cancel(); // Cancel any existing timer

    final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsRemaining > 0) {
        // Use `state = state.copyWith(...)` to update only the secondsRemaining
        state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
      } else {
        state = state.copyWith(isOtpResendEnabled: true);
        timer.cancel();
      }
    });

    // Update state only once with the new timer
    state = state.copyWith(timer: timer);
  }

  void resetTimer(int newSeconds) {
    state.timer?.cancel();
    state = state.copyWith(secondsRemaining: newSeconds, isOtpResendEnabled: false);
    startTimer();
  }

  @override
  void dispose() {
    state.timer?.cancel();
    super.dispose();
  }
}
