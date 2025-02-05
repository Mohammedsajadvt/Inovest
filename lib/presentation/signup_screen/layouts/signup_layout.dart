import 'package:inovest/business_logics/checkbox/check_box_bloc.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/core/common/image_assets.dart';
import 'package:inovest/core/utils/custom_button.dart';
import 'package:inovest/core/utils/custom_text_field.dart';
import 'package:inovest/core/utils/index.dart';

class CircleLayoutSignup extends StatelessWidget {
  const CircleLayoutSignup({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

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
            bottom: 620.h,
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
              onTap: () {},
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
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                ).r,
                child: CustomTextField(
                  hintText: 'Name',
                  controller: _nameController,
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30).r,
                child: CustomTextField(hintText: 'Email',
                controller: _emailController,
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30).r,
                child: CustomTextField(hintText: 'Password',
                controller: _passwordController,
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
                  child: CustomButton(
                      title: 'Sign up',
                      backgroundColor: AppArray().colors[0],
                      textColor: AppArray().colors[1],
                      onTap: () {})),
              SizedBox(height: 10.h),
              Center(
                child: GestureDetector(
                  onTap: () {},
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
