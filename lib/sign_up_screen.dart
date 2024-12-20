import 'package:car_app/helpers/dio_helper.dart';
import 'package:car_app/otp_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _firstNameError;
  String? _lastNameError;
  String? _mobileError;
  String? _date_error;
  String? _selectedGender;

  bool get _isButtonEnabled {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _birthDateController.text.isNotEmpty &&
        _firstNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _mobileController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;
  }

  final RegExp _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final RegExp _passwordRegex =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{10,}$');
  final RegExp _phoneRegex = RegExp(r'^\d{11,}$');
  bool isValidBirthDate(String input) {
    try {
      final DateTime birthDate =
          DateTime.parse(input); // Assuming input is in 'YYYY-MM-DD' format
      final DateTime now = DateTime.now();
      final int age = now.year -
          birthDate.year -
          ((now.month < birthDate.month ||
                  (now.month == birthDate.month && now.day < birthDate.day))
              ? 1
              : 0);
      return age >= 18;
    } catch (e) {
      return false; // Return false if the input is not a valid date
    }
  }

  //List<String> _usernameSuggestions = [];
  String _selectedUsername = '';

  void _signUp() async {
    // Reset errors
    setState(() {
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
      _firstNameError = null;
      _lastNameError = null;
      _mobileError = null;
      _date_error = null;
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();
    final String mobile = _mobileController.text.trim();
    final String birthDate = _birthDateController.text.trim();

    // Validate inputs
    if (firstName.isEmpty) _firstNameError = "First name cannot be empty.";
    if (lastName.isEmpty) _lastNameError = "Last name cannot be empty.";
    if (email.isEmpty || !_emailRegex.hasMatch(email)) {
      _emailError = "Please enter a valid email address.";
    }

    if (mobile.isEmpty) _mobileError = "Mobile number cannot be empty.";
    if (!_phoneRegex.hasMatch(mobile))
      _mobileError =
          "mobile number must be at lease 11 , no charachters allowed ";

    if (password.isEmpty || !_passwordRegex.hasMatch(password)) {
      _passwordError =
          "Password must be at least 10 characters, including letters, numbers, and special characters.";
    }
    if (confirmPassword.isEmpty || confirmPassword != password) {
      _confirmPasswordError = "Passwords do not match.";
    }

    if (_firstNameError != null ||
        _lastNameError != null ||
        _emailError != null ||
        _mobileError != null ||
        _passwordError != null ||
        _confirmPasswordError != null) {
      setState(() {}); // Trigger UI update
      return;
    }

    // API endpoint path
    // const String path = "register";

    // // Prepare data for the request
    // final Map<String, dynamic> data = {
    //   //"first_name": firstName,
    //   //"last_name": lastName,
    //   "name": firstName,
    //   "email": email,
    //   "phone": mobile,
    //   "password": password,
    //   //"dop": birthDate,
    //   //"gender": _selectedGender,
    // };

    // try {
    //   // Show loading indicator
    //   Get.dialog(
    //     Center(child: CircularProgressIndicator()),
    //     barrierDismissible: false,
    //   );

    //   // Send POST request using DioHelper
    //   var response = await DioHelper.postData(path: path, body: data);

    //   // Dismiss loading indicator
    //   Get.back();

    //   // Handle response
    //   if (response.data["status"] == true) {
    //     Get.snackbar(
    //       " server response: Success ",
    //       response.data['message'] //?? "Account created successfully!",
    //       ,
    //       snackPosition: SnackPosition.BOTTOM,
    //       backgroundColor: Colors.blue,
    //       colorText: Colors.white,
    //     );
    //     // Navigate to the home screen
    Get.off(OtpScreen());
    // } else {
    //   // Get.snackbar(
    //   //   " server response : Error",
    //   //   response.data['message'] ?? "An error occurred. Please try again.",
    //   //   snackPosition: SnackPosition.BOTTOM,
    //   //   backgroundColor: Colors.red,
    //   //   colorText: Colors.white,
    //   // );
    // }
    // } catch (error) {
    //   // Handle Dio or network errors
    //   Get.back();
    //   Get.snackbar(
    //     "Error",
    //     "Failed to connect to the server. Please try again.",
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //   );
    //   debugPrint(error.toString());
    // }
  }

  // void _updateUsernameSuggestions() {
  //   setState(() {
  //     String firstName = _firstNameController.text.trim();
  //     String lastName = _lastNameController.text.trim();
  //     _usernameSuggestions = [];

  //     // Create username suggestion based on first and last names
  //     if (firstName.isNotEmpty && lastName.isNotEmpty) {
  //       _usernameSuggestions.add('$firstName$lastName');
  //       _usernameSuggestions.add('$firstName.${lastName}');
  //       _usernameSuggestions.add('${lastName} $firstName');
  //     }
  //   });
  // }

  void _validateBirthDate() {
    final String input = _birthDateController.text.trim();
    if (!isValidBirthDate(input)) {
      setState(() {
        _date_error = 'You must be at least 18 years old.';
      });
    } else {
      setState(() {
        _date_error = null; // Clear the error message if valid
      });
    }
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text =
            DateFormat('yyyy-MM-dd').format(picked); // Format the date
        _date_error = null; // Clear error message on valid input
      });
      _validateBirthDate(); // Validate the birth date after selection
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      // Background image
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'), // Background image path
            fit: BoxFit.cover, // Cover the screen
          ),
        ),
      ),
      const Positioned(
        top: 70, // Adjusted position for better spacing with the bottom sheet
        left: 100,
        right: 100,
        child: Center(
          child: Text(
            'Sign Up', // Path to the icon
            style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold), // Larger size for icon
          ),
        ),
      ),
      SizedBox(height: 60),

      Positioned(
        top: 150,
        bottom: 0,
        left: 10,
        right: 10,
        child: Container(
          width: double.infinity, // Set the desired width
          height: 800,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            color: Colors.white, // White background for sign-up container
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26, // Shadow color
                blurRadius: 10, // Blur radius
                offset: Offset(0, -5), // Shadow position
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),

                // Sign Up Title

                // First Name Text Field
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    errorText: _firstNameError,
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _lastNameController,
                  onChanged: (value) {
                    // _updateUsernameSuggestions();
                  },
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    errorText: _lastNameError,
                  ),
                ),
                // Last Name Text Field with username suggestions
                // Row(
                //   children: [

                //     // Suggestions for username
                //     if (_usernameSuggestions.isNotEmpty)
                //       Container(
                //         height: 25,
                //         child: ListView.builder(
                //           scrollDirection: Axis.horizontal,
                //           itemCount: _usernameSuggestions.length,
                //           itemBuilder: (context, index) {
                //             return GestureDetector(
                //               onTap: () {
                //                 _selectedUsername = _usernameSuggestions[
                //                     index]; // Save the selected username
                //                 _usernameSuggestions
                //                     .clear(); // Clear suggestions after selection
                //                 setState(
                //                     () {}); // Update the state to reflect selection
                //               },
                //               child: Container(
                //                 margin:
                //                     EdgeInsets.symmetric(horizontal: 5),
                //                 padding: EdgeInsets.symmetric(
                //                     horizontal: 10, vertical: 3),
                //                 decoration: BoxDecoration(
                //                   color: Colors.grey[300],
                //                   borderRadius:
                //                       BorderRadius.circular(20),
                //                 ),
                //                 child: Text(
                //                   _usernameSuggestions[index],
                //                   style: TextStyle(color: Colors.black),
                //                 ),
                //               ),
                //             );
                //           },
                //         ),
                //       ),
                //   ],
                // ),
                SizedBox(height: 15),
                // Email Text Field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    errorText: _emailError,
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          errorText: _passwordError,
                          errorMaxLines: 3,
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
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          errorText: _confirmPasswordError,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                // Mobile Number Text Field
                TextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    errorText: _mobileError,
                  ),
                ),
                SizedBox(height: 15),

                // Gender Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  items: ['Male', 'Female'].map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 15),

                // Birth Date Text Field
                TextField(
                  controller: _birthDateController,
                  readOnly: true,
                  onTap: () => _selectBirthDate(context), // Open date picker
                  decoration: InputDecoration(
                      labelText: 'Birth Date',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      errorText: _date_error),
                ),
                SizedBox(height: 15),

                // Sign Up Button

                Center(
                  child: ElevatedButton(
                      onPressed: _isButtonEnabled
                          ? () {
                              _signUp();
                              //Get.to(HomeScreen());
                            }
                          : null, // Disable if _isButtonEnabled is false,
                      child: Text(
                        "Create Account",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,

                        // Full width button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        fixedSize: Size(250, 50),
                        maximumSize: Size(200, 70),
                      )),
                ),

                // Navigation to login screen
                SizedBox(height: 20),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Log In",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(LoginScreen()); // Navigate to login screen
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ]));
  }
}
