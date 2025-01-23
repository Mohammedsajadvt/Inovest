import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenUtilHelper {
  static void init(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    ScreenUtil.init(
      context,
      designSize: deviceSize,
      minTextAdapt: true,
      splitScreenMode: true,
    );
  }
}
