import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio_flutter/routes/route_names.dart';
import 'package:my_portfolio_flutter/url_shortener/constants/size.dart';
import 'package:my_portfolio_flutter/url_shortener/constants/colors.dart';
import 'package:my_portfolio_flutter/url_shortener/widgets/otp_verifier_section.dart';
import 'package:my_portfolio_flutter/url_shortener/widgets/phone_number_section.dart';
import 'package:my_portfolio_flutter/widgets/header_desktop.dart';
import 'package:my_portfolio_flutter/widgets/header_mobile.dart';
import 'package:telephone_check/telephone_check.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final List<GlobalKey> navBarKeys = List.generate(4, (index) => GlobalKey());
  bool _showVerifier = false;
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  int _secondsRemaining = 180;
  bool _isOtpResendEnabled = false;
  bool _isOtpSectionEnabled = false;
  String? _phoneError;
  String? _otpError;

  @override
  void initState() {
    super.initState();
    _phoneController.text = "+639";
  }

  void _submit() {
    String phNumber = _phoneController.text;
    setState(() {
      if (!TelephoneChecker.isValid(phNumber)) {
        _phoneError = "Invalid phone number";
        return;
      }
      bool validWithPlusSign = phNumber.startsWith("+639");
      bool validDigitsOnly = phNumber.startsWith("639");
      if (!(validWithPlusSign || validDigitsOnly)) {
        _phoneError = "Invalid! PH mobile numbers only";
        return;
      }
      if ((validWithPlusSign && phNumber.length < 13) ||
          (validDigitsOnly && phNumber.length < 12)) {
        _phoneError = "Invalid! Lacking numbers";
        return;
      } else if ((validWithPlusSign && phNumber.length > 13) ||
          (validDigitsOnly && phNumber.length > 12)) {
        _phoneError = "Invalid! more than the required digits";
        return;
      }
      _phoneError = null;
      _showVerifier = true;
      _secondsRemaining = 180;
      _isOtpResendEnabled = false;
      _isOtpSectionEnabled = true;
      _startTimer();
    });
    if (_phoneError == null) { // should only move/animate if no errors
      Future.delayed(const Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _isOtpResendEnabled = true;
        });
        _timer?.cancel();
      }
    });
  }

  void _resendOtp() {
    setState(() {
      _secondsRemaining = 180;
      _isOtpResendEnabled = false;
      _startTimer();
    });
  }

  void _changeNumber() {
    if (_isOtpResendEnabled) {
      setState(() {
        _showVerifier = false;
        _phoneController.text = "+639";
        _otpController.clear();
        _isOtpSectionEnabled = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        key: scaffoldKey,
        backgroundColor: CustomColor.scaffoldBg,
        body: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: Column(children: [
            SizedBox(
              key: navBarKeys.first,
            ),
            if (constraints.maxWidth >= kMinDesktopWidth)
              HeaderDesktop(
                onNavMenuTap: (int navIndex) {
                  // scrollToSection(navIndex);
                },
              )
            else
              HeaderMobile(
                onLogosTap: () {},
                onMenuTap: () {
                  scaffoldKey.currentState?.openEndDrawer();
                },
              ),

            // Login
            const SizedBox(height: 100),
            PhoneNumberSection(
              enabled: !_isOtpSectionEnabled,
              // Disable if OTP timer is running
              onPressed: _isOtpSectionEnabled ? null : _submit,
              controller: _phoneController,
              onSubmit: (value) => _submit(),
              errorText: _phoneError,
            ),
            // OTP section
            if (_showVerifier) ...[
              const SizedBox(height: 100),
              OtpVerifierSection(
                isSectionEnabled: _isOtpSectionEnabled,
                isResendEnabled: _isOtpResendEnabled,
                secondsRemaining: _secondsRemaining,
                onTap: _isOtpResendEnabled ? _resendOtp : null,
                changeNumberCallback:
                    _isOtpResendEnabled ? _changeNumber : null,
                errorText: _otpError,
                onPressed: () {
                  context.goNamed(RouteNames.dashboard);
                  // setState(() {
                  //   _otpError = "Invalid OTP, please try again";
                  // });
                }, // this will enable the button to green
              ),
            ],
          ]),
        ),
      );
    });
  }
}
