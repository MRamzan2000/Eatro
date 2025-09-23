import 'package:eatro/view/screens/home_screen.dart';
import 'package:eatro/view/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'controller/utils/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          title: "Eatro",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // scaffoldBackgroundColor: AppColors.secondaryColor,
            primaryColor: AppColors.primaryColor,
            fontFamily: 'Roboto',

            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.cardBgColor,
              elevation: 0,
              titleTextStyle: TextStyle(
                color: AppColors.headingColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              iconTheme: IconThemeData(color: AppColors.primaryColor),
            ),

            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: AppColors.cardBgColor,
              hintStyle: TextStyle(
                color: AppColors.hintTextColor,
                fontSize: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.filterBorderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            textTheme: TextTheme(
              titleLarge: TextStyle(
                color: AppColors.headingColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              bodyMedium: TextStyle(
                color: AppColors.subHeadingColor,
                fontSize: 14,
              ),
            ),

            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: AppColors.cardBgColor,
              selectedItemColor: AppColors.activeBottomBarColor,
              unselectedItemColor: AppColors.inActiveBottomBarColor,
              showUnselectedLabels: true,
            ),

            chipTheme: ChipThemeData(
              backgroundColor: AppColors.secondaryColor,
              labelStyle: TextStyle(color: AppColors.healthTagsColor),
              selectedColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          home: SplashScreen(),
        );
      },
    );
  }
}
