import 'package:flutter/material.dart';
import 'package:inovest/core/common/app_array.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  TextEditingController controller;
  FormFieldValidator<String>? validator;
  CustomTextField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      style: TextStyle(color: AppArray().colors[4]),
      cursorColor: AppArray().colors[5],
      decoration: InputDecoration(
        errorBorder: InputBorder.none, 
        focusedErrorBorder: InputBorder.none,
        hintText: hintText,
        hintStyle: TextStyle(color: AppArray().colors[3]),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppArray().colors[4]),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppArray().colors[4]),
        ),
      ),
    );
  }
}
