import 'package:eatro/controller/utils/app_colors.dart';
import 'package:eatro/controller/utils/app_styles.dart';
import 'package:eatro/view/reuseable_widgets/verticle_space.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReferenceScreen extends StatefulWidget {
  const ReferenceScreen({super.key});

  @override
  State<ReferenceScreen> createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends State<ReferenceScreen> {
  /// Store selected preferences
  final Set<String> selectedPreferences = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Health Goals"),
            getVerticalSpace(height: 1.h),
            _buildOptions([
              "Cardiovascular Wellness",
              "Blood Sugar Friendly",
              "Cholesterol Friendly",
              "Kidney Friendly",
              "Liver Friendly",
              "Digestive Health",
              "Gut Health",
              "Healthy Weight",
              "Lower Sodium",
              "Lower Carb",
              "High Fiber",
              "Immune Wellness",
            ]),

            getVerticalSpace(height: 2.h),
            _buildSectionTitle("Dietary Restrictions"),
            getVerticalSpace(height: 1.h),
            _buildOptions([
              "Gluten-Free",
              "Dairy-Free",
              "Nut-Free",
              "Soy-Free",
              "Egg-Free",
              "Shellfish-Free",
              "Low-Sodium",
              "Sugar-Free",
            ]),

            getVerticalSpace(height: 2.h),
            _buildSectionTitle("Favorite Cuisines"),
            getVerticalSpace(height: 1.h),
            _buildOptions([
              "Chinese",
              "Japanese",
              "Korean",
              "Vietnamese",
              "Thai",
              "Italian",
              "Global Fusion",
              "Vegetarian",
            ]),

            getVerticalSpace(height: 2.h),
            _buildSectionTitle("Meal Preferences"),
            getVerticalSpace(height: 1.h),
            _buildOptions([
              "Breakfast",
              "Lunch",
              "Dinner",
              "Romantic",
              "Birthday",
              "Party",
              "Special Occasion",
              "Dessert",
              "Staple Food",
            ]),

            getVerticalSpace(height: 3.h),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 1.8.h),
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Get.snackbar("Saved",
                      "You selected: ${selectedPreferences.join(", ")}");
                },
                child: Text(
                  "Save Preferences",
                  style: AppTextStyles.headingLarge.copyWith(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            getVerticalSpace(height: 2.h),
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedPreferences.clear();
                  });
                },
                child: Text(
                  "Cancel",
                  style: AppTextStyles.subHeading.copyWith(
                    fontSize: 15.sp,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// AppBar with logout/delete popup
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Your Preferences",
        style: AppTextStyles.headingLarge.copyWith(fontSize: 18.sp),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.headingColor,
      actions: [
        PopupMenuButton<String>(
          icon: Icon(Icons.logout, color: AppColors.headingColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) {
            if (value == "logout") {
              _showConfirmDialog(
                  context, "Logout", "Are you sure you want to logout?");
            } else if (value == "delete") {
              _showConfirmDialog(context, "Delete Account",
                  "This action cannot be undone. Delete your account?");
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: "logout",
              child: Row(
                children: [
                  Icon(Icons.exit_to_app, color: Colors.blue),
                  SizedBox(width: 8),
                  Text("Logout", style: AppTextStyles.subHeading),
                ],
              ),
            ),
            PopupMenuItem(
              value: "delete",
              child: Row(
                children: [
                  Icon(Icons.delete_forever, color: Colors.red),
                  SizedBox(width: 8),
                  Text("Delete Account",
                      style: AppTextStyles.subHeading
                          .copyWith(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Section Title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.headingLarge.copyWith(
        fontSize: 17.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.headingColor,
      ),
    );
  }

  /// Options with selectable border (no icons)
  Widget _buildOptions(List<String> options) {
    return Column(
      children: options.map((e) {
        final isSelected = selectedPreferences.contains(e);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedPreferences.remove(e);
              } else {
                selectedPreferences.add(e);
              }
            });
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.cardBgColor,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: AppColors.primaryColor, width: 1.8)
                  : null, // ✅ unselected ka koi border nahi hoga
            ),
            child: Text(
              e,
              style: AppTextStyles.subHeading.copyWith(
                fontSize: 15.sp,
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.headingColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Confirmation Dialog
  void _showConfirmDialog(BuildContext context, String title, String message) {
    final bool isLogout = title == "Logout";

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
        actionsPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade400),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
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
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              if (isLogout) {
                Get.snackbar("Logged Out", "You have been logged out successfully!");
              } else {
                Get.snackbar("Deleted", "Your account has been deleted.");
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
