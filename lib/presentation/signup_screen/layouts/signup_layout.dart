import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovest/business_logics/auth/auth_bloc.dart';
import 'package:inovest/business_logics/auth/auth_event.dart';
import 'package:inovest/business_logics/auth/auth_state.dart';
import 'package:inovest/business_logics/checkbox/check_box_bloc.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/core/common/image_assets.dart';
import 'package:inovest/core/utils/custom_button.dart';
import 'package:inovest/core/utils/custom_text_field.dart';

class CircleLayoutSignup extends StatefulWidget {
  const CircleLayoutSignup({super.key});

  @override
  State<CircleLayoutSignup> createState() => _CircleLayoutSignupState();
}

class _CircleLayoutSignupState extends State<CircleLayoutSignup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final List<String> roles = ['INVESTOR', 'ENTREPRENEUR'];
  String? selectedRole;

  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

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
            bottom: 650.h,
            right: 25.w,
            child: Image.asset(
              ImageAssets.signupScreenCircle2,
              color: AppArray().colors[0],
              width: 150.w,
              height: 150.h,
            ),
          ),
          Positioned(
            top: 20.r,
            left: 20.r,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back, size: 24.sp),
            ),
          ),
          Positioned(
            left: 30.r,
            top: 100.r,
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
                padding: const EdgeInsets.symmetric(horizontal: 30).r,
                child: Form(
                  key: _signupFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        hintText: 'Name',
                        controller: _nameController,
                      ),
                      SizedBox(height: 10.h),
                      CustomTextField(
                        hintText: 'Email',
                        controller: _emailController,
                      ),
                      SizedBox(height: 10.h),
                      CustomTextField(
                        hintText: 'Password',
                        controller: _passwordController,
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField<String>(
                          value: selectedRole,
                          icon: const Icon(Icons.arrow_drop_down),
                          hint: Text(
                            'Please Select Your Role',
                            style: TextStyle(color: AppArray().colors[3]),
                          ),
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppArray().colors[5]),
                            ),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              selectedRole = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a role';
                            }
                            return null;
                          },
                          items: roles
                              .map<DropdownMenuItem<String>>((String role) {
                            return DropdownMenuItem<String>(
                              value: role,
                              child: Text(role),
                            );
                          }).toList(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BlocBuilder<CheckBoxBloc, CheckBoxState>(
                            builder: (context, state) {
                              bool isChecked = state is CheckboxToggled
                                  ? state.isChecked
                                  : false;
                              return Checkbox(
                                fillColor: WidgetStatePropertyAll(
                                    AppArray().colors[5]),
                                checkColor: AppArray().colors[1],
                                value: isChecked,
                                onChanged: (_) {
                                  context
                                      .read<CheckBoxBloc>()
                                      .add(ToggleCheckbox());
                                },
                              );
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
                      SizedBox(height: 40.h),
                      BlocListener<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is AuthFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    state.message), // Shows failure message
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else if (state is AuthSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message.toString()),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Future.delayed(Duration(seconds: 1), () {
                              Navigator.pushNamed(context, '/login');
                            });
                          }
                        },
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is AuthLoading) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return CustomButton(
                              backgroundColor: AppArray().colors[0],
                              textColor: AppArray().colors[1],
                              title: 'Sign up',
                              onTap: () {
                                if (_signupFormKey.currentState?.validate() ??
                                    false) {
                                  context.read<AuthBloc>().add(SignUpEvent(
                                        email: _emailController.text.trim(),
                                        password:
                                            _passwordController.text.trim(),
                                        name: _nameController.text.trim(),
                                        role: selectedRole!,
                                      ));
                                }
                              },
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 10.h),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/login');
                          },
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
                      // Signup Image
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
