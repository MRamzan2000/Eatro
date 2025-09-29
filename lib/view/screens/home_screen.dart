import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatro/controller/getx_controller/auth_controller.dart';
import 'package:eatro/controller/getx_controller/homeController.dart';
import 'package:eatro/controller/utils/app_colors.dart';
import 'package:eatro/controller/utils/app_styles.dart';
import 'package:eatro/view/reuseable_widgets/horizontal_space.dart';
import 'package:eatro/view/reuseable_widgets/textfiled.dart';
import 'package:eatro/view/reuseable_widgets/verticle_space.dart';
import 'package:eatro/view/screens/recipe_Detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:shimmer/shimmer.dart';

import 'auth_options_dialog.dart';


class Recipe {
  final String title;
  final String cuisine;
  final String mealType;
  final String imageUrl;
  final String? note;

  Recipe({
    required this.title,
    required this.cuisine,
    required this.mealType,
    required this.imageUrl,
    this.note,
  });
}

final List<Recipe> recipes = [
  Recipe(
    title: "Avocado Quinoa Bowl",
    cuisine: "Global Fusion",
    mealType: "Lunch, Dinner",
    imageUrl: "https://media.istockphoto.com/id/1292202102/photo/traditional-avocado-salad-with-quinoa.jpg?s=612x612&w=0&k=20&c=0n8UHdFUr2qQQaC7V61itpthBcqhL_wy1W5eN1DH5pk=",
  ),
  Recipe(
    title: "Thai Bamboo Shoots",
    cuisine: "Thai",
    mealType: "Dinner, Lunch",
    imageUrl: "https://media.istockphoto.com/id/1096854592/photo/two-thai-women-traditionally-eating-a-selection-of-freshly-cooked-northern-thai-food-of.jpg?s=612x612&w=0&k=20&c=VeuUF-wNtAJkOfGMAosfGccuSKmBx91XhLxMMo9Ul7k=",
  ),
  Recipe(
    title: "Basil Risotto",
    cuisine: "Italian",
    mealType: "Lunch, Dinner",
    note: "Contains milk (if using parmesan)",
    imageUrl: "https://media.istockphoto.com/id/1094103656/photo/risotto-with-tomatoes-fresh-herbs-and-parmesan-cheese.jpg?s=612x612&w=0&k=20&c=c8Qpv1HPeU-vTfJhL1U9k2sBogORnRbBV0eBPLdJhhc=",
  ),
  Recipe(
    title: "Chinese Stir-Fried Green Beans",
    cuisine: "Chinese",
    mealType: "Lunch, Dinner",
    note: "Contains soy",
    imageUrl: "https://media.istockphoto.com/id/675251022/photo/wok-fried-beef-mushroom-noodles.jpg?s=612x612&w=0&k=20&c=qTf3v7TFW0wYD3Q9OTFdJnDZrBpTpIrDUnIFu36gdWo=",
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());
  final authController = Get.find<AuthController>();
  RxBool isFilterShow = false.obs;

  @override
  void initState() {
    super.initState();
    authController.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getVerticalSpace(height: 1.5.h),
            const CustomTextField(
              hintText: "Try: Italian Dinner, Low Carb",
              prefixIcon: Icons.search_outlined,
            ),
            getVerticalSpace(height: 1.5.h),

            /// Filter Box
            Obx(() => Container(
              padding: EdgeInsets.all(12.px),
              decoration: BoxDecoration(
                color: AppColors.cardBgColor,
                borderRadius: BorderRadius.circular(15.px),
              ),
              child: isFilterShow.value
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterHeading(),
                  getVerticalSpace(height: 2.h),
                  _buildDropdownSection("Cuisines", controller.cuisines,
                      controller.selectedCuisine),
                  _buildDropdownSection("Meal Types",
                      controller.mealTypes, controller.selectedMeal),
                  _buildDropdownSection("Health Goals",
                      controller.healthGoals, controller.selectedHealth),
                  _buildLabel("⇅ Sort By"),
                  getVerticalSpace(height: 1.h),
                  Obx(() => _buildSortBox(context)),
                ],
              )
                  : _buildFilterHeading(),
            )),

            /// Recipes List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 2.h),
                itemCount: recipes.length,
                itemBuilder: (context, index) => _buildRecipeCard(recipes[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Dropdown Section Builder
  Widget _buildDropdownSection(
      String label, List<String> items, RxString? selectedValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        getVerticalSpace(height: 1.h),
        Obx(() => _buildDropdown(
          hint: "Select $label...",
          value: selectedValue?.value.isEmpty == true
              ? null
              : selectedValue?.value,
          items: items,
          onChanged: (val) => selectedValue?.value = val ?? '',
        )),
        getVerticalSpace(height: 2.h),
      ],
    );
  }

  /// Recipe Card
  Widget _buildRecipeCard(Recipe recipe) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image + icons
          Stack(
            children: [
              _buildRecipeImage(recipe.imageUrl),
              Positioned(
                  top: 8,
                  left: 8,
                  child: GestureDetector(
                      onTap: () => Get.to(() => RecipeDetailPage(
                        title: recipe.title,
                        cuisine: recipe.cuisine,
                        imageUrl: recipe.imageUrl,
                      )),
                      child: stackTags(recipe.mealType))),
              Positioned(
                top: 8,
                right: 8,
                child: Row(
                  children: [
                    _circleIcon(Icons.share_outlined),
                    getHorizontalSpace(width: 1.4.w),
                    _circleIcon(Icons.favorite_border),
                  ],
                ),
              ),
              Positioned(bottom: 1.3.h, left: 8, child: stackTags(recipe.cuisine)),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getVerticalSpace(height: 1.h),
                Text(
                  recipe.title,
                  style: AppTextStyles.headingLarge.copyWith(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (recipe.note != null) ...[
                  getVerticalSpace(height: 1.h),
                  Text(
                    recipe.note!,
                    style: AppTextStyles.subHeading.copyWith(
                      fontSize: 14.sp,
                      color: Colors.black54,
                    ),
                  ),
                ],
                getVerticalSpace(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [greyTag(recipe.cuisine), _tag(recipe.mealType)],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeImage(String url) => ClipRRect(
    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
    child: Image.network(url, height: 22.h, width: double.infinity, fit: BoxFit.cover),
  );

  /// Circle Icon
  Widget _circleIcon(IconData icon) => CircleAvatar(
    radius: 18,
    backgroundColor: Colors.white,
    child: Icon(icon, size: 18, color: Colors.black87),
  );

  /// Reusable Dropdown
  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField2<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
        ),
      ),
      hint: Text(hint,
          style: AppTextStyles.subHeading
              .copyWith(fontSize: 15.sp, color: AppColors.hintTextColor)),
      items: items
          .map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(item, style: AppTextStyles.subHeading.copyWith(fontSize: 15.sp)),
      ))
          .toList(),
      onChanged: onChanged,
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.4)),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  /// AppBar with User Data
  AppBar _buildAppBar() {
    return AppBar(
      titleSpacing: 2.5.w,
      leadingWidth: 16.w,
      toolbarHeight: 8.h,
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 0, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13.px),
          child: Image.asset("assets/images/applogo.png", fit: BoxFit.cover),
        ),
      ),
      title: Text("Eatro", style: AppTextStyles.headingLarge.copyWith(fontSize: 19.sp)),
      actions: [
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerAvatar(); // Loading shimmer
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return GestureDetector(
                onTap: () => Get.dialog(AuthOptionsDialog()),
                child: Padding(
                  padding: EdgeInsets.only(right: 15.px),
                  child: Text(
                    "Sign In",
                    style: AppTextStyles.headingLarge.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              );
            }

            // User data
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final profileUrl = userData["profile"] ?? "";

            return GestureDetector(
              onTap: () => print("Avatar clicked"),
              child: Padding(
                padding: EdgeInsets.only(right: 15.px),
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: (profileUrl.isNotEmpty)
                      ? FileImage(File(profileUrl)) // ✅ Real-time load
                      : const AssetImage("assets/images/avatar_placeholder.png")
                  as ImageProvider,
                ),
              ),
            );
          },
        ),
      ],

    );
  }


  Widget _buildShimmerAvatar() => Padding(
    padding: EdgeInsets.only(right: 15.px),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: const CircleAvatar(radius: 18, backgroundColor: Colors.grey),
    ),
  );

  /// Section Label
  Widget _buildLabel(String text) => Text(text,
      style: AppTextStyles.headingLarge.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.headingColor.withOpacity(0.7),
      ));

  /// Filter Heading
  Widget _buildFilterHeading() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Row(children: [
        Icon(Icons.filter_alt_outlined,
            size: 2.8.h, color: AppColors.headingColor.withOpacity(0.7)),
        getHorizontalSpace(width: 1.w),
        Text("Filter Recipes",
            style: AppTextStyles.headingLarge.copyWith(
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.headingColor.withOpacity(0.7),
            ))
      ]),
      GestureDetector(
        onTap: () => isFilterShow.value = !isFilterShow.value,
        child: Icon(Icons.arrow_drop_down_outlined,
            size: 3.h, color: AppColors.headingColor.withOpacity(0.7)),
      ),
    ],
  );

  /// Tags
  Widget _tag(String text) => _buildTag(text, AppColors.primaryColor.withOpacity(0.2), AppColors.primaryColor);
  Widget greyTag(String text) => _buildTag(text, AppColors.hintTextColor.withOpacity(0.2), AppColors.primaryColor);
  Widget stackTags(String text) => _buildTag(text, Colors.white, AppColors.primaryColor);

  Widget _buildTag(String text, Color bg, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
    child: Text(text, style: AppTextStyles.headingMedium.copyWith(color: color, fontSize: 15.sp)),
  );

  /// Sort Box
  Widget _buildSortBox(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await showDialog<String>(
          context: context,
          builder: (ctx) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: controller.sortOptions.map((opt) => Obx(() => RadioListTile<String>(
                value: opt,
                groupValue: controller.selectedSort.value,
                activeColor: Colors.black,
                title: Text(opt),
                onChanged: (val) => Navigator.pop(ctx, val),
              ))).toList(),
            ),
          ),
        );
        if (result != null) controller.selectedSort.value = result;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.swap_vert, color: Colors.black54),
            const SizedBox(width: 8),
            Expanded(child: Text(controller.selectedSort.value)),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}