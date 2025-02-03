import 'package:flutter/material.dart';
import 'package:inovest/core/utils/index.dart';
import 'package:inovest/presentation/splash_screen/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String landing = '/landing';
  static const String login = '/login';
  static const String signup = '/signup';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => SplashScreen(),
    landing:(context) => LandingScreen(),
    login:(context) => LoginScreen(),
    signup:(context) => SignupScreen(),
  };
}