import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextTheme appTextTheme = TextTheme(
  bodyText1: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 24.sp,
  ),
  bodyText2: TextStyle(
    color: Color(0XFF9D9D9D),
    fontWeight: FontWeight.bold,
    fontSize: 14.sp,
  ),
  headline1: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 30.sp,
  ),
);

AppBarTheme appBarTheme = AppBarTheme(
  backwardsCompatibility: false,
  backgroundColor: Color(0xFFF86B6B),
  centerTitle: true,
  titleTextStyle: appTextTheme.headline1,
);
