import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio_flutter/routes/route_names.dart';
import 'package:my_portfolio_flutter/linklytics/be_integration/api_route_names.dart';
import 'package:telephone_check/telephone_check.dart';

class OtpLoginPage extends StatefulWidget {
  const OtpLoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _OtpLoginPageState();
}

class _OtpLoginPageState extends State<OtpLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  Timer? _timer;
  bool isLogin = true;
  int _secondsRemaining = 180;
  bool _isOtpResendEnabled = false;
  String? _phoneError;
  String? _otpError;
  late Dio _dio;

  @override
  void initState() {
    super.initState();
    _phoneController.text = "+639";
    final options = BaseOptions(
        baseUrl: ApiRouteNames.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {'ContentType': 'application/json'});
    _dio = Dio(options);
  }

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      // Process login or registration
      print("Logging in...");
    }

    String phNumber = _phoneController.text;
    // Show loading dialog
    sendOtp(phNumber);
  }

  Future<void> sendOtp(String phNumber) async {
    final dialogContext = context; // ✅ Store context before async call
    showLoading(dialogContext);

    try {
      Response response = await _dio.post(
        ApiRouteNames.otpLoginRegistration,
        data: {'phoneNumber': phNumber},
      );

      // Close the loading dialog
      if (mounted && dialogContext.mounted) {
        // ✅ Check both widget and context
        Navigator.of(dialogContext, rootNavigator: true).pop();
      }

      if (response.statusCode == 200) {
        setState(() {
          _secondsRemaining = 180;
          _isOtpResendEnabled = false;
          isLogin = false;
          _startTimer();
        });
      } else {
        print(response);
        setState(() {
          isLogin = true;
        });
      }

      // Show success message (You can navigate or show an alert)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(isLogin ? "Login successful" : "Sent OTP to $phNumber")),
      );
    } on DioException catch (e) {
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
      // _showServerErrorDialog(); // ---> new (Show alert dialog for server errors)
      setState(() {
        _phoneError =
            "Failed to send request. Please try again."; // ---> new (API error handling)
      });
      // Close the loading dialog in case of error
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong. Try again.")),
      );
    }
  }

  String? _prePhoneNumberValidation(phNumber) {
    phNumber = phNumber ?? _phoneController.text;
    _phoneError = null;
    setState(() {
      if (!TelephoneChecker.isValid(phNumber)) {
        _phoneError = "Invalid phone number";
      }
      bool validWithPlusSign = phNumber.startsWith("+639");
      bool validDigitsOnly = phNumber.startsWith("639");
      if (!(validWithPlusSign || validDigitsOnly)) {
        _phoneError = "Invalid! PH mobile numbers only";
      }
      if ((validWithPlusSign && phNumber.length < 13) ||
          (validDigitsOnly && phNumber.length < 12)) {
        _phoneError = "Invalid! Lacking numbers";
      } else if ((validWithPlusSign && phNumber.length > 13) ||
          (validDigitsOnly && phNumber.length > 12)) {
        _phoneError = "Invalid! more than the required digits";
      }
    });

    return _phoneError;
  }

  void showLoading(BuildContext dialogContext) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Processing..."),
            ],
          ),
        );
      },
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

  Future<void> _verifyOtp(VoidCallback navigateToDashboard) async {
    setState(() {
      _otpError = null;
    });

    verifyOtp(navigateToDashboard);
  }

  Future<void> verifyOtp(VoidCallback navigateToDashboard) async {
    final dialogContext = context; // ✅ Store context before async call
    showLoading(dialogContext);
    try {
      Response response = await _dio.post(
        ApiRouteNames.otpAuthentication,
        // ---> new (API endpoint for OTP verification)
        data: {
          'phoneNumber': _phoneController.text,
          'otp': _otpController.text,
        },
      );

      if (mounted && dialogContext.mounted) {
        // ✅ Check both widget and context
        Navigator.of(dialogContext, rootNavigator: true).pop();
      }
      if (response.statusCode == 200) {
        // Show success message (You can navigate or show an alert)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  isLogin ? "Login successful" : "Registration successful")),
        );
        // Handle success (e.g., navigate to another page)
        navigateToDashboard();
      } else {
        print("verify otp: $response");
        setState(() {
          _otpError =
              "Invalid OTP. Please try again."; // ---> new (Invalid OTP error)
        });
      }
    } on DioException catch (e) {
      print("error: $e");

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
      // _showServerErrorDialog(); // ---> new (Show alert dialog for server errors)
      setState(() {
        _otpError =
            "Failed to verify OTP. Please try again."; // ---> new (API error handling)
      });
      if (mounted && dialogContext.mounted) {
        // ✅ Check both widget and context
        Navigator.of(dialogContext, rootNavigator: true).pop();
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong. Try again.")),
      );
    }
  }

  void _resendOtp(String phoneNumber) {
    sendOtp(phoneNumber);
    setState(() {
      _secondsRemaining = 180;
      _isOtpResendEnabled = false;
      _startTimer();
    });
  }

  void _changeNumber() {
    if (_isOtpResendEnabled) {
      setState(() {
        _phoneController.text = "+639";
        _otpController.clear();
      });
    }
  }

  Future<void> _refreshPage() async {
    setState(() {
      _phoneController.clear();
      _otpController.clear();
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
    return RefreshIndicator(
      onRefresh: _refreshPage,
      child: Center(
        child: _buildLogin(),
      ),
    );
  }

  Container _buildLogin() {
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
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Login Here",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            if (isLogin)
              // Login Mobile Number text field
              ...[
              // buildMobileNumberForm(),
              buildOtpForm(
                labelText: "Mobile Number",
                controller: _phoneController,
                errorText: _phoneError,
              ),
              const SizedBox(height: 20),
              buildOtpLoginButton("Request OTP", _validateAndSubmit),
            ],
            if (!isLogin)
              // OTP validation text field
              ...[
              buildOtpForm(
                  labelText: "One Time Password(OTP)",
                  controller: _otpController,
                  errorText: _otpError,
                  obscureText: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _verifyOtp(
                  () => context.go(RouteNames.linklyticsDashboard),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Submit OTP",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => context.go('/linklytics/register'),
              child: const Text(
                "Don't have an account? SignUp",
                style: TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            if (isLogin)
              GestureDetector(
                onTap: () => context.go('/linklytics/login'),
                child: const Text(
                  "You're away from your phone? try this Login",
                  style: TextStyle(
                      color: Colors.blueAccent, fontWeight: FontWeight.bold),
                ),
              ),
            if (!isLogin)
              GestureDetector(
                onTap: () => _isOtpResendEnabled
                    ? _resendOtp(_phoneController.text)
                    : null,
                child: Text(
                  _isOtpResendEnabled
                      ? "Resend OTP"
                      : "Retry in $_secondsRemaining seconds",
                  style: TextStyle(
                      fontSize: 16,
                      color: _isOtpResendEnabled ? Colors.green : Colors.grey,
                      decoration: _isOtpResendEnabled
                          ? TextDecoration.underline
                          : null),
                ),
              ),
            const SizedBox(height: 10),
            if (!isLogin)
              GestureDetector(
                onTap: _isOtpResendEnabled ? _changeNumber : null,
                child: Text(
                  "Change Phone Number?",
                  style: TextStyle(
                      fontSize: 16,
                      color: _isOtpResendEnabled ? Colors.green : Colors.grey,
                      decoration: _isOtpResendEnabled
                          ? TextDecoration.underline
                          : null),
                ),
              ),
          ],
        ),
      ),
    );
  }

  ElevatedButton buildOtpLoginButton(
    String buttonText,
    VoidCallback? action,
  ) {
    return ElevatedButton(
      onPressed: action,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Center(
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  TextFormField buildOtpForm({
    String? labelText,
    TextEditingController? controller,
    String? errorText,
    String? nullOrEmptyError,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          errorText: errorText),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "*$labelText is required*";
        }
        return errorText;
      },
    );
  }

  TextFormField buildMobileNumberForm() {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: "Mobile Number",
        border: const OutlineInputBorder(),
        errorText: _phoneError,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "*Mobile number is required*";
        }
        return _prePhoneNumberValidation(value);
      },
    );
  }
}
