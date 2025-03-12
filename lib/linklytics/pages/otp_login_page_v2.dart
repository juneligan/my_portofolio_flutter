import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio_flutter/linklytics/i18/texts.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_button.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_sized_box.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text_field.dart';
import 'package:my_portfolio_flutter/linklytics/provider/otp_login_provider.dart';
import 'package:my_portfolio_flutter/linklytics/provider/otp_login_state.dart';
import 'package:my_portfolio_flutter/routes/linklytics_routes.dart';
import 'package:my_portfolio_flutter/routes/route_names.dart';

class OtpLoginPageV2 extends ConsumerWidget {
  const OtpLoginPageV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(otpLoginProvider);
    final notifier = ref.read(otpLoginProvider.notifier);

    return RefreshIndicator(
      onRefresh: () async => notifier.reset(),
      child: Center(
        child: _buildLogin(context, state, notifier),
      ),
    );
  }

  Widget _buildLogin(
    BuildContext context,
    OtpLoginState state,
    OtpLoginNotifier notifier,
  ) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ]),
      child: Form(
        key: GlobalKey<FormState>(),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          AppText(
            text: OtpLoginText.title.en,
            type: TextType.xl,
            color: Colors.blueAccent,
          ),
          AppSizedBox.md(),
          AppTextField(
            controller:
                state.isLogin ? state.phoneController : state.otpController,
            label: state.isLogin
                ? OtpLoginText.mobileNumber.en
                : OtpLoginText.otp.en,
            onSubmitted: (value) => state.isLogin
                ? notifier.sendOtp(state.phoneController.text, context)
                : notifier.verifyOtp(
                    context, () => context.go(RouteNames.linklyticsDashboard)),
            obscureText: state.isLogin ? false : true,
            // for password
            errorText: state.isLogin ? state.phoneError : state.otpError,
            // errorText: state.,
          ),
          AppSizedBox.md(),
          AppButton(
            label: state.isLogin
                ? OtpLoginText.request.en
                : OtpLoginText.submit.en,
            onPressed: () => state.isLogin
                ? notifier.sendOtp(state.phoneController.text, context)
                : notifier.verifyOtp(
                    context, () => context.go(LinkLyticsUri.dashboard.uri)),
            size: ButtonSize.fullWidth,
          ),
          AppSizedBox.sm(),
          AppText(
            text: OtpLoginText.description.en,
            type: TextType.xs,
            color: Colors.blueGrey,
          ),
          if (!state.isLogin) ...[
            GestureDetector(
              onTap: state.isOtpResendEnabled
                  ? () => notifier.sendOtp(state.phoneController.text, context)
                  : null,
              child: Consumer(builder: (context, ref, child) {
                final countdown = ref.watch(otpVerificationTimerProvider);
                return AppText(
                  text: state.isOtpResendEnabled
                      ? OtpLoginText.resend.en
                      : formatString(
                          OtpLoginText.retry.en,
                          [countdown.toString()],
                        )!,
                  type: TextType.sm,
                  color: state.isOtpResendEnabled ? Colors.green : Colors.grey,
                );
              }),
            ),
            AppSizedBox.sm(),
            GestureDetector(
              onTap: state.isOtpResendEnabled ? state.reset() : null,
              child: AppText(
                text: OtpLoginText.changeNumber.en,
                type: TextType.sm,
                color: state.isOtpResendEnabled ? Colors.green : Colors.grey,
              ),
            ),
          ] // If statement
        ]),
      ),
    );
  }
}
