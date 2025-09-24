import 'dart:async';

import 'package:eatro/controller/utils/app_colors.dart';
import 'package:eatro/controller/utils/app_styles.dart';
import 'package:eatro/view/bottom_navigation_bar.dart';
import 'package:eatro/view/reuseable_widgets/verticle_space.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 5), ()=>Get.off(()=>CustomBottomNavigationBAR()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 8.3.h,
              width: 17.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.px),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.px),
                child: Image.asset(
                  "assets/images/applogo.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            getVerticalSpace(height: 1.5.h),
            CupertinoActivityIndicator(
              radius: 2.h,
              color: AppColors.primaryColor,
              animating: true,
            ),
            getVerticalSpace(height: .7.h),
            Text("Loading Eatro...", style: AppTextStyles.headingLarge),

            getVerticalSpace(height: 1.h),
            Text(
              "Preparing your healthy recipes...",
              style: AppTextStyles.subHeading,
            ),
          ],
        ),
      ),
    );
  }
}
