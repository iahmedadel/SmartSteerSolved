import 'package:car_app/helpers/dio_helper.dart';
import 'package:car_app/sign_up_screen.dart';
import 'package:car_app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart-Steer',
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/signup', page: () => SignUpScreen()),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
