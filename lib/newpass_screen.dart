// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:car_app/helpers/dio_helper.dart';

import 'home_screen.dart';

class NewpassScreen extends StatefulWidget {
  // Define the code parameter as a field
  final String code;
  const NewpassScreen({Key? key, required this.code}) : super(key: key);

  // Constructor to accept the 'code' value

  @override
  _NewpassScreenState createState() => _NewpassScreenState();
}

class _NewpassScreenState extends State<NewpassScreen> {
  // bool _isPasswordVisible = false;
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();
  bool get _isButtonEnabled {
    return _newPasswordController.text.isNotEmpty &&
        _confirmNewPasswordController.text.isNotEmpty;
  }

  String? _newPasswordError;
  String? _confirmNewPasswordError;

  final storage = FlutterSecureStorage();

  void saveToken(String token) async {
    await storage.write(key: 'authToken', value: token);
    //await DioHelper.storage.write(key: 'refreshToken', value: refreshToken);
  }

  final newpasswordRegex =
      RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~])[A-Za-z\d!@#\$&*~]{10,}$');

  void _validate() async {
    setState(() {
      _newPasswordError = null;
    });

    String newpassword = _newPasswordController.text.trim();

    if (newpassword.isEmpty) {
      Get.snackbar(
        "Incomplete Information",
        "Please enter your new password.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
      return;
    } else if (!newpasswordRegex.hasMatch(newpassword)) {
      setState(() {
        _newPasswordError =
            "Password must contain at least 10 charachters contains,special charachters,uppercase letter,numbers .";
      });
    }

    if (_newPasswordError == null) {
      try {
        var response = await DioHelper.postData(
          path: 'reset_password',
          body: {
            'newPassword': newpassword,
            'token': widget.code,
          },
        );

        // Print full response to debug console
        debugPrint('API Response: ${response.data}');

        // Extract backend message

        String backendMessage =
            response.data['message'] ?? "No message provided by backend.";

        if (response.statusCode == 200) {
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
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _newPasswordController,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        errorText: _newPasswordError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    SizedBox(height: 20),
                    TextField(
                      controller: _newPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        errorText: _confirmNewPasswordError,
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
                          'Change Password',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
