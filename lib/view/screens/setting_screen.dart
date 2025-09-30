import 'package:eatro/controller/utils/app_colors.dart';
import 'package:eatro/controller/utils/app_snackbar.dart';
import 'package:eatro/controller/utils/app_styles.dart';
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
  void urlLauncher({required String url}) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: AppColors.headingColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                urlLauncher(
                  url: "https://jollybunny.com/eatro-privacy-policy/",
                );
              },
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(Icons.privacy_tip_outlined, color: Colors.blue),
                      SizedBox(width: 8),
                      Text("Privacy Policy", style: AppTextStyles.subHeading),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                urlLauncher(url: "https://jollybunny.com/eatro-terms/");
              },
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(Icons.description_outlined, color: Colors.blue),
                      SizedBox(width: 8),
                      Text("Terms of Service", style: AppTextStyles.subHeading),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                urlLauncher(url: "https://jollybunny.com/eatro-disclaimer/");
              },
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(width: 8),
                      Text("Disclaimer", style: AppTextStyles.subHeading),
                    ],
                  ),
                ),
              ),
            ),
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
                      Icon(Icons.delete_forever_outlined, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        "Delete Account",
                        style: AppTextStyles.subHeading.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                      Icon(Icons.exit_to_app, color: Colors.blue),
                      SizedBox(width: 8),
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
