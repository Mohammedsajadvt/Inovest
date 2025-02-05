import 'dart:math';

import 'package:inovest/business_logics/auth/auth_bloc.dart';
import 'package:inovest/business_logics/auth/auth_event.dart';
import 'package:inovest/business_logics/auth/auth_state.dart';
import 'package:inovest/business_logics/checkbox/check_box_bloc.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/core/common/image_assets.dart';
import 'package:inovest/core/utils/custom_button.dart';
import 'package:inovest/core/utils/custom_text_field.dart';
import 'package:inovest/core/utils/index.dart';
import 'package:inovest/presentation/home_screen/screens/home_screen.dart';

class CircleLayoutLogin extends StatelessWidget {
  const CircleLayoutLogin({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Positioned(
            top: -110.r,
            right: -110.r,
            child: Image.asset(
              ImageAssets.loginScreenCircle,
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
            left: 28.r,
            top: 80.r,
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 40.sp,
                color: AppArray().colors[5],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 220.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30).r,
                child: CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1, left: 246).r,
                child: GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'forgot password?',
                          style: TextStyle(
                              color: AppArray().colors[5],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30).r,
                child: CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0, left: 18).r,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<CheckBoxBloc, CheckBoxState>(
                      builder: (context, state) {
                        bool isChecked =
                            state is CheckboxToggled ? state.isChecked : false;

                        return Checkbox(
                          fillColor:
                              WidgetStatePropertyAll(AppArray().colors[5]),
                          checkColor: AppArray().colors[1],
                          value: isChecked,
                          onChanged: (_) {
                            context.read<CheckBoxBloc>().add(ToggleCheckbox());
                          },
                        );
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Keep me signed in',
                        style: TextStyle(color: AppArray().colors[5]),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 70.h),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if(state is AuthLoading){
                    return CircularProgressIndicator();
                  }
                  return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 80).r,
                      child: CustomButton(
                        title: 'Login',
                        backgroundColor: AppArray().colors[0],
                        textColor: AppArray().colors[1],
                        onTap: () {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();
                          context.read<AuthBloc>().add(
                              LoginEvent(email: email, password: password));
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                                  print(email);
                        },
                      ));
                },
              ),
              SizedBox(height: 10.h),
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Create new account',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: AppArray().colors[3],
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 145).r,
                child: Image.asset(
                  ImageAssets.login,
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
