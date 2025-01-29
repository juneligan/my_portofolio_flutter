import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/constants/colors.dart';
import 'package:my_portfolio_flutter/constants/size.dart';
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
  final scrollController = ScrollController();
  final List<GlobalKey> navBarKeys = List.generate(4, (index) => GlobalKey());
  bool _showVerifier = false;
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  int _secondsRemaining = 180;
  bool _isOtpResendEnabled = false;

  void _submit() {
    setState(() {
      _showVerifier = true;
      _secondsRemaining = 180;
      _isOtpResendEnabled = false;
      _startTimer();
    });
    Future.delayed(Duration(milliseconds: 300), () {
      Scrollable.ensureVisible(_verifierKey.currentContext!,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        key: scaffoldKey,
        backgroundColor: CustomColor.scaffoldBg,
        body: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter phone number",
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Color(0xFF1A1A1A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4CAF50),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("Submit",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            if (_showVerifier) ...[
              SizedBox(height: 50),
              Container(
                key: _verifierKey,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF262626),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter OTP",
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Color(0xFF1A1A1A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4CAF50),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text("Verify OTP",
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        _isOtpResendEnabled
                            ? "Resend OTP"
                            : "Retry in $_secondsRemaining seconds",
                        style: TextStyle(
                            fontSize: 16,
                            color: _isOtpResendEnabled
                                ? Colors.green
                                : Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ]),
        ),
      );
    });
  }
}
