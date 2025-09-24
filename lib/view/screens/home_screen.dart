import 'dart:math';

import 'package:eatro/controller/getx_controller/homeController.dart';
import 'package:eatro/controller/utils/app_colors.dart';
import 'package:eatro/controller/utils/app_styles.dart';
import 'package:eatro/view/reuseable_widgets/horizontal_space.dart';
import 'package:eatro/view/reuseable_widgets/textfiled.dart';
import 'package:eatro/view/reuseable_widgets/verticle_space.dart';
import 'package:eatro/view/screens/auth_options_dialog.dart';
import 'package:eatro/view/screens/recipe_Detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());
  RxBool isFilterShow=false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getVerticalSpace(height: 1.5.h),
            CustomTextField(hintText: "Try: Italian Dinner, Low Carb",
            prefixIcon: Icons.search_outlined,),
            getVerticalSpace(height: 1.5.h),

            /// Filter Box
            Obx(
                ()=> Container(
                padding: EdgeInsets.all(12.px),
                decoration: BoxDecoration(
                  color: AppColors.cardBgColor,
                  borderRadius: BorderRadius.circular(15.px),
                ),
                child:isFilterShow.value? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFilterHeading(),
                    getVerticalSpace(height: 2.h),

                    /// Cuisine Dropdown
                    _buildLabel("Cuisines"),
                    getVerticalSpace(height: 1.h),
                    Obx(() => _buildDropdown(
                      hint: "Select cuisines...",
                      value: controller.selectedCuisine?.value.isEmpty == true
                          ? null
                          : controller.selectedCuisine?.value,
                      items: controller.cuisines,
                      onChanged: (val) =>
                      controller.selectedCuisine?.value = val ?? '',
                    )),
                    getVerticalSpace(height: 2.h),

                    /// Meal Types Dropdown
                    _buildLabel("Meal Types"),
                    getVerticalSpace(height: 1.h),
                    Obx(() => _buildDropdown(
                      hint: "Select meal types...",
                      value: controller.selectedMeal?.value.isEmpty == true
                          ? null
                          : controller.selectedMeal?.value,
                      items: controller.mealTypes,
                      onChanged: (val) =>
                      controller.selectedMeal?.value = val ?? '',
                    )),
                    getVerticalSpace(height: 2.h),

                    /// Health Goals Dropdown
                    _buildLabel("Health Goals"),
                    getVerticalSpace(height: 1.h),
                    Obx(() => _buildDropdown(
                      hint: "Select health goals...",
                      value: controller.selectedHealth?.value.isEmpty == true
                          ? null
                          : controller.selectedHealth?.value,
                      items: controller.healthGoals,
                      onChanged: (val) =>
                      controller.selectedHealth?.value = val ?? '',
                    )),
                    getVerticalSpace(height: 2.h),

                    /// Sort
                    _buildLabel("⇅ Sort By"),
                    getVerticalSpace(height: 1.h),
                    Obx(() => _buildSortBox(context)),
                  ],
                ):  _buildFilterHeading(),
              ),
            ),

            /// Recipes List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 2.h),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return _buildRecipeCard(recipe);
                },
              ),
            ),
          ],
        ),
      ),
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
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image + icons
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  recipe.imageUrl,
                  height: 22.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child:GestureDetector(
                    onTap: () {
                     Get.to(()=>RecipeDetailPage(
                       title: recipe.title,
                       cuisine: recipe.cuisine,
                       imageUrl: recipe.imageUrl,
                     ),);
                    },
                    child: stackTags(recipe.mealType))
              ),
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
              Positioned(
                  bottom: 1.3.h,
                  left: 8,
                  child:stackTags(recipe.cuisine)
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                getVerticalSpace(height: 1.h),
                /// Title
                Text(
                  recipe.title,
                  style: AppTextStyles.headingLarge.copyWith(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                getVerticalSpace(height: 1.h),
                if (recipe.note != null) ...[
                  SizedBox(height: 4),
                  Text(
                    recipe.note!,
                    style: AppTextStyles.subHeading.copyWith(
                      fontSize: 14.sp,
                      color: Colors.black54,
                    ),
                  ),
                ],
                getVerticalSpace(height: 2.h),


                /// Cuisine + Meal
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    greyTag(recipe.cuisine),
                    getHorizontalSpace(width: 1.4.w),
                    _tag(recipe.mealType),
                  ],
                ),
                getVerticalSpace(height: 1.h),

              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable Tag
  Widget _tag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: AppTextStyles.headingMedium.copyWith(
          color: AppColors.primaryColor,
          fontSize: 15.sp
        )
      ),
    );
  }
  Widget greyTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.hintTextColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: AppTextStyles.headingMedium.copyWith(
          color: AppColors.primaryColor,
          fontSize: 15.sp
        )
      ),
    );
  }
  Widget stackTags(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: AppTextStyles.headingMedium.copyWith(
          color: AppColors.primaryColor,
          fontSize: 15.sp
        )
      ),
    );
  }

  /// Circle Icon
  Widget _circleIcon(IconData icon) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.white,
      child: Icon(icon, size: 18, color: Colors.black87),
    );
  }

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
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.4),
          ),
        ),
      ),
      hint: Text(
        hint,
        style: AppTextStyles.subHeading.copyWith(
          fontSize: 15.sp,
          color: AppColors.hintTextColor,
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(
          item,
          style: AppTextStyles.subHeading.copyWith(fontSize: 15.sp),
        ),
      ))
          .toList(),
      onChanged: onChanged,
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.withOpacity(0.4),
          ),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  /// Sort Box
  Widget _buildSortBox(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await showDialog<String>(
          context: context,
          builder: (ctx) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: controller.sortOptions.map((opt) {
                    return Obx(() => RadioListTile<String>(
                      value: opt,
                      groupValue: controller.selectedSort.value,
                      activeColor: Colors.black,
                      title: Text(opt),
                      onChanged: (val) {
                        Navigator.pop(ctx, val);
                      },
                    ));
                  }).toList(),
                ),
              ),
            );
          },
        );

        if (result != null) {
          controller.selectedSort.value = result;
        }
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

  /// AppBar
  AppBar _buildAppBar() {
    return AppBar(
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
        GestureDetector(onTap: (){
          log(6677);
          Get.dialog(AuthOptionsDialog());
        },
          child: Text(
            "Sign In",
            style: AppTextStyles.subHeading.copyWith(fontSize: 16.sp),
          ),
        ),
      ],
      actionsPadding: EdgeInsets.only(right: 15.px),
    );
  }

  /// Section Label
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.headingLarge.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.headingColor.withOpacity(0.7),
      ),
    );
  }

  /// Filter Heading
  Widget _buildFilterHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
       Row(children: [
         Icon(
           Icons.filter_alt_outlined,
           size: 2.8.h,
           color: AppColors.headingColor.withOpacity(0.7),
         ),
         getHorizontalSpace(width: 1.w),
         Text(
           "Filter Recipes",
           style: AppTextStyles.headingLarge.copyWith(
             fontSize: 17.sp,
             fontWeight: FontWeight.w800,
             color: AppColors.headingColor.withOpacity(0.7),
           ),
         )
       ],),
        GestureDetector(
          onTap: (){
            isFilterShow.value=!isFilterShow.value;
          },
          child: Icon(
            Icons.arrow_drop_down_outlined,
            size: 3.h,
            color: AppColors.headingColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
