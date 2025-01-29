import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovest/core/common/app_array.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final void Function()? onTap;
  const CustomButton({
    super.key, required this.title, required this.backgroundColor, required this.textColor, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: AppArray().colors[0])),
        child: Center(
            child: Text(
          title,
          style: TextStyle(
              color: textColor,fontSize: 16.sp, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
