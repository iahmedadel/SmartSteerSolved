import 'package:car_app/emergency_screen.dart';
import 'package:car_app/forget_pass.dart';
import 'package:car_app/home_screen.dart';
import 'package:car_app/login_screen.dart';
import 'package:car_app/otp_screen.dart';
import 'package:car_app/settings_screen.dart';
import 'package:car_app/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 4), // Duration of the animation
      vsync: this,
    );

    // Initialize animation with no movement initially
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
    );

    // Start the icon animation after a brief delay to display the background and icon together initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        final height = MediaQuery.of(context).size.height;

        // Set up the upward movement animation for the icon
        _animation = Tween<double>(begin: 0, end: -height * 0.3).animate(
          CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
        )..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              // Navigate to login screen after animation completes
              Get.to(LoginScreen());
            }
          });

        _controller!.forward(); // Start the animation
      });
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'images/background.jpg'), // Background image path
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
          ),
          // Icon with animation
          Center(
            child: AnimatedBuilder(
              animation: _animation!,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _animation!.value), // Moves the icon upward
                  child: Opacity(
                    opacity: 1 -
                        (_animation!.value /
                            -MediaQuery.of(context).size.height),
                    child: Image.asset(
                      'images/smart_steer_icon.png', // Icon image path
                      width: 200, // Icon width
                      height: 200, // Icon height
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
