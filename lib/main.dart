import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:eatro/controller/getx_controller/auth_controller.dart';
import 'package:eatro/view/screens/splash_screen.dart';
import 'package:eatro/controller/utils/app_colors.dart';

import 'controller/utils/my_shared_pref.dart';
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.init();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBIBgj55NZynR32KYFPabXiCQ5i9DsWPTc",
      appId: "1:31803384853:android:1d94d7eff35b6b8b37da1c",
      messagingSenderId: "31803384853",
      projectId: "eatro-cd012",
    ),
  );
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          scaffoldMessengerKey: rootScaffoldMessengerKey, // 👈 set here
          title: "Eatro",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: AppColors.primaryColor,
            fontFamily: 'Roboto',
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.cardBgColor,
              elevation: 0,
              centerTitle: true,
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
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.5,
                ),
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
          home: const SplashScreen(),
        );
      },
    );
  }
}
