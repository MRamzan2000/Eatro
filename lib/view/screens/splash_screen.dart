import 'dart:async';
import 'dart:developer';
import 'package:eatro/controller/getx_controller/recipe_controller.dart';
import 'package:eatro/controller/utils/app_colors.dart';
import 'package:eatro/controller/utils/app_styles.dart';
import 'package:eatro/controller/utils/my_shared_pref.dart';
import 'package:eatro/view/bottom_navigation_bar.dart';
import 'package:eatro/view/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:eatro/view/reuseable_widgets/verticle_space.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final RecipeController recipeController = Get.find<RecipeController>();
  Timer? _authCheckTimer;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
    if (kDebugMode) {
      log(
        "User Login Status: ${SharedPrefHelper.isLoggedIn()}",
        name: 'SplashScreen',
      );
    }
  }

  Future<void> _checkAuthStatus() async {
    try {
      _authCheckTimer = Timer(const Duration(seconds: 2), () async {
        if (!mounted) return; // Prevent operations on disposed widget
        if (await SharedPrefHelper.isLoggedIn()) {
          await recipeController.fetchRecipes();
          Get.offAll(() => const CustomBottomNavigationBAR());
        } else {
          await SharedPrefHelper.logout();
          Get.offAll(() => const WelcomeScreen());
        }
      });
    } catch (e) {
      if (kDebugMode) {
        log("Error checking auth status: $e", name: 'SplashScreen');
      }
      if (mounted) {
        await SharedPrefHelper.logout();
        Get.offAll(() => const WelcomeScreen());
      }
    }
  }

  @override
  void dispose() {
    _authCheckTimer?.cancel(); // Cancel timer to prevent memory leaks
    super.dispose();
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
            getVerticalSpace(height: 0.7.h),
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
