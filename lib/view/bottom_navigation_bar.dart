import 'package:eatro/controller/utils/app_colors.dart';
import 'package:eatro/controller/utils/app_styles.dart';
import 'package:eatro/view/screens/ai_suggestion_screen.dart';
import 'package:eatro/view/screens/favorites_screen.dart';
import 'package:eatro/view/screens/home_screen.dart';
import 'package:eatro/view/screens/reference_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomBottomNavigationBAR extends StatefulWidget {
  const CustomBottomNavigationBAR({super.key});

  @override
  State<CustomBottomNavigationBAR> createState() =>
      _CustomBottomNavigationBARState();
}

class _CustomBottomNavigationBARState extends State<CustomBottomNavigationBAR> {
  RxInt selectedIndex = 0.obs;
  final List<Widget>_screens=[
    HomeScreen(),
    AiSuggestionScreen(),
    FavoritesScreen(),
    ReferenceScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex.value,
          onTap: (value) {
            selectedIndex.value = value;
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.subHeadingColor,
          unselectedLabelStyle: AppTextStyles.subHeading.copyWith(
            fontSize: 14.sp,
            color: AppColors.subHeadingColor,
          ),
          selectedLabelStyle: AppTextStyles.subHeading.copyWith(
            fontSize: 14.sp,
            color: AppColors.primaryColor,
          ),
          iconSize: 3.4.h,

          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome_outlined),
              label: "Ai",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_rounded),
              label: "Favorites",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: "Reference",
            ),
          ],
        ),
        body: _screens[selectedIndex.value],
      ),
    );
  }
}
