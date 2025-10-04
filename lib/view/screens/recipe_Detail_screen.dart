import 'dart:developer';
import 'package:eatro/controller/getx_controller/fav_controller.dart';
import 'package:eatro/controller/utils/app_snackbar.dart';
import 'package:eatro/model/recipe_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:eatro/controller/utils/app_styles.dart';
import 'package:eatro/view/reuseable_widgets/horizontal_space.dart';
import 'package:eatro/view/reuseable_widgets/verticle_space.dart';
import 'package:share_plus/share_plus.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;
  final bool isFav;
  const RecipeDetailPage({
    super.key,
    required this.recipe,
    required this.isFav,
  });

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final FavoritesController favoritesController =
      Get.find<FavoritesController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 28.h,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    /// Image
                    Image.network(
                      widget.recipe.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        if (kDebugMode) {
                          log(
                            "Image load error: $error",
                            name: 'RecipeDetailPage',
                          );
                        }
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.grey.shade300,
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey.shade600,
                            size: 10.h,
                          ),
                        );
                      },
                    ),
      
                    /// Back button
                    Positioned(
                      top: 5.h,
                      left: 3.w,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.arrow_back, color: Colors.black),
                        ),
                      ),
                    ),
      
                    /// Right side icons
                    Positioned(
                      top: 5.h,
                      right: 3.w,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              try {
                                await Share.share(
                                  'Check out this recipe: ${widget.recipe.name}\n${widget.recipe.description}\nImage: ${widget.recipe.imageUrl}',
                                  subject: widget.recipe.name,
                                );
                              } catch (e) {
                                if (kDebugMode) {
                                  log(
                                    "Share error: $e",
                                    name: 'RecipeDetailPage',
                                  );
                                }
                                AppSnackbar.showError("Failed to share recipe.");
                              }
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.share_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          getHorizontalSpace(width: 2.w),
                          Obx(
                            () => GestureDetector(
                              onTap: () async {
                                try {
                                  await favoritesController.toggleFavorite(
                                    widget.recipe.id,
                                  );
                                } catch (e) {
                                  if (kDebugMode) {
                                    log(
                                      "Toggle favorite error: $e",
                                      name: 'RecipeDetailPage',
                                    );
                                  }
                                  AppSnackbar.showError(
                                    "Failed to update favorite.",
                                  );
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  favoritesController.isFavorite(widget.recipe.id)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      favoritesController.isFavorite(
                                            widget.recipe.id,
                                          )
                                          ? Colors.red
                                          : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Text(
                      widget.recipe.name,
                      style: AppTextStyles.headingLarge.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    getVerticalSpace(height: 0.8.h),
      
                    Text(
                      widget.recipe.cuisine,
                      style: AppTextStyles.subHeading.copyWith(
                        fontSize: 15.sp,
                        color: Colors.grey,
                      ),
                    ),
                    getVerticalSpace(height: 2.h),
      
                    /// Tags
                    SizedBox(
                      height: 4.h,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: widget.recipe.mealType.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 2.w),
                            child: _blueTag(widget.recipe.mealType[index]),
                          );
                        },
                      ),
                    ),
      
                    getVerticalSpace(height: 1.5.h),
                    widget.recipe.notes != null
                        ? Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10.sp),
                            border: Border.all(
                              color: Colors.amber.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              getHorizontalSpace(width: 4.w),
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.amber,
                              ),
                              getHorizontalSpace(width: 4.w),
                              Expanded(
                                child: Text(
                                  widget.recipe.notes.toString(),
                                  style: AppTextStyles.subHeading.copyWith(
                                    fontSize: 14.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        : const SizedBox.shrink(),
                    widget.recipe.notes != null
                        ? getVerticalSpace(height: 1.5.h)
                        : const SizedBox.shrink(),
      
                    SizedBox(
                      height: 4.h,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: widget.recipe.healthGoals.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 2.w),
                            child: _greenTag(widget.recipe.healthGoals[index]),
                          );
                        },
                      ),
                    ),
                    getVerticalSpace(height: 2.h),
      
                    /// Nutrition Facts
                    Text(
                      "Nutrition Facts",
                      style: AppTextStyles.headingLarge.copyWith(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    getVerticalSpace(height: 0.8.h),
                    Text(
                      "All recipes are designed for 2–3 servings. Nutrition values are calculated per serving.",
                      style: AppTextStyles.subHeading.copyWith(
                        fontSize: 14.sp,
                        color: Colors.black54,
                      ),
                    ),
                    getVerticalSpace(height: 2.h),
      
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _nutritionBox(
                          "Calories",
                          widget.recipe.calories.toString(),
                        ),
                        _nutritionBox(
                          "Protein",
                          widget.recipe.protein.toString(),
                        ),
                      ],
                    ),
                    getVerticalSpace(height: 1.5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _nutritionBox("Fat", widget.recipe.fat.toString()),
                        _nutritionBox("Carbs", widget.recipe.carbs.toString()),
                      ],
                    ),
                    getVerticalSpace(height: 3.h),
      
                    /// Ingredients
                    Text(
                      "Ingredients",
                      style: AppTextStyles.headingLarge.copyWith(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    getVerticalSpace(height: 1.5.h),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: widget.recipe.ingredients.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return _bulletText(widget.recipe.ingredients[index]);
                      },
                    ),
                    getVerticalSpace(height: 3.h),
      
                    /// Ingredients
                    Text(
                      "Instructions",
                      style: AppTextStyles.headingLarge.copyWith(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    getVerticalSpace(height: 1.5.h),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: widget.recipe.steps.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return _stepText(index + 1, widget.recipe.steps[index]);
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

  /// Reusable Nutrition Box
  Widget _nutritionBox(String title, String value) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: AppTextStyles.subHeading.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            getVerticalSpace(height: 0.5.h),
            Text(
              value,
              style: AppTextStyles.headingLarge.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Bullet Text
  Widget _bulletText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.6.h),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.green),
          getHorizontalSpace(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.subHeading.copyWith(fontSize: 15.sp),
            ),
          ),
        ],
      ),
    );
  }

  /// Step Text
  Widget _stepText(int step, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.green.shade100,
            child: Text(
              step.toString(),
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          getHorizontalSpace(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.subHeading.copyWith(fontSize: 15.sp),
            ),
          ),
        ],
      ),
    );
  }

  /// Blue Tag
  Widget _blueTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Green Tag
  Widget _greenTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
