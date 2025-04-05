import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio_flutter/linklytics/be_integration/api_route_names.dart';
import 'package:my_portfolio_flutter/routes/linklytics_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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

  void _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Process login or registration
      print("Registering...1234");

      try {
        Response response = await _dio.post(
          ApiRouteNames.register, // ---> new (API endpoint for login)
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

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Registration successful"),
          ));
          context.go(LinkLyticsUri.login.uri);
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
      } on Exception catch (e) {
        print('ERROR exception: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Center(child: _buildRegister())),
      ],
    );
  }

  Container _buildRegister() {
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
              "Register Here",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 10),
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
            ElevatedButton(
              onPressed: _validateAndSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Center(
                child: Text(
                  "Register",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => context.go('/linklytics/login/otp'),
              child: const Text(
                "Already have an account? OTP Login (PH num only)",
                style: TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => context.go('/linklytics/login'),
              child: const Text(
                "Already have an account? Login",
                style: TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Linklytics',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              _navItem("Home"),
              _navItem("About"),
              _signUpButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget _signUpButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        'SignUp',
        style: TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
