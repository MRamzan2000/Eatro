import 'dart:developer';
import 'dart:io';
import 'package:eatro/controller/getx_controller/profile_controller.dart';
import 'package:eatro/controller/utils/app_colors.dart';
import 'package:eatro/controller/utils/app_snackbar.dart';
import 'package:eatro/controller/utils/app_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    controller.fetchProfile();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: AppTextStyles.headingLarge.copyWith(fontSize: 18.sp),
        ),
        centerTitle: false,
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
              Obx(() {
                final profileUrl = controller.profileUrl.value;

                ImageProvider? imageProvider;

                if (profileUrl.isNotEmpty) {
                  if (profileUrl.startsWith("https")) {
                    imageProvider = NetworkImage(profileUrl);
                  } else if (File(profileUrl).existsSync()) {
                    imageProvider = FileImage(File(profileUrl));
                  }
                }

                return CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: imageProvider,
                  // Only include error handler when imageProvider is not null
                  onBackgroundImageError: imageProvider != null
                      ? (error, stackTrace) {
                    if (kDebugMode) {
                      log("Profile image error: $error", name: 'ProfileScreen');
                    }
                  }
                      : null,
                  child: imageProvider == null
                      ? const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey,
                  )
                      : null,
                );
              }),


              SizedBox(height: 2.h),

              /// Name
              Obx(
                () =>
                    controller.isEditing.value
                        ? TextField(
                          controller: controller.nameCtrl,
                          decoration: const InputDecoration(labelText: "Name"),
                        )
                        : Text(
                          controller.name.value.isEmpty
                              ? 'No Name'
                              : controller.name.value,
                          style: AppTextStyles.headingLarge.copyWith(
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
              ),
              SizedBox(height: 1.h),

              /// Email (Read-only)
              Obx(
                () => Text(
                  controller.email.value.isEmpty
                      ? 'No Email'
                      : controller.email.value,
                  style: AppTextStyles.subHeading.copyWith(
                    fontSize: 15.sp,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: 4.h),

              /// Options
              Obx(
                () => _buildTile(
                  Icons.edit,
                  controller.isEditing.value ? "Save Profile" : "Edit Profile",
                  () async {
                    try {
                      if (controller.isEditing.value) {
                        await controller.saveProfile();
                      } else {
                        controller.toggleEditing();
                      }
                    } catch (e) {
                      if (kDebugMode) {
                        log(
                          "Edit/Save profile error: $e",
                          name: 'ProfileScreen',
                        );
                      }
                      AppSnackbar.showError("Failed to update profile.");
                    }
                  },
                ),
              ),
              _buildTile(Icons.logout, "Logout", () async {
                AppSnackbar.showConfirmDialog(
                  context,
                  "Logout",
                  "Are you sure you want to logout?",
                );
              }),
              _buildTile(Icons.delete, "Delete Account", () async {
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
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
              ),
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
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.black54,
      ),
      onTap: onTap,
    );
  }
}
