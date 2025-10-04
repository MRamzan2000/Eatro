import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
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
import 'package:eatro/view/screens/recipe_Detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.find<HomeController>();
  final RecipeController recipeController = Get.find<RecipeController>();
  final FavoritesController favoritesController =
      Get.find<FavoritesController>();
  final TextEditingController searchController = TextEditingController();
  StreamSubscription<DocumentSnapshot>? _userStreamSubscription;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      homeController.searchQuery.value = searchController.text;
      homeController.resetToFirstPage();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _userStreamSubscription?.cancel();
    super.dispose();
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
            CustomTextField(
              hintText: "Try: Italian Dinner, Low Carb",
              controller: searchController,
              prefixIcon: Icons.search_outlined,
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
                        child:
                            homeController.isFilterShow.value
                                ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFilterHeading(),
                                    getVerticalSpace(height: 2.h),
                                    _buildMultiSelectDropdown(
                                      "Cuisines",
                                      cuisineOptions,
                                      homeController.filterState.value.cuisines,
                                      (selected) {
                                        homeController.updateFilter(
                                          cuisines: selected,
                                        );
                                        homeController.resetToFirstPage();
                                      },
                                    ),
                                    _buildMultiSelectDropdown(
                                      "Meal Types",
                                      mealTypeOptions,
                                      homeController
                                          .filterState
                                          .value
                                          .mealTypes,
                                      (selected) {
                                        homeController.updateFilter(
                                          mealTypes: selected,
                                        );
                                        homeController.resetToFirstPage();
                                      },
                                    ),
                                    _buildMultiSelectDropdown(
                                      "Health Goals",
                                      healthGoalOptions,
                                      homeController
                                          .filterState
                                          .value
                                          .healthGoals,
                                      (selected) {
                                        homeController.updateFilter(
                                          healthGoals: selected,
                                        );
                                        homeController.resetToFirstPage();
                                      },
                                    ),
                                    _buildLabel("⇅ Sort By"),
                                    getVerticalSpace(height: 1.h),
                                    Obx(() => _buildSortBox(context)),
                                    getVerticalSpace(height: 1.h),
                                    ElevatedButton(
                                      onPressed: () {
                                        homeController.resetFilters();
                                        recipeController.resetFilters();
                                        homeController.resetToFirstPage();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Reset Filters',
                                        style: AppTextStyles.subHeading
                                            .copyWith(
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
                    Obx(() {
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

                      final totalItems = searchResult.filteredRecipes.length;
                      final totalPages =
                          (totalItems / homeController.itemsPerPage).ceil();
                      final startIndex =
                          (homeController.currentPage.value - 1) *
                          homeController.itemsPerPage;
                      final endIndex = math.min(
                        startIndex + homeController.itemsPerPage,
                        totalItems,
                      );
                      final currentPageRecipes = searchResult.filteredRecipes
                          .sublist(startIndex, endIndex);

                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(top: 2.h),
                            itemCount: currentPageRecipes.length,
                            itemBuilder:
                                (context, index) =>
                                    _buildRecipeCard(currentPageRecipes[index]),
                          ),
                          _buildPagination(totalPages),
                          getVerticalSpace(height: 5.h),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination(int totalPages) {
    final currentPage = homeController.currentPage.value;
    if (totalPages <= 1) return const SizedBox();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              if (currentPage > 1) {
                homeController.goToPreviousPage();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Text(
                '< Previous',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          getHorizontalSpace(width: 2.w),
          Text(
            'Page $currentPage of $totalPages',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          getHorizontalSpace(width: 2.w),
          GestureDetector(
            onTap: () {
              if (currentPage < totalPages) {
                homeController.goToNextPage(totalPages);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Text(
                'Next >',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 2.h),
      itemCount: 3,
      itemBuilder:
          (context, index) => Container(
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
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
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
              onPressed: () async {
                try {
                  await recipeController.fetchRecipes();
                } catch (e) {
                  if (kDebugMode) {
                    log("Retry fetch recipes error: $e", name: 'HomeScreen');
                  }
                }
              },
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

  Widget _buildRecipeCard(Recipe recipe) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => RecipeDetailPage(
            recipe: recipe,
            isFav: favoritesController.isFavorite(recipe.id),
          ),
        );
      },
      child: Container(
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
                  child: stackTags(recipe.mealType.join(', ')),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          try {
                            await Share.share(
                              'Check out this recipe: ${recipe.name}\n${recipe.description}\nImage: ${recipe.imageUrl}',
                              subject: recipe.name,
                            );
                          } catch (e) {
                            if (kDebugMode) {
                              log("Share recipe error: $e", name: 'HomeScreen');
                            }
                          }
                        },
                        child: _circleIcon(
                          Icons.share_outlined,
                          Colors.black87,
                        ),
                      ),
                      getHorizontalSpace(width: 1.4.w),
                      Obx(
                        () => GestureDetector(
                          onTap: () async {
                            try {
                              favoritesController.toggleFavorite(
                                recipe.id,
                              );
                            } catch (e) {
                              if (kDebugMode) {
                                log(
                                  "Toggle favorite error: $e",
                                  name: 'HomeScreen',
                                );
                              }
                            }
                          },
                          child: _circleIcon(
                            favoritesController.isFavorite(recipe.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            favoritesController.isFavorite(recipe.id)
                                ? Colors.red
                                : Colors.black87,
                          ),
                        ),
                      ),
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
      ),
    );
  }

  Widget _buildRecipeImage(String url) => ClipRRect(
    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
    child: Image.network(
      url,
      height: 22.h,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder:
          (context, error, stackTrace) => Container(
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

  Widget _circleIcon(IconData icon, Color iconColor) => CircleAvatar(
    radius: 18,
    backgroundColor: Colors.white,
    child: Icon(icon, size: 18, color: iconColor),
  );

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

  Widget stackTags(String text) =>
      _buildTag(text, Colors.white, AppColors.primaryColor);

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

  AppBar _buildAppBar() {
    final user = FirebaseAuth.instance.currentUser;
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
        if (user != null)
          StreamBuilder<DocumentSnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(user.uid)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildShimmerAvatar();
              }
              if (snapshot.hasError) {
                if (kDebugMode)
                  log(
                    "Firestore stream error: ${snapshot.error}",
                    name: 'HomeScreen',
                  );
                return _buildDefaultAvatar();
              }

              final userData = snapshot.data?.data() as Map<String, dynamic>?;
              final profileUrl = userData?["profile"] as String? ?? "";

              return GestureDetector(
                onTap: () {
                  Get.to(() => const ProfileScreen());
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 15.px),
                  child:
                      profileUrl.isNotEmpty
                          ? profileUrl.startsWith("https")
                              ? CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(profileUrl),
                              )
                              : CircleAvatar(
                                radius: 18,
                                backgroundImage: FileImage(File(profileUrl)),
                              )
                          : _buildDefaultAvatar(),
                ),
              );
            },
          )
        else
          Padding(
            padding: EdgeInsets.only(right: 15.px),
            child: _buildDefaultAvatar(),
          ),
      ],
    );
  }

  Widget _buildDefaultAvatar() => CircleAvatar(
    radius: 18,
    backgroundColor: Colors.grey.shade300,
    child: const Icon(Icons.person, color: Colors.white),
  );

  Widget _buildShimmerAvatar() => Padding(
    padding: EdgeInsets.only(right: 15.px),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: const CircleAvatar(radius: 18, backgroundColor: Colors.grey),
    ),
  );

  Widget _buildLabel(String text) => Text(
    text,
    style: AppTextStyles.headingLarge.copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w800,
      color: AppColors.headingColor.withOpacity(0.7),
    ),
  );

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
        onTap:
            () =>
                homeController.isFilterShow.value =
                    !homeController.isFilterShow.value,
        child: Icon(
          Icons.arrow_drop_down_outlined,
          size: 3.h,
          color: AppColors.headingColor.withOpacity(0.7),
        ),
      ),
    ],
  );

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
        Obx(
          () => DropdownButtonFormField2<String>(
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
              selectedItems.isEmpty
                  ? "Select $label..."
                  : selectedItems.join(', '),
              style: AppTextStyles.subHeading.copyWith(
                fontSize: 15.sp,
                color:
                    selectedItems.isEmpty
                        ? AppColors.hintTextColor
                        : Colors.black,
              ),
            ),
            items:
                items
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Row(
                          children: [
                            Checkbox(
                              value: selectedItems.contains(item),
                              onChanged: (bool? checked) {
                                final newSelection = List<String>.from(
                                  selectedItems,
                                );
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
                                style: AppTextStyles.subHeading.copyWith(
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
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
          ),
        ),
        getVerticalSpace(height: 2.h),
      ],
    );
  }

  Widget _buildSortBox(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await showDialog<String>(
          context: context,
          builder:
              (ctx) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      sortOptions
                          .map(
                            (opt) => Obx(
                              () => RadioListTile<String>(
                                value: opt['value']!,
                                groupValue:
                                    homeController.filterState.value.sortBy,
                                activeColor: Colors.black,
                                title: Text(
                                  opt['label']!,
                                  style: AppTextStyles.subHeading.copyWith(
                                    fontSize: 15.sp,
                                  ),
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
          homeController.resetToFirstPage();
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
                sortOptions.firstWhere(
                  (opt) =>
                      opt['value'] == homeController.filterState.value.sortBy,
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
