import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio_flutter/linklytics/be_integration/api_route_names.dart';
import 'package:my_portfolio_flutter/linklytics/provider/jwt_token_notifier.dart';
import 'package:my_portfolio_flutter/routes/linklytics_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Dio _dio;

  @override
  void initState() {
    super.initState();
    final options = BaseOptions(
        // baseUrl: 'http://localhost:8080/',
        baseUrl: ApiRouteNames.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {'ContentType': 'application/json'});
    _dio = Dio(options);
  }

  void toggleForm() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void _validateAndSubmit(Function(String? value) navigate) async {
    if (_formKey.currentState!.validate()) {
      // Process login or registration
      print(isLogin ? "Logging in..." : "Registering...");

      try {
        if (isLogin) {
          Response response = await _dio.post(
            ApiRouteName.login.getFullPath(),
            data: {
              'email': _emailController.text,
              'password': _passwordController.text,
            },
          );

          // ✅ Print request method & URL
          print('Request Method: ${response.requestOptions.method}');
          print('Request URL: ${response.requestOptions.uri}');

          // ✅ Print request headers
          print('Headers: ${response.requestOptions.headers}');
          print('Params: ${response.requestOptions.queryParameters}');
          print('Data: ${response.data}');
          if (response.statusCode == 200) {
            final result = response.data as Map<String, dynamic>;
            navigate(result['data']['accessToken']);
          }
        } else {
          Response response = await _dio.post(
            ApiRouteName.register.getFullPath(),
            // ---> new (API endpoint for login)
            data: {
              'username': _usernameController.text,
              'email': _emailController.text,
              'password': _passwordController.text,
            },
          );

          // ✅ Print request method & URL
          print('Request Method: ${response.requestOptions.method}');
          print('Request URL: ${response.requestOptions.uri}');

          // ✅ Print request headers
          print('Headers: ${response.requestOptions.headers}');
          print('Params: ${response.requestOptions.queryParameters}');
          print('Data: ${response.data}');

          if (response.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Registration successful"),
            ));
            setState(() {
              _usernameController.text = "";
              _passwordController.text = "";
              _emailController.text = "";
            });
            navigate('');
          }
        }
      } on DioException catch (e) {
        print('⚠️ Dio Error Occurred!');
        print('⚠️ Dio Error Occurred!: ${e.error}');
        print('⚠️ Dio Error Occurred!: ${e.stackTrace}');

        // ✅ Print HTTP status code
        print('Status Code: ${e.response?.statusCode}');
        print('Status Msg: ${e.response?.statusMessage}');

        // ✅ Print error message
        print('Error Message: ${e.message}');

        // ✅ Print request method & URL
        print('Request Method: ${e.requestOptions.method}');
        print('Request URL: ${e.requestOptions.uri}');

        // ✅ Print request headers
        print('Headers: ${e.requestOptions.headers}');

        // ✅ Print response data (if available)
        print('Response Data: ${e.response?.data}');
        Map<String, dynamic> result = e.response?.data as Map<String, dynamic>;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.response?.statusCode == 500
              ? "Opps! Something went wrong"
              : result['error']),
        ));
      } on Exception catch (e) {
        print('ERROR exception: $e');

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Opps! Something went wrong"),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
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
                  Text(
                    isLogin ? "Login Here" : "Register Here",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (!isLogin)
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "*Username is required*";
                        }
                        return null;
                      },
                    ),
                  if (!isLogin) const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "*Email is required*";
                      } else if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+")
                          .hasMatch(value)) {
                        return "*Enter a valid email*";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "*Password is required*";
                      } else if (value.length < 6) {
                        return "*Password must be at least 6 characters*";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Consumer(
                    builder: (context, ref, _) {
                      return ElevatedButton(
                          onPressed: () =>
                              _validateAndSubmit((String? accessToken) {
                                final jwtNotifier =
                                    ref.read(jwtTokenProvider.notifier);
                                if (isLogin) {
                                  jwtNotifier.updateToken(accessToken);
                                }
                                context.go(isLogin
                                    ? LinkLyticsUri.dashboard.uri
                                    : LinkLyticsUri.login.uri);
                              }),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              isLogin ? "Login" : "Register",
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ));
                    },
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: toggleForm,
                    child: Text(
                      isLogin
                          ? "Don't have an account? SignUp"
                          : "Already have an account? Login",
                      style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => context.go(LinkLyticsUri.otpLogin.uri),
                    child: Text(
                      "Try our OTP Login (PH number only)",
                      style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
