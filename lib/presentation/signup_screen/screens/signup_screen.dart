import 'package:flutter/material.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/presentation/signup_screen/layouts/signup_layout.dart';


class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: AppArray().colors[1],
        body:CircleLayoutSignup(),
      ),
    );
  }
}