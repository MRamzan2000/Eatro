import 'dart:io';
import 'package:eatro/controller/getx_controller/profile_controller.dart';
import 'package:eatro/controller/utils/app_colors.dart';
import 'package:eatro/controller/utils/app_snackbar.dart';
import 'package:eatro/controller/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: AppTextStyles.headingLarge.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerProfile();
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Profile Image
              Obx(() => CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: controller.profileUrl.value.isNotEmpty &&
                    !controller.profileUrl.value.startsWith("https")
                    ? FileImage(File(controller.profileUrl.value))
                    : controller.profileUrl.value.startsWith("https")
                    ? NetworkImage(controller.profileUrl.value)
                as ImageProvider
                    : null,
                child: controller.profileUrl.value.isEmpty
                    ? const Icon(Icons.person,
                    size: 50, color: Colors.grey)
                    : null,
              )),
              SizedBox(height: 2.h),

              /// Name
              Obx(() => controller.isEditing.value
                  ? TextField(
                controller: controller.nameCtrl,
                decoration: const InputDecoration(labelText: "Name"),
              )
                  : Text(
                controller.name.value,
                style: AppTextStyles.headingLarge.copyWith(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w700,
                ),
              )),
              SizedBox(height: 1.h),

              /// Email (Read-only)
              Obx(() => Text(
                controller.email.value,
                style: AppTextStyles.subHeading.copyWith(
                  fontSize: 15.sp,
                  color: Colors.black54,
                ),
              )),
              SizedBox(height: 4.h),

              /// Options
              Obx(() => _buildTile(
                Icons.edit,
                controller.isEditing.value
                    ? "Save Profile"
                    : "Edit Profile",
                    () {
                  if (controller.isEditing.value) {
                    controller.saveProfile();
                  } else {
                    controller.toggleEditing();
                  }
                },
              )),
              _buildTile(Icons.logout, "Logout", () {
                AppSnackbar.showConfirmDialog(
                  context,
                  "Logout",
                  "Are you sure you want to logout?",
                );
              }),
              _buildTile(Icons.delete, "Delete Account", () {
                AppSnackbar.showConfirmDialog(
                  context,
                  "Delete Account",
                  "This action cannot be undone. Delete your account?",
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  /// Shimmer while loading
  Widget _buildShimmerProfile() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child:
              const CircleAvatar(radius: 50, backgroundColor: Colors.grey),
            ),
            SizedBox(height: 2.h),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(height: 20, width: 120, color: Colors.grey),
            ),
            SizedBox(height: 1.h),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(height: 16, width: 180, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable Tile
  Widget _buildTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.primaryColor.withOpacity(0.1),
        child: Icon(icon, color: AppColors.primaryColor),
      ),
      title: Text(
        title,
        style: AppTextStyles.headingMedium.copyWith(fontSize: 16.sp),
      ),
      trailing: const Icon(Icons.arrow_forward_ios,
          size: 16, color: Colors.black54),
      onTap: onTap,
    );
  }
}
