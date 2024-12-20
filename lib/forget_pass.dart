// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:car_app/helpers/dio_helper.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'home_screen.dart';
import 'newpass_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final isvalidemail = false.obs;
  final istrueacc = false.obs;

  // bool _isPasswordVisible = false;
  TextEditingController _emailController = TextEditingController();

  bool get _isButtonEnabled {
    return _emailController.text.isNotEmpty;
  }

  String? _emailError;

  final storage = FlutterSecureStorage();

  void saveToken(String token) async {
    await storage.write(key: 'authToken', value: token);
    //await DioHelper.storage.write(key: 'refreshToken', value: refreshToken);
  }

  final emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  // final passwordRegex =RegExp(r'^\d{6}$');
  final passwordRegex =
      RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~])[A-Za-z\d!@#\$&*~]{10,}$');

  void _validate() async {
    setState(() {
      _emailError = null;
      //  _passwordError = null;
    });

    String email = _emailController.text.trim();
    // String password = _passwordController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        "Incomplete Information",
        "Please complete your info.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
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

    if (_emailError == null) {
      try {
        var response = await DioHelper.postData(
          path: 'forgot_password',
          body: {
            'email': email,
            // 'password': password,
          },
        );

        // Print full response to debug console
        debugPrint('API Response: ${response.data}');

        // Extract backend message

        String backendMessage =
            response.data['message'] ?? "No message provided by backend.";

        if (response.statusCode == 200) {
          istrueacc.value = true;
          isvalidemail.value = true;
          Get.snackbar(
            "Server Response /n Welcome ",
            backendMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );
          Get.to(HomeScreen());
        } else {
          // Display backend message in the app in case of 401
          Get.snackbar(
            "Server Response",
            backendMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );
        } // if i cannot access api
      } catch (e) {
        // Handle Dio or network errors
        debugPrint('Error occurred: $e');
        Get.snackbar(
          "Error",
          "An error occurred while logging in. Please try again later.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
    }
  }

  RxString _otpCode = ''.obs;

  Future<void> _verifyOtp() async {
    if (_otpCode.value.length != 4) {
      Get.snackbar(
        "Error",
        "Please enter a valid 4-digit code.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      var response = await DioHelper.postData(
        path: 'confirm_reset_code',
        body: {
          'token': _otpCode.value,
        },
      );

      debugPrint('API Response: ${response.data["message"]}');
      String backendMessage =
          response.data['message'] ?? "No message provided.";

      if (response.statusCode == 200) {
        var code = _otpCode.value;
        String token = response.data['token'];
        saveToken(token);
        Get.snackbar(
          "Success",
          backendMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
        Get.to(NewpassScreen(
          code: code,
        )); // Navigate to the next screen
      } else {
        Get.snackbar(
          "Error",
          backendMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error occurred: $e');
      Get.snackbar(
        "Error",
        "An error occurred while verifying the code. Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Logo
          Positioned(
            top: 50,
            left: 60,
            child: Image.asset(
              'images/smart_steer_icon.png',
              height: 250,
            ),
          ),
          // Form Section
          Positioned(
            top: 320,
            bottom: 0,
            left: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        errorText: _emailError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: ElevatedButton(
                        onPressed: _validate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          fixedSize: const Size(250, 50),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Obx(() {
                      if (istrueacc.value) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 15),
                            // Flutter OTP Text Field
                            OTPTextField(
                              length: 4, // Number of OTP digits
                              width: MediaQuery.of(context).size.width * 0.8,
                              fieldWidth: 50, // Width of each field
                              style: TextStyle(fontSize: 18),
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.box,
                              otpFieldStyle: OtpFieldStyle(
                                borderColor:
                                    Colors.blue, // Blue border for text fields
                                enabledBorderColor: Colors.blue,
                              ),
                              onChanged: (value) {
                                // Handle changes in the OTP input
                                debugPrint("Current OTP: $value");
                              },
                              onCompleted: (pin) {
                                debugPrint("Completed OTP: $pin");
                                _otpCode.value = pin; // Save the entered OTP
                              },
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: ElevatedButton(
                                onPressed: _verifyOtp, // Call API to verify OTP
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 24),
                                  fixedSize: Size(250, 50),
                                ),
                                child: Text(
                                  'Verify Code',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return SizedBox.shrink();
                    }),
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
