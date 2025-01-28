import 'package:flutter/material.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/presentation/login_screen/layouts/login_layout.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: AppArray().colors[1],
        body:CircleLayoutLogin(),
      ),
    );
  }
}