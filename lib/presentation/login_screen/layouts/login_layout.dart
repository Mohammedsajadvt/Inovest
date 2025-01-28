import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/core/common/image_assets.dart';

class CircleLayoutLogin extends StatefulWidget {
  const CircleLayoutLogin({super.key});

  @override
  State<CircleLayoutLogin> createState() => _CircleLayoutState();
}

class _CircleLayoutState extends State<CircleLayoutLogin> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Positioned(
            top: -100.r,
            right: -60.r,
            child: Image.asset(
              ImageAssets.signupScreenCircle1,
              color: AppArray().colors[0],
              width: 300.w,
              height: 300.h,
            ),
          ),
          
          Positioned(
            top: 20.r,
            left: 20.r,
            child: GestureDetector(
              onTap: () {},
              child: Icon(Icons.arrow_back, size: 24.sp),
            ),
          ),
          Positioned(
            left: 30,
            top: 100,
            child: Text(
              'Sign up',
              style: TextStyle(
                fontSize: 40.sp,
                color: AppArray().colors[5],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 180.h),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                ).r,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: TextStyle(color: AppArray().colors[3]),
                    enabledBorder:  UnderlineInputBorder(
                      borderSide: BorderSide(color: AppArray().colors[4]),
                    ),
                    focusedBorder:  UnderlineInputBorder(
                      borderSide: BorderSide(color:AppArray().colors[4]),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30).r,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: AppArray().colors[3]),
                    enabledBorder:  UnderlineInputBorder(
                      borderSide: BorderSide(color:AppArray().colors[4]),
                    ),
                    focusedBorder:  UnderlineInputBorder(
                      borderSide: BorderSide(color: AppArray().colors[4]),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30).r,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: AppArray().colors[3]),
                    enabledBorder:  UnderlineInputBorder(
                      borderSide: BorderSide(color: AppArray().colors[4]),
                    ),
                    focusedBorder:  UnderlineInputBorder(
                      borderSide: BorderSide(color: AppArray().colors[4]),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0, left: 18).r,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      fillColor: WidgetStatePropertyAll(AppArray().colors[5]),
                      checkColor: AppArray().colors[1],
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        'By clicking this I agree to the terms & policy',
                        style: TextStyle(color: AppArray().colors[5]),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 70.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 80).r,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: AppArray().colors[0],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                            color: AppArray().colors[1],
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                child: GestureDetector(
                  onTap: (){},
                  child: Text(
                    'Already have an account? Login',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: AppArray().colors[3],
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 145).r,
                child: Image.asset(
                  ImageAssets.signup,
                  width: 300.w,
                  height: 300.h,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
