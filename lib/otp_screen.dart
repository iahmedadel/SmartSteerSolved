import 'package:car_app/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller for OTP management
class OtpController extends GetxController {
  var otp = ''.obs; // Observable OTP value

  // Add digit to OTP
  void addDigit(String digit) {
    if (otp.value.length < 4) {
      otp.value += digit;
    }
  }

  // Remove last digit of OTP
  void deleteDigit() {
    if (otp.value.isNotEmpty) {
      otp.value = otp.value.substring(0, otp.value.length - 1);
    }
  }

  // Verify OTP
  void verifyOtp() {
    if (otp.value.length == 4) {
      Get.snackbar("Success", "OTP Verified Successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar("Error", "Please enter a valid 4-digit OTP",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OtpController otpController = Get.put(OtpController());

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.jpg'), // Replace this path
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                // OTP Verification Title
                const Text(
                  "OTP VERIFICATION",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Enter the OTP code sent to your mobile number",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 24),

                // OTP Input Fields using the GetX observable `otp` value
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color.fromARGB(255, 187, 186, 185),
                              width: 2),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          otpController.otp.value.length > index
                              ? otpController.otp.value[index]
                              : '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),

                // Resend OTP
                const Text(
                  "Didn't receive a OTP?",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                TextButton(
                  onPressed: () {
                    // Handle Resend OTP logic
                  },
                  child: const Text(
                    "RESEND OTP",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                // Custom Keypad

                Container(
                  height: 400,
                  width: 800,
                  margin: const EdgeInsets.fromLTRB(30, 20, 30, 50),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24), bottom: Radius.circular(24)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Keypad numbers
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.7,
                        ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          String text = index < 9
                              ? '${index + 1}'
                              : index == 9
                                  ? ''
                                  : index == 10
                                      ? '0'
                                      : '<';

                          return GestureDetector(
                            onTap: () {
                              if (index < 9 || index == 10) {
                                otpController.addDigit(
                                    index == 10 ? '0' : '${index + 1}');
                              } else if (index == 11) {
                                otpController.deleteDigit();
                              }
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 165, 163, 160),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                text,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),
                      // Verify Button
                      ElevatedButton(
                        onPressed: () {
                          otpController.verifyOtp;
                          Get.to(HomeScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Color.fromARGB(255, 175, 174, 172),
                        ),
                        child: const Text(
                          "Verify",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
