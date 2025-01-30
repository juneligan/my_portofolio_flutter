import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/url_shortener/constants/size.dart';
import 'package:my_portfolio_flutter/url_shortener/constants/colors.dart';
import 'package:my_portfolio_flutter/url_shortener/widgets/otp_verifier_section.dart';
import 'package:my_portfolio_flutter/url_shortener/widgets/phone_number_section.dart';
import 'package:my_portfolio_flutter/widgets/custom_text_field.dart';
import 'package:my_portfolio_flutter/widgets/header_desktop.dart';
import 'package:my_portfolio_flutter/widgets/header_mobile.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey _verifierKey = GlobalKey();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final List<GlobalKey> navBarKeys = List.generate(4, (index) => GlobalKey());
  bool _showVerifier = false;
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  int _secondsRemaining = 180;
  bool _isOtpResendEnabled = false;
  bool _isOtpSectionEnabled = false;

  void _submit() {
    setState(() {
      _showVerifier = true;
      _secondsRemaining = 180;
      _isOtpResendEnabled = false;
      _isOtpSectionEnabled = true;
      _startTimer();
    });
    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
        _phoneController.clear();
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
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
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
            SizedBox(height: 100),
            PhoneNumberSection(
              enabled: !_isOtpSectionEnabled, // Disable if OTP timer is running
              onPressed: _isOtpSectionEnabled ? null : _submit,
              controller: _phoneController,
              onSubmit: (value) => _submit(),
            ),
            // OTP section
            if (_showVerifier) ...[
              SizedBox(height: 100),
              OtpVerifierSection(
                isSectionEnabled: _isOtpSectionEnabled,
                isResendEnabled: _isOtpResendEnabled,
                secondsRemaining: _secondsRemaining,
                onTap: _isOtpResendEnabled ? _resendOtp : null,
                changeNumberCallback:
                _isOtpResendEnabled ? _changeNumber : null,
                onPressed: () {}, // this will enable the button to green
              ),
            ],
          ]),
        ),
      );
    });
  }
}
