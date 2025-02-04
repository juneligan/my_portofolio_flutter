import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio_flutter/routes/route_names.dart';
import 'package:my_portfolio_flutter/url_shortener/be_api/api_route_names.dart';
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
  bool _isLoading = false;
  late Dio _dio;

  @override
  void initState() {
    super.initState();
    _phoneController.text = "+639";
    final options = BaseOptions(
      // baseUrl: 'http://localhost:8080/',
      baseUrl: ApiRouteNames.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers:{'ContentType': 'application/json'}
    );
    _dio = Dio(options);
  }

  Future<void> _submit() async {
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
      _isLoading = true;
    });

    if (_phoneError != null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      Response response = await _dio.post(
        ApiRouteNames.otpLoginRegistration, // ---> new (API endpoint for login)
        data: {'phoneNumber': _phoneController.text},
      );

      if (response.statusCode == 200) {
        setState(() {
          _showVerifier = true;
          _secondsRemaining = 180;
          _isOtpResendEnabled = false;
          _isOtpSectionEnabled = true;
          _isLoading = false;
          _startTimer();
        });
        Future.delayed(const Duration(milliseconds: 300), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // _showServerErrorDialog(); // ---> new (Show alert dialog for server errors)
      setState(() {
        _isLoading = false;
        _phoneError = "Failed to send request. Please try again."; // ---> new (API error handling)
      });
    }
  }

  Future<void> _verifyOtp(VoidCallback navigateToDashboard) async {
    setState(() {
      _otpError = null;
    });

    try {
      Response response = await _dio.post(
        ApiRouteNames.otpAuthentication, // ---> new (API endpoint for OTP verification)
        data: {
          'phoneNumber': _phoneController.text,
          'otp': _otpController.text,
        },
      );

      if (response.statusCode == 200) {
        // Handle success (e.g., navigate to another page)
        navigateToDashboard();
      } else {
        setState(() {
          _otpError = "Invalid OTP. Please try again."; // ---> new (Invalid OTP error)
        });
      }
    } catch (e) {
      // _showServerErrorDialog(); // ---> new (Show alert dialog for server errors)
      setState(() {
        _otpError = "Failed to verify OTP. Please try again."; // ---> new (API error handling)
      });
    }
  }

  void _showServerErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Server Error"),
        content: const Text("Server is currently unavailable. Please try again later or contact support."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
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

  Future<void> _refreshPage() async {
    setState(() {
      _phoneController.clear();
      _otpController.clear();
      _showVerifier = false;
      _isOtpSectionEnabled = false;
      _isOtpResendEnabled = false;
      _phoneError = null;
      _otpError = null;
    });
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
        body: RefreshIndicator(
          onRefresh: _refreshPage,
          child: SingleChildScrollView(
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
                  controller: _otpController,
                  isSectionEnabled: _isOtpSectionEnabled,
                  isResendEnabled: _isOtpResendEnabled,
                  secondsRemaining: _secondsRemaining,
                  onTap: _isOtpResendEnabled ? _resendOtp : null,
                  changeNumberCallback:
                  _isOtpResendEnabled ? _changeNumber : null,
                  errorText: _otpError,
                  onPressed: () {
                    _verifyOtp(() => context.goNamed(RouteNames.dashboard));
                    // setState(() {
                    //   _otpError = "Invalid OTP, please try again";
                    // });
                  }, // this will enable the button to green
                ),
              ],
            ]),
          ),
        ),
      );
    });
  }
}
