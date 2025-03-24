import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovest/business_logics/auth/auth_bloc.dart';
import 'package:inovest/business_logics/auth/auth_event.dart';
import 'package:inovest/business_logics/auth/auth_state.dart';
import 'package:inovest/core/common/app_array.dart';

class RoleSwitchButton extends StatelessWidget {
  final String currentRole;

  const RoleSwitchButton({super.key, required this.currentRole});

  void _handleRoleSwitch(BuildContext context, String newRole) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppArray().colors[1],
          title: Text(
            'Switch Role',
            style: TextStyle(color: AppArray().colors[3]),
          ),
          content: Text(
            'Are you sure you want to switch to ${newRole.toLowerCase()} mode? The app will restart with your new role.',
            style: TextStyle(color: AppArray().colors[3]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppArray().colors[3]),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<AuthBloc>().add(SwitchRoleEvent(newRole: newRole));
              },
              child: Text(
                'Switch',
                style: TextStyle(
                  color: newRole == "INVESTOR"
                      ? AppArray().colors[0]
                      : AppArray().colors[2],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleSessionExpired(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppArray().colors[1],
          title: Text(
            'Session Expired',
            style: TextStyle(color: AppArray().colors[3]),
          ),
          content: Text(
            'Your session has expired. Please login again.',
            style: TextStyle(color: AppArray().colors[3]),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              },
              child: Text(
                'Login',
                style: TextStyle(color: AppArray().colors[0]),
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToHome(BuildContext context, String role) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      role == 'ENTREPRENEUR' ? '/entrepreneurHome' : '/investorHome',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess && state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          if (state.role != null) {
            Future.delayed(const Duration(milliseconds: 500), () {
              _navigateToHome(context, state.role!);
            });
          }
        } else if (state is AuthFailure) {
          if (state.message.contains('Session expired')) {
            _handleSessionExpired(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      },
      builder: (context, state) {
        final newRole = currentRole == "INVESTOR" ? "ENTREPRENEUR" : "INVESTOR";

        return SizedBox(
          width: double.infinity,
          height: 45.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: currentRole == "INVESTOR"
                  ? AppArray().colors[0]
                  : AppArray().colors[2],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              elevation: 2,
            ),
            onPressed: state is AuthLoading
                ? null
                : () => _handleRoleSwitch(context, newRole),
            child: state is AuthLoading
                ? SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.swap_horiz, color: Colors.white, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'Switch to ${newRole.toLowerCase()}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
