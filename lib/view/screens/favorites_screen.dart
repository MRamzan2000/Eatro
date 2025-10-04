import 'dart:developer';
import 'package:eatro/controller/getx_controller/fav_controller.dart';
import 'package:eatro/controller/getx_controller/recipe_controller.dart';
import 'package:eatro/controller/utils/app_colors.dart';
import 'package:eatro/controller/utils/app_snackbar.dart';
import 'package:eatro/controller/utils/my_shared_pref.dart';
import 'package:eatro/model/recipe_model.dart';
import 'package:eatro/view/reuseable_widgets/horizontal_space.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:eatro/controller/utils/app_styles.dart';

import 'recipe_Detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final FavoritesController favoritesController =
        Get.find<FavoritesController>();
    final RecipeController recipeController = Get.find<RecipeController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.favorite, color: Colors.red),
            SizedBox(width: 2.w),
            Text(
              "Your Favorite Recipes",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Text(
                "You have ${favoritesController.favorites.length} favorite recipes",
                style: AppTextStyles.subHeading.copyWith(
                  fontSize: 16.sp,
                  color: Colors.black54,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: Obx(() {
                if (recipeController.isLoading.value) {
                  return _buildShimmerList();
                }

                final favoriteRecipes =
                    recipeController.recipes
                        .where(
                          (recipe) =>
                              favoritesController.favorites.contains(recipe.id),
                        )
                        .toList();

                if (favoriteRecipes.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.separated(
                  itemCount: favoriteRecipes.length,
                  separatorBuilder: (_, __) => SizedBox(height: 2.h),
                  itemBuilder: (context, index) {
                    final recipe = favoriteRecipes[index];
                    return _recipeCard(
                      recipe,
                      context,
                      primaryColor,
                      favoritesController,
                    );
                  },
                );
              }),
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
                        SizedBox(height: 1.h),
                        Container(
                          height: 17.sp,
                          width: 60.w,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          height: 14.sp,
                          width: 40.w,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 2.h),
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
              Icons.favorite_border,
              size: 10.h,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 2.h),
            Text(
              'No favorite recipes yet.',
              style: AppTextStyles.headingLarge.copyWith(
                fontSize: 16.sp,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Browse Recipes',
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
  Widget _recipeCard(
    Recipe recipe,
    BuildContext context,
    Color primaryColor,
    FavoritesController favoritesController,
  ) {
    return GestureDetector(
      onTap: () async {
        try {
          await Get.to(
            () => RecipeDetailPage(
              recipe: recipe,
              isFav: favoritesController.isFavorite(recipe.id),
            ),
          );
        } catch (e) {
          if (kDebugMode) {
            log(
              "Navigation to RecipeDetail error: $e",
              name: 'FavoritesScreen',
            );
          }
          AppSnackbar.showError("Failed to view recipe details.");
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image + Heart Icon
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    recipe.image,
                    height: 22.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      if (kDebugMode) {
                        log(
                          "Image load error: $error",
                          name: 'FavoritesScreen',
                        );
                      }
                      return Container(
                        height: 22.h,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey.shade600,
                          size: 5.h,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
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
                              log("Share error: $e", name: 'FavoritesScreen');
                            }
                            AppSnackbar.showError("Failed to share recipe.");
                          }
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.share_outlined,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      getHorizontalSpace(width: 1.4.w),
                      GestureDetector(
                        onTap: () async {
                          try {
                            await favoritesController.toggleFavorite(recipe.id);
                          } catch (e) {
                            if (kDebugMode) {
                              log(
                                "Toggle favorite error: $e",
                                name: 'FavoritesScreen',
                              );
                            }
                            AppSnackbar.showError(
                              "Failed to update favorites.",
                            );
                          }
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.favorite, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// Title + Cuisine
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: AppTextStyles.headingLarge.copyWith(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    recipe.cuisine,
                    style: AppTextStyles.subHeading.copyWith(
                      fontSize: 14.sp,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 1.h),

                  /// Tags
                  Wrap(
                    spacing: 6,
                    runSpacing: -8,
                    children:
                        recipe.mealType
                            .map(
                              (tag) => Chip(
                                side: BorderSide.none,
                                label: Text(tag),
                                backgroundColor: Colors.blue.shade50,
                                labelStyle: AppTextStyles.subHeading.copyWith(
                                  color: Colors.blue,
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: -2,
                                ),
                              ),
                            )
                            .toList(),
                  ),
                  SizedBox(height: 1.5.h),

                  /// Buttons
                  Row(
                    children: [
                      /// View button (primary full width)
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await Get.to(
                                () => RecipeDetailPage(
                                  recipe: recipe,
                                  isFav: favoritesController.isFavorite(
                                    recipe.id,
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (kDebugMode) {
                                log(
                                  "Navigation to RecipeDetail error: $e",
                                  name: 'FavoritesScreen',
                                );
                              }
                              AppSnackbar.showError(
                                "Failed to view recipe details.",
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 1.4.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "View",
                            style: AppTextStyles.buttonText.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),

                      /// Remove button (smaller)
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () async {
                            try {
                              await favoritesController.toggleFavorite(
                                recipe.id,
                              );
                            } catch (e) {
                              if (kDebugMode) {
                                log(
                                  "Remove favorite error: $e",
                                  name: 'FavoritesScreen',
                                );
                              }
                              AppSnackbar.showError(
                                "Failed to remove favorite.",
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: EdgeInsets.symmetric(vertical: 1.4.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Remove",
                            style: AppTextStyles.buttonText.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      ),
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
}
