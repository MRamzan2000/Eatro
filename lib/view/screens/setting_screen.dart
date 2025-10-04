import 'dart:developer';
import 'package:eatro/controller/utils/app_snackbar.dart';
import 'package:eatro/controller/utils/app_styles.dart';
import 'package:eatro/view/reuseable_widgets/custom_appbar.dart';
import 'package:eatro/view/reuseable_widgets/verticle_space.dart';
import 'package:eatro/view/screens/reference_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Future<void> urlLauncher({required String url}) async {
    try {
      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) {
        if (kDebugMode) {
          log("Failed to launch URL: $url", name: 'SettingScreen');
        }
        AppSnackbar.showError("Could not open $url");
      }
    } catch (e) {
      if (kDebugMode) log("Error launching URL: $e", name: 'SettingScreen');
      AppSnackbar.showError("Error opening link");
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: CustomAppBar(title: "Settings", showBack: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Column(
          children: [
            getVerticalSpace(height: 3.h),

            // Privacy Policy
            GestureDetector(
              onTap: () => urlLauncher(
                url: "https://jollybunny.com/eatro-privacy-policy/",
              ),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.privacy_tip_outlined, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text("Privacy Policy", style: AppTextStyles.subHeading),
                    ],
                  ),
                ),
              ),
            ),

            // Terms of Service
            GestureDetector(
              onTap: () => urlLauncher(
                url: "https://jollybunny.com/eatro-terms/",
              ),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.description_outlined, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text("Terms of Service", style: AppTextStyles.subHeading),
                    ],
                  ),
                ),
              ),
            ),

            // Disclaimer
            GestureDetector(
              onTap: () => urlLauncher(
                url: "https://jollybunny.com/eatro-disclaimer/",
              ),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text("Disclaimer", style: AppTextStyles.subHeading),
                    ],
                  ),
                ),
              ),
            ),

            // Add Preferences
            GestureDetector(
              onTap: () async {
                try {
                  await Get.to(() => const ReferenceScreen());
                } catch (e) {
                  if (kDebugMode) {
                    log("Navigation to ReferenceScreen error: $e", name: 'SettingScreen');
                  }
                  AppSnackbar.showError("Failed to open preferences.");
                }
              },
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.add, color: Colors.blue, weight: 100),
                      const SizedBox(width: 8),
                      Text("Add Preferences", style: AppTextStyles.subHeading),
                    ],
                  ),
                ),
              ),
            ),

            // ✅ Delete Account -> Only show if user is NOT anonymous and logged in
            if (currentUser != null && !currentUser.isAnonymous)
              GestureDetector(
                onTap: () {
                  AppSnackbar.showConfirmDialog(
                    context,
                    "Delete Account",
                    "This action cannot be undone. Delete your account?",
                  );
                },
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        const Icon(Icons.delete_forever_outlined, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          "Delete Account",
                          style: AppTextStyles.subHeading.copyWith(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Logout (always show)
            GestureDetector(
              onTap: () {
                AppSnackbar.showConfirmDialog(
                  context,
                  "Logout",
                  "Are you sure you want to logout?",
                );
              },
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.exit_to_app, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text("Logout", style: AppTextStyles.subHeading),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
