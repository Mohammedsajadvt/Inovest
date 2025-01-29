import 'package:flutter/material.dart';
import 'package:inovest/core/common/app_array.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  const CustomTextField({
    super.key, required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: AppArray().colors[4]),
      cursorColor: AppArray().colors[5],
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppArray().colors[3]),
        enabledBorder:  UnderlineInputBorder(
          borderSide: BorderSide(color:AppArray().colors[4]),
        ),
        focusedBorder:  UnderlineInputBorder(
          borderSide: BorderSide(color: AppArray().colors[4]),
        ),
      ),
    );
  }
}
