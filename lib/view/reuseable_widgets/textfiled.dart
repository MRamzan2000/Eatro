import 'package:eatro/controller/utils/app_colors.dart';
import 'package:eatro/controller/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIcon, // ab optional
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      onChanged: onChanged,
      cursorColor: AppColors.primaryColor,
      cursorHeight: 2.h,
      style: AppTextStyles.subHeading,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.hintText,

        // Borders
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.px),
          borderSide: BorderSide(color: AppColors.hintTextColor.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.px),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
        ),

        // Prefix Icon agar diya ho to hi show hoga
        prefixIcon: prefixIcon != null
            ? Padding(
          padding: EdgeInsets.only(left: 2.w),
          child: Icon(
            prefixIcon,
            size: 2.6.h,
            color: AppColors.hintTextColor,
          ),
        )
            : null,

        prefixIconConstraints: prefixIcon != null
            ? const BoxConstraints(minWidth: 0, minHeight: 0)
            : null,

        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 1.6.h, horizontal: 2.w),
      ),
    );
  }
}
