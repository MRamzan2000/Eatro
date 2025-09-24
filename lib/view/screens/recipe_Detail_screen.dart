import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:eatro/controller/utils/app_styles.dart';
import 'package:eatro/view/reuseable_widgets/horizontal_space.dart';
import 'package:eatro/view/reuseable_widgets/verticle_space.dart';

class RecipeDetailPage extends StatelessWidget {
  final String title;
  final String cuisine;
  final String imageUrl;

  const RecipeDetailPage({
    super.key,
    required this.title,
    required this.cuisine,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// Top Image (Fixed) using SliverAppBar
          SliverAppBar(
            pinned: true,
            expandedHeight: 28.h,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  /// Image
                  Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  /// Back button
                  Positioned(
                    top: 5.h,
                    left: 3.w,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: CircleAvatar(
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
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.share_outlined, color: Colors.black),
                        ),
                        getHorizontalSpace(width: 2.w),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.favorite_border, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Neeche ka Data (scroll hone wala)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Text(
                    title,
                    style: AppTextStyles.headingLarge.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  getVerticalSpace(height: 0.8.h),

                  Text(
                    cuisine,
                    style: AppTextStyles.subHeading.copyWith(
                      fontSize: 15.sp,
                      color: Colors.grey,
                    ),
                  ),
                  getVerticalSpace(height: 2.h),

                  /// Tags
                  Row(
                    children: [
                      _blueTag("Lunch"),
                      getHorizontalSpace(width: 2.w),
                      _blueTag("Dinner"),
                      getHorizontalSpace(width: 2.w),
                      _greenTag("Brain Boost"),
                    ],
                  ),
                  getVerticalSpace(height: 3.h),

                  /// Nutrition Facts
                  Text("Nutrition Facts",
                      style: AppTextStyles.headingLarge.copyWith(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                      )),
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
                      _nutritionBox("Calories", "350 kcal"),
                      _nutritionBox("Protein", "8 g"),
                    ],
                  ),
                  getVerticalSpace(height: 1.5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _nutritionBox("Fat", "16 g"),
                      _nutritionBox("Carbs", "44 g"),
                    ],
                  ),
                  getVerticalSpace(height: 3.h),

                  /// Ingredients
                  Text("Ingredients",
                      style: AppTextStyles.headingLarge.copyWith(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                      )),
                  getVerticalSpace(height: 1.5.h),
                  _bulletText("100 g quinoa (uncooked)"),
                  _bulletText("1 ripe avocado, sliced"),
                  _bulletText("1 tbsp olive oil"),
                  _bulletText("1 garlic clove, minced"),
                  _bulletText("Pinch of black pepper"),
                  getVerticalSpace(height: 3.h),

                  /// Instructions
                  Text("Instructions",
                      style: AppTextStyles.headingLarge.copyWith(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                      )),
                  getVerticalSpace(height: 1.5.h),
                  _stepText(1,
                      "Cook quinoa in 200 ml water until fluffy (~15 min). Cool slightly"),
                  _stepText(2,
                      "Mix quinoa with olive oil, garlic, and pepper"),
                  _stepText(3, "Arrange avocado slices on top"),
                  _stepText(4, "Serve warm or room temperature"),
                  getVerticalSpace(height: 4.h),
                ],
              ),
            ),
          ),
        ],
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
            Text(title,
                style: AppTextStyles.subHeading.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                )),
            getVerticalSpace(height: 0.5.h),
            Text(value,
                style: AppTextStyles.headingLarge.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                )),
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
          Icon(Icons.circle, size: 8, color: Colors.green),
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
              style: TextStyle(
                  color: Colors.green, fontWeight: FontWeight.bold),
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
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text,
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
    );
  }

  /// Green Tag
  Widget _greenTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text,
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
    );
  }
}
