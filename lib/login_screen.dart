import 'dart:developer';

import 'package:car_app/forget_pass.dart';
import 'package:car_app/helpers/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final storage = FlutterSecureStorage();

  void saveToken(String token) async {
    await storage.write(key: 'authToken', value: token);
    //await DioHelper.storage.write(key: 'refreshToken', value: refreshToken);
  }

//////////////////////////////////////////////////
  final isinvalidpass = false.obs;
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get _isButtonEnabled {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  void mylogin() {
    // Your login logic here
    log('Logging in with email: ${_emailController.text} and password: ${_passwordController.text}');
  }

  String? _emailError;
  String? _passwordError;

  final emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  // final passwordRegex =RegExp(r'^\d{6}$');
  final passwordRegex =
      RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~])[A-Za-z\d!@#\$&*~]{10,}$');

  void _login() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty && password.isEmpty) {
      Get.snackbar(
        "Incomplete Information",
        "Please complete your info.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (email.isEmpty) {
      setState(() {
        _emailError = "Please enter a valid email address.";
      });
    } else if (!emailRegex.hasMatch(email)) {
      setState(() {
        _emailError = "Please enter a valid email address.";
      });
    }

    if (password.isEmpty) {
      setState(() {
        _passwordError = "Incorrect Password.";
      });
    } else if (!passwordRegex.hasMatch(password)) {
      setState(() {
        _passwordError =
            "Password must contain at least 10 charachters contains,special charachters,uppercase letter,numbers .";
      });
    }

    if (_emailError == null && _passwordError == null) {
      // try {
      //   var response = await DioHelper.postData(
      //     path: 'login',
      //     body: {
      //       'email': email,
      //       'password': password,
      //     },
      //   );

      //   // Print full response to debug console
      //   debugPrint('API Response: ${response.data}');

      //   // Extract backend message

      //   String backendMessage =
      //       response.data['message'] ?? "No message provided by backend.";
      //   if (response.data['message'] == "Invalid password.") {
      //     isinvalidpass.value = true;
      //   }
      //   if (response.statusCode == 200) {
      //     String token = response.data['token'];
      //     saveToken(token);
      //     Get.snackbar(
      //       "Server Response: , Welcome ",
      //       backendMessage,
      //       snackPosition: SnackPosition.BOTTOM,
      //       backgroundColor: Colors.blue,
      //       colorText: Colors.white,
      //       duration: const Duration(seconds: 2),
      //     );
      Get.to(const HomeScreen());
      //       } else {
      //         // Display backend message in the app in case of 401
      //         Get.snackbar(
      //           "Server Response",
      //           backendMessage,
      //           snackPosition: SnackPosition.BOTTOM,
      //           backgroundColor: Colors.blue,
      //           colorText: Colors.white,
      //           duration: const Duration(seconds: 2),
      //         );
      //       } // if i cannot access api
      //     } catch (e) {
      //       // Handle Dio or network errors
      //       debugPrint('Error occurred: $e');
      //       Get.snackbar(
      //         "Error",
      //         "An error occurred while logging in. Please try again later.",
      //         snackPosition: SnackPosition.BOTTOM,
      //         backgroundColor: Colors.red,
      //         colorText: Colors.white,
      //         duration: const Duration(seconds: 2),
      //       );
      //     }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'images/background.jpg'), // Background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top:
                50, // Adjusted position for better spacing with the bottom sheet
            left: 60, // Center icon
            child: Image.asset(
              'images/smart_steer_icon.png', // Path to the icon
              height: 250, // Larger size for icon
            ),
          ),
          // Stack(
          //   children: [],
          // ),
          Positioned(
            top: 320, // Lowered bottom sheet for more icon space
            bottom: 0,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      onChanged: (value) {
                        setState(() {}); // Rebuild to check button state
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    if (_emailError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _emailError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      onChanged: (value) {
                        setState(() {}); // Rebuild to check button state
                      },
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    if (_passwordError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _passwordError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Obx(() {
                          if (isinvalidpass.value == true) {
                            return GestureDetector(
                              onTap: () {
                                // Handle forget password action
                                Get.to(ForgotPasswordScreen());
                              },
                              child: const Text(
                                "Forget Password?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(207, 4, 120, 214),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            );
                          }
                          // Return an empty widget when the condition is false
                          return const SizedBox.shrink();
                        }),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: _isButtonEnabled
                            ? () {
                                // Call your login logic here
                                // Get.to(HomeScreen());
                                _login();
                                // Navigate to the HomeScreen after a successful login
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                          fixedSize: const Size(250, 50),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/signup');
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
