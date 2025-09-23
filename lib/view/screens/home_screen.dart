import 'package:eatro/controller/utils/app_colors.dart';
import 'package:eatro/controller/utils/app_styles.dart';
import 'package:eatro/view/reuseable_widgets/horizontal_space.dart';
import 'package:eatro/view/reuseable_widgets/textfiled.dart';
import 'package:eatro/view/reuseable_widgets/verticle_space.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 2.5.w,
        leadingWidth: 16.w,
        toolbarHeight: 8.h,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 0, 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13.px),
            child: Image.asset(
              "assets/images/applogo.png",
              height: 2.4.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          "Eatro",
          style: AppTextStyles.headingLarge.copyWith(fontSize: 19.sp),
        ),
        actions: [
          Text(
            "Sign In",
            style: AppTextStyles.subHeading.copyWith(fontSize: 16.sp),
          ),
        ],
        actionsPadding: EdgeInsets.only(right: 15.px),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Column(mainAxisAlignment: MainAxisAlignment.start,
          children: [

            getVerticalSpace(height: 1.5.h),
            CustomTextField(hintText: "Try: Italian Dinner, Low Carb"),
            getVerticalSpace(height: 1.5.h),
           Container(
             decoration: BoxDecoration(
               color: AppColors.cardBgColor,
               borderRadius: BorderRadius.circular(15.px),
               // border: Border.all(color:  AppColors.hintTextColor.withOpacity(0.4))
             ),
             child: Column(crossAxisAlignment: CrossAxisAlignment.start,
               children: [
               Row(crossAxisAlignment: CrossAxisAlignment.end,
                 children: [
                   Icon(Icons.filter_alt_outlined,
                   size: 2.8.h,
                   color:  AppColors.headingColor.withOpacity(0.7),),
                   getHorizontalSpace(width: 1.w),
                   Text("Filter Recipes",
                   style: AppTextStyles.headingLarge.copyWith(
                     fontSize: 17.sp,
                     fontWeight: FontWeight.w800,
                     color: AppColors.headingColor.withOpacity(0.7)
                   ),)
                 ],
               ),
               getVerticalSpace(height: 1.h),
               Text("Cuisines",style: AppTextStyles.headingLarge.copyWith(
                   fontSize: 16.sp,
                   fontWeight: FontWeight.w800,
                   color: AppColors.headingColor.withOpacity(0.7)
               ),),
                 getVerticalSpace(height: 1.h),
                 DropdownMenu(dropdownMenuEntries: [
                   // DropdownMenuEntry(value: "", label: label)
                 ])
               
             ],),
           )




          ],
        ),
      ),
    );
  }
}
