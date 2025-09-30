import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatro/controller/getx_controller/fav_controller.dart';
import 'package:eatro/controller/getx_controller/homeController.dart';
import 'package:eatro/controller/getx_controller/recipe_controller.dart';
import 'package:eatro/controller/utils/app_colors.dart';
import 'package:eatro/controller/utils/app_styles.dart';
import 'package:eatro/controller/utils/mockData.dart';
import 'package:eatro/controller/utils/search_class.dart';
import 'package:eatro/model/recipe_model.dart';
import 'package:eatro/view/reuseable_widgets/horizontal_space.dart';
import 'package:eatro/view/reuseable_widgets/textfiled.dart';
import 'package:eatro/view/reuseable_widgets/verticle_space.dart';
import 'package:eatro/view/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

import 'auth_options_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());
  final RecipeController recipeController = Get.put(RecipeController());
  final FavoritesController favoritesController = Get.put(FavoritesController());
  RxBool isFilterShow = false.obs;

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
            CustomTextField(
              hintText: "Try: Italian Dinner, Low Carb",
              prefixIcon: Icons.search_outlined,
              onChanged: (value) => homeController.searchQuery.value = value ?? '',
            ),
            getVerticalSpace(height: 1.5.h),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                          () => Container(
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
                            _buildMultiSelectDropdown(
                              "Cuisines",
                              cuisineOptions,
                              homeController.filterState.value.cuisines,
                                  (selected) => homeController.updateFilter(
                                cuisines: selected,
                              ),
                            ),
                            _buildMultiSelectDropdown(
                              "Meal Types",
                              mealTypeOptions,
                              homeController.filterState.value.mealTypes,
                                  (selected) => homeController.updateFilter(
                                mealTypes: selected,
                              ),
                            ),
                            _buildMultiSelectDropdown(
                              "Health Goals",
                              healthGoalOptions,
                              homeController.filterState.value.healthGoals,
                                  (selected) => homeController.updateFilter(
                                healthGoals: selected,
                              ),
                            ),
                            _buildLabel("⇅ Sort By"),
                            getVerticalSpace(height: 1.h),
                            Obx(() => _buildSortBox(context)),
                            getVerticalSpace(height: 1.h),
                            ElevatedButton(
                              onPressed: () {
                                homeController.resetFilters();
                                recipeController.resetFilters();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Reset Filters',
                                style: AppTextStyles.subHeading.copyWith(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                          ],
                        )
                            : _buildFilterHeading(),
                      ),
                    ),
                    getVerticalSpace(height: 2.h),
                    Obx(
                          () {
                        if (recipeController.isLoading.value) {
                          return _buildShimmerList();
                        }

                        final searchResult = SmartSearch.search(
                          recipes: recipeController.recipes,
                          searchQuery: homeController.searchQuery.value,
                          filters: homeController.filterState.value,
                        );

                        if (searchResult.filteredRecipes.isEmpty &&
                            (recipeController.errorMessage.isNotEmpty ||
                                recipeController.recipes.isEmpty)) {
                          return _buildEmptyState();
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: 2.h),
                          itemCount: searchResult.filteredRecipes.length,
                          itemBuilder: (context, index) =>
                              _buildRecipeCard(searchResult.filteredRecipes[index]),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shimmer List for Loading State
  Widget _buildShimmerList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 2.h),
      itemCount: 3,
      itemBuilder: (context, index) => Container(
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
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 22.h,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getVerticalSpace(height: 1.h),
                    Container(
                      height: 17.sp,
                      width: 60.w,
                      color: Colors.grey,
                    ),
                    getVerticalSpace(height: 1.h),
                    Container(
                      height: 14.sp,
                      width: 40.w,
                      color: Colors.grey,
                    ),
                    getVerticalSpace(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 15.sp,
                          width: 20.w,
                          color: Colors.grey,
                        ),
                        Container(
                          height: 15.sp,
                          width: 20.w,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Empty State
  Widget _buildEmptyState() {
    return SizedBox(
      height: 50.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu_outlined,
              size: 10.h,
              color: Colors.grey.shade400,
            ),
            getVerticalSpace(height: 2.h),
            Text(
              recipeController.errorMessage.value.isNotEmpty
                  ? recipeController.errorMessage.value
                  : 'No recipes found.',
              style: AppTextStyles.headingLarge.copyWith(
                fontSize: 16.sp,
                color: Colors.grey.shade600,
              ),
            ),
            getVerticalSpace(height: 2.h),
            ElevatedButton(
              onPressed: () => recipeController.fetchRecipes(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Retry',
                style: AppTextStyles.subHeading.copyWith(
                  color: Colors.white,
                  fontSize: 15.sp,
                ),
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
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              _buildRecipeImage(recipe.image),
              Positioned(
                top: 8,
                left: 8,
                child: GestureDetector(
                  onTap: () => Get.toNamed('/recipeDetail', arguments: recipe),
                  child: stackTags(recipe.mealType.join(', ')),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Share recipe
                        Share.share(
                          'Check out this recipe: ${recipe.name}\n${recipe.description}\nImage: ${recipe.imageUrl}',
                          subject: recipe.name,
                        );
                      },
                      child: _circleIcon(Icons.share_outlined),
                    ),
                    getHorizontalSpace(width: 1.4.w),
                    Obx(() => GestureDetector(
                      onTap: () => favoritesController.toggleFavorite(recipe.id),
                      child: _circleIcon(
                        favoritesController.isFavorite(recipe.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                    )),
                  ],
                ),
              ),
              Positioned(
                bottom: 1.3.h,
                left: 8,
                child: stackTags(recipe.cuisine),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getVerticalSpace(height: 1.h),
                Text(
                  recipe.name,
                  style: AppTextStyles.headingLarge.copyWith(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (recipe.healthGoals.isNotEmpty) ...[
                  getVerticalSpace(height: 1.h),
                  Text(
                    recipe.healthGoals.join(', '),
                    style: AppTextStyles.subHeading.copyWith(
                      fontSize: 14.sp,
                      color: Colors.black54,
                    ),
                  ),
                ],
                getVerticalSpace(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    greyTag(recipe.cuisine),
                    _tag(recipe.mealType.join(', ')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Recipe Image
  Widget _buildRecipeImage(String url) => ClipRRect(
    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
    child: Image.network(
      url,
      height: 22.h,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        height: 22.h,
        width: double.infinity,
        color: Colors.grey.shade300,
        child: Icon(
          Icons.broken_image,
          color: Colors.grey.shade600,
          size: 5.h,
        ),
      ),
    ),
  );

  /// Circle Icon
  Widget _circleIcon(IconData icon) => CircleAvatar(
    radius: 18,
    backgroundColor: Colors.white,
    child: Icon(icon, size: 18, color: Colors.black87),
  );

  /// Tags
  Widget _tag(String text) => _buildTag(
    text,
    AppColors.primaryColor.withOpacity(0.2),
    AppColors.primaryColor,
  );

  Widget greyTag(String text) => _buildTag(
    text,
    AppColors.hintTextColor.withOpacity(0.2),
    AppColors.primaryColor,
  );

  Widget stackTags(String text) => _buildTag(
    text,
    Colors.white,
    AppColors.primaryColor,
  );

  Widget _buildTag(String text, Color bg, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      text,
      style: AppTextStyles.headingMedium.copyWith(
        color: color,
        fontSize: 15.sp,
      ),
    ),
  );

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
      title: Text(
        "Eatro",
        style: AppTextStyles.headingLarge.copyWith(fontSize: 19.sp),
      ),
      actions: [
        StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, authSnapshot) {
            final user = authSnapshot.data;

            if (user == null) {
              return GestureDetector(
                onTap: () => Get.dialog(const AuthOptionsDialog()),
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

            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildShimmerAvatar();
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return GestureDetector(
                    onTap: () => Get.dialog(const AuthOptionsDialog()),
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

                final userData = snapshot.data!.data() as Map<String, dynamic>?;
                final profileUrl = userData?["profile"] as String? ?? "";

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfileScreen()),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.px),
                    child: profileUrl.isNotEmpty
                        ? profileUrl.startsWith("https")
                        ? CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(profileUrl),
                    )
                        : CircleAvatar(
                      radius: 18,
                      backgroundImage: FileImage(File(profileUrl)),
                    )
                        : CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  /// Shimmer Avatar
  Widget _buildShimmerAvatar() => Padding(
    padding: EdgeInsets.only(right: 15.px),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: const CircleAvatar(radius: 18, backgroundColor: Colors.grey),
    ),
  );

  /// Section Label
  Widget _buildLabel(String text) => Text(
    text,
    style: AppTextStyles.headingLarge.copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w800,
      color: AppColors.headingColor.withOpacity(0.7),
    ),
  );

  /// Filter Heading
  Widget _buildFilterHeading() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Row(
        children: [
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
          ),
        ],
      ),
      GestureDetector(
        onTap: () => isFilterShow.value = !isFilterShow.value,
        child: Icon(
          Icons.arrow_drop_down_outlined,
          size: 3.h,
          color: AppColors.headingColor.withOpacity(0.7),
        ),
      ),
    ],
  );

  /// Multi-Select Dropdown
  Widget _buildMultiSelectDropdown(
      String label,
      List<String> items,
      RxList<String> selectedItems,
      Function(List<String>) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        getVerticalSpace(height: 1.h),
        Obx(() => DropdownButtonFormField2<String>(
          key: ValueKey(selectedItems.join()),
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
            ),
          ),
          hint: Text(
            selectedItems.isEmpty ? "Select $label..." : selectedItems.join(', '),
            style: AppTextStyles.subHeading.copyWith(
              fontSize: 15.sp,
              color: selectedItems.isEmpty ? AppColors.hintTextColor : Colors.black,
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
            value: item,
            child: Row(
              children: [
                Checkbox(
                  value: selectedItems.contains(item),
                  onChanged: (bool? checked) {
                    final newSelection = List<String>.from(selectedItems);
                    if (checked == true) {
                      if (!newSelection.contains(item)) {
                        newSelection.add(item);
                      }
                    } else {
                      newSelection.remove(item);
                    }
                    selectedItems.assignAll(newSelection);
                    onChanged(newSelection);
                    Navigator.of(Get.context!).pop();
                  },
                ),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.subHeading.copyWith(fontSize: 15.sp),
                  ),
                ),
              ],
            ),
          ))
              .toList(),
          onChanged: (_) {},
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
        )),
        getVerticalSpace(height: 2.h),
      ],
    );
  }

  /// Sort Box
  Widget _buildSortBox(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await showDialog<String>(
          context: context,
          builder: (ctx) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: sortOptions
                  .map(
                    (opt) => Obx(
                      () => RadioListTile<String>(
                    value: opt['value']!,
                    groupValue: homeController.filterState.value.sortBy,
                    activeColor: Colors.black,
                    title: Text(
                      opt['label']!,
                      style: AppTextStyles.subHeading.copyWith(fontSize: 15.sp),
                    ),
                    onChanged: (val) => Navigator.pop(ctx, val),
                  ),
                ),
              )
                  .toList(),
            ),
          ),
        );
        if (result != null) {
          homeController.updateFilter(sortBy: result);
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
            Expanded(
              child: Text(
                sortOptions
                    .firstWhere(
                      (opt) => opt['value'] == homeController.filterState.value.sortBy,
                  orElse: () => {'label': 'Name (A-Z)'},
                )['label']!,
                style: AppTextStyles.subHeading.copyWith(fontSize: 15.sp),
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}