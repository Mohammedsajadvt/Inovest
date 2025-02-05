import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/core/common/image_assets.dart';
import 'package:inovest/core/utils/custom_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppArray().colors[1],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Image.asset(
              ImageAssets.langingScreenLogo,
              color: AppArray().colors[0],
              height: 570.h,
            )),
            Padding(
              padding: EdgeInsets.only(left: 30.r, right: 30.r),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                      border: Border.all(color: Colors.black)),
                  child: Center(
                    child: Text(
                      'continue with google',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.r, right: 20.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Divider(color: Colors.black, thickness: 2.0)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.r),
                    child: Text(
                      'or',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.black, thickness: 2.0)),
                ],
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 70.r, right: 70.r),
              child: CustomButton(
                  textColor: AppArray().colors[0],
                  title: 'Login',
                  backgroundColor: AppArray().colors[1],
                  onTap: () {
                    Navigator.of(context).pushNamed('/login');
                  }),
            ),
            SizedBox(
              height: 5.h,
            ),
            Padding(
                padding: EdgeInsets.only(left: 70.r, right: 70.r),
                child: CustomButton(
                    title: 'Sign up',
                    backgroundColor: AppArray().colors[0],
                    textColor: AppArray().colors[1],
                    onTap: () {
                      Navigator.of(context).pushNamed('/signup');
                    })),
          ],
        ),
      ),
    );
  }
}
