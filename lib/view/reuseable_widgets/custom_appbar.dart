import 'package:eatro/controller/utils/app_colors.dart';
import 'package:eatro/controller/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBack
          ? GestureDetector(
        onTap: () => Get.back(),
        child: Icon(Icons.arrow_back, color: AppColors.cardBorderColor),
      )
          : null,
      title: Text(
        title,
        style: AppTextStyles.headingMedium.copyWith(
          color: AppColors.cardBorderColor,
          fontSize: 18.sp,
        ),
      ),
      backgroundColor: AppColors.primaryColor,
      centerTitle: true,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(7.h);
}
