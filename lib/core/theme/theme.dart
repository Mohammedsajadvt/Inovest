import 'package:flutter/material.dart';
import 'package:inovest/core/common/app_array.dart';

final ThemeData entrepreneurTheme = ThemeData(
  primaryColor: AppArray().colors[6],
  colorScheme: ColorScheme.light(
    primary: AppArray().colors[6],
    secondary: AppArray().colors[1],
  ),
  appBarTheme: AppBarTheme(
      color: AppArray().colors[6], foregroundColor: AppArray().colors[1]),
);

final ThemeData investorTheme = ThemeData(
  primaryColor: AppArray().colors[0],
  colorScheme: ColorScheme.light(
    primary: AppArray().colors[0],
    secondary: AppArray().colors[1],
  ),
  appBarTheme: AppBarTheme(
      color: AppArray().colors[0], foregroundColor: AppArray().colors[1]),
);
