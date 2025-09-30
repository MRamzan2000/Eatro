import 'package:eatro/controller/getx_controller/auth_controller.dart';
import 'package:eatro/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'app_styles.dart';
final controller = Get.put(AuthController());

class AppSnackbar {
  // Success Snackbar
  static void showSuccess(String message) {
    _show(
      message: message,
      bgColor: Colors.green.shade600,
      icon: Icons.check_circle,
    );
  }

  // Error Snackbar
  static void showError(String message) {
    _show(
      message: message,
      bgColor: Colors.red.shade600,
      icon: Icons.error,
    );
  }

  // Common private method
  static void _show({
    required String message,
    required Color bgColor,
    required IconData icon,
  })
  {
    final messenger = rootScaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: bgColor,
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Confirmation Dialog
  static void showConfirmDialog(BuildContext context, String title, String message) {
    final bool isLogout = title == "Logout";

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        title: Text(
          title,
          style: AppTextStyles.headingLarge.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: AppTextStyles.subHeading.copyWith(
            fontSize: 15.sp,
            color: Colors.black87,
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(
          horizontal: 2.w,
          vertical: 1.h,
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade400),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 1.5.h,
              ),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Cancel",
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isLogout ? Colors.blue : Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 1.5.h,
              ),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              if (isLogout) {
                controller.logout(context: context);
              } else {
              }
            },
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
