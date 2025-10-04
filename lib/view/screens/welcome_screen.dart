import 'dart:async';
import 'dart:developer';
import 'package:eatro/controller/getx_controller/auth_controller.dart';
import 'package:eatro/controller/utils/app_colors.dart';
import 'package:eatro/controller/utils/app_styles.dart';
import 'package:eatro/controller/utils/loading.dart';
import 'package:eatro/controller/utils/my_shared_pref.dart';
import 'package:eatro/view/reuseable_widgets/custom_appbar.dart';
import 'package:eatro/view/reuseable_widgets/verticle_space.dart';
import 'package:eatro/view/screens/login_screen.dart';
import 'package:eatro/view/bottom_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../reuseable_widgets/elevated_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final AuthController controller = Get.find<AuthController>();
  late Worker _loadingWorker;

  @override
  void initState() {
    super.initState();
    // Initialize loading dialog listener
    _loadingWorker = ever(controller.isLoading, (loading) {
      if (loading == true) {
        LoadingDialog.show();
      } else {
        LoadingDialog.hide();
      }
    });
  }

  @override
  void dispose() {
    _loadingWorker.dispose(); // Dispose of the ever observer
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Welcome"),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(15.px),
              child: Image.asset("assets/images/applogo.png", height: 120),
            ),
            getVerticalSpace(height: 2.h),
            Text(
              "Welcome to Eatro",
              style: AppTextStyles.headingLarge.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const Spacer(),
            // Sign In Button
            CustomElevatedButton(
              text: "Sign In",
              onPressed: () => Get.to(() => const SignInScreen()),
            ),
            getVerticalSpace(height: 1.5.h),
            // Continue as Guest Button
            CustomElevatedButton(
              text: "Continue as Guest",
              onPressed: () async {
                try {
                  await controller.continueAsGuest();
                } catch (e) {
                  if (kDebugMode) {
                    log("Guest login error: $e", name: 'WelcomeScreen');
                  }
                }
              },
            ),
            getVerticalSpace(height: 1.5.h),
            // Continue Without Account Button
            CustomElevatedButton(
              text: "Continue Without Account",
              onPressed:(){
                Get.to(()=>CustomBottomNavigationBAR());
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
