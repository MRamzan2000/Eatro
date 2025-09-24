import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:eatro/controller/utils/app_colors.dart';
import 'package:eatro/controller/utils/app_styles.dart';

/// ✅ Main Auth Dialog (Guest + Sign In/Up options)
class AuthOptionsDialog extends StatelessWidget {
  const AuthOptionsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      insetPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Save Your Favorites",
                  style: AppTextStyles.headingLarge.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, color: Colors.black54),
                )
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              "Choose how you'd like to save your favorite recipes",
              style: AppTextStyles.subHeading.copyWith(
                color: AppColors.hintTextColor,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(height: 2.5.h),

            /// Guest Option
            InkWell(
              onTap: () => Get.back(), // guest continue action
              child: _optionTile(
                icon: Icons.person_outline,
                iconColor: Colors.green,
                title: "Continue as Guest",
                subtitle: "Your favorites will be saved only on this device.",
              ),
            ),
            SizedBox(height: 2.h),

            /// Sign In Option
            InkWell(
              onTap: () => Get.dialog(const SignInDialog()),
              child: _optionTile(
                icon: Icons.login,
                iconColor: Colors.blueAccent,
                title: "Sign In",
                subtitle: "Already have an account? Login here.",
              ),
            ),
            SizedBox(height: 1.5.h),

            /// Sign Up Option
            InkWell(
              onTap: () => Get.dialog(const SignUpDialog()),
              child: _optionTile(
                icon: Icons.person_add_alt,
                iconColor: Colors.deepOrange,
                title: "Sign Up",
                subtitle: "Create a new account to save your favorites.",
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Reusable option tile
  Widget _optionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(14),
        color: Colors.grey.shade100,
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 26),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyles.headingMedium.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    )),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: AppTextStyles.subHeading.copyWith(
                      fontSize: 14.sp, color: AppColors.hintTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ✅ Sign In Dialog
class SignInDialog extends StatelessWidget {
  const SignInDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      insetPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Heading
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sign In",
                      style: AppTextStyles.headingLarge.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      )),
                  IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Colors.black54))
                ],
              ),
              SizedBox(height: 2.h),

              /// Google Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.withOpacity(0.4)),
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: Image.asset("assets/images/google.png", height: 22),
                  label: Text("Continue with Google",
                      style: AppTextStyles.subHeading.copyWith(
                          fontSize: 15.sp, color: Colors.black87)),
                ),
              ),
              SizedBox(height: 2.h),

              /// Email + Password
              TextField(
                decoration: InputDecoration(
                  hintText: "your@email.com",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                ),
              ),
              SizedBox(height: 1.5.h),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                  suffixIcon: const Icon(Icons.visibility_off),
                ),
              ),
              SizedBox(height: 2.h),

              /// Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 1.6.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Sign In",
                      style: AppTextStyles.headingMedium.copyWith(
                          fontSize: 16.sp, color: Colors.white)),
                ),
              ),
              SizedBox(height: 1.5.h),

              /// Forgot + Sign Up
              TextButton(
                onPressed: () {},
                child: Text("Forgot Password?",
                    style: TextStyle(
                        color: AppColors.primaryColor, fontSize: 15.sp)),
              ),
              SizedBox(height: 0.5.h),
              GestureDetector(
                onTap: () {
                  Get.back();
                  Get.dialog(const SignUpDialog());
                },
                child: Text(
                  "Don't have an account? Sign Up",
                  style: AppTextStyles.subHeading.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// ✅ Sign Up Dialog
class SignUpDialog extends StatelessWidget {
  const SignUpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      insetPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Heading
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sign Up",
                      style: AppTextStyles.headingLarge.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      )),
                  IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Colors.black54))
                ],
              ),
              SizedBox(height: 2.h),

              /// Name
              TextField(
                decoration: InputDecoration(
                  hintText: "Full Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 1.5.h, horizontal: 3.w),
                ),
              ),
              SizedBox(height: 1.5.h),

              /// Email
              TextField(
                decoration: InputDecoration(
                  hintText: "your@email.com",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 1.5.h, horizontal: 3.w),
                ),
              ),
              SizedBox(height: 1.5.h),

              /// Password
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 1.5.h, horizontal: 3.w),
                  suffixIcon: const Icon(Icons.visibility_off),
                ),
              ),
              SizedBox(height: 2.h),

              /// Sign Up Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 1.6.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Create Account",
                      style: AppTextStyles.headingMedium.copyWith(
                          fontSize: 16.sp, color: Colors.white)),
                ),
              ),
              SizedBox(height: 1.5.h),

              /// Already have account → Sign In
              GestureDetector(
                onTap: () {
                  Get.back();
                  Get.dialog(const SignInDialog());
                },
                child: Text(
                  "Already have an account? Sign In",
                  style: AppTextStyles.subHeading.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
