import 'package:eatro/controller/utils/app_colors.dart';
import 'package:eatro/controller/utils/app_styles.dart';
import 'package:eatro/view/screens/ai_suggestion_screen.dart';
import 'package:eatro/view/screens/favorites_screen.dart';
import 'package:eatro/view/screens/home_screen.dart';
import 'package:eatro/view/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomBottomNavigationBAR extends StatefulWidget {
  const CustomBottomNavigationBAR({super.key});

  @override
  State<CustomBottomNavigationBAR> createState() =>
      _CustomBottomNavigationBARState();
}

class _CustomBottomNavigationBARState extends State<CustomBottomNavigationBAR> {
  RxInt selectedIndex = 0.obs;
  final List<Widget> _screens = [
    HomeScreen(),
    AiSuggestionScreen(),
    FavoritesScreen(),
    SettingScreen()
  ];

  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          if (mounted) {
            setState(() {});
          }
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('BannerAd failed to load: ${error.message}');
          ad.dispose();
          if (mounted) {
            setState(() {
              _bannerAd = null;
            });
          }
        },
      ),
    );
    _bannerAd!.load();
  }

  Widget _buildBannerAd() {
    if (_bannerAd == null) return const SizedBox.shrink();
    return Container(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      alignment: Alignment.center,
      child: AdWidget(ad: _bannerAd!),
    );
  }

  void _onTabChanged(int value) {
    if (selectedIndex.value == 0) {
      _bannerAd?.dispose();
      _bannerAd = null;
    }
    selectedIndex.value = value;
    if (value == 0) {
      _loadBannerAd();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex.value,
          onTap: _onTabChanged,
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
              label: "Settings",
            ),
          ],
        ),
        body: Stack(
          children: [
            _screens[selectedIndex.value],
            if (selectedIndex.value == 0)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBannerAd(),
              ),
          ],
        ),
      ),
    );
  }
}