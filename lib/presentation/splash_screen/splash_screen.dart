import 'package:flutter/material.dart';
import 'package:inovest/core/app_settings/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Import SharedPreferences
import 'package:inovest/core/common/app_array.dart'; // Assuming you have some common assets
import 'package:inovest/core/common/image_assets.dart'; // Assuming you have an image for splash screen

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

 Future<void> _checkLoginStatus(BuildContext context) async {
  SecureStorage secureStorage = SecureStorage();
  
  String? token = await secureStorage.getToken();
  String? role = await secureStorage.getRole();

   print("Token: $token");
  print("Role: $role");

  if (token != null && token.isNotEmpty) {
    if (role == "INVESTOR") {
      Navigator.pushReplacementNamed(context, '/investorHome');
    } else if (role == "ENTREPRENEUR") {
      Navigator.pushReplacementNamed(context, '/entrepreneurHome');
    } else {
      Navigator.pushReplacementNamed(context, '/landing');
    }
  } else {
    Navigator.pushReplacementNamed(context, '/landing');
  }
}


  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      _checkLoginStatus(context);
    });

    return Scaffold(
      backgroundColor: AppArray().colors[0],
      body: Center(
        child: Image.asset(ImageAssets.splashScreenLogo),
      ),
    );
  }
}
