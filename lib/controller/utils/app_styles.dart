import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'app_colors.dart';

class AppTextStyles {
  static TextStyle headingLarge = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.headingColor,
  );

  static TextStyle headingMedium = TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.headingColor,
  );

  static TextStyle subHeading = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.subHeadingColor,
  );

  static TextStyle bodyLarge = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.headingColor,
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.headingColor,
  );

  static TextStyle bodySmall = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.hintTextColor,
  );

  static TextStyle hintText = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.hintTextColor,
  );

  static TextStyle buttonText = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
