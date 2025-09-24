import 'package:eatro/controller/utils/app_styles.dart';
import 'package:eatro/view/screens/recipe_Detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});

  final List<Map<String, dynamic>> favoriteRecipes = [
    {
      "title": "Avocado Quinoa Bowl",
      "cuisine": "Global Fusion",
      "image":
          "https://media.istockphoto.com/id/1292202102/photo/traditional-avocado-salad-with-quinoa.jpg?s=612x612&w=0&k=20&c=0n8UHdFUr2qQQaC7V61itpthBcqhL_wy1W5eN1DH5pk=",
      "tags": ["Lunch", "Dinner"],
    },
    {
      "title": "Bamboo Shoots Stir-Fry",
      "cuisine": "Thai",
      "image":
          "https://media.istockphoto.com/id/1096854592/photo/two-thai-women-traditionally-eating-a-selection-of-freshly-cooked-northern-thai-food-of.jpg?s=612x612&w=0&k=20&c=VeuUF-wNtAJkOfGMAosfGccuSKmBx91XhLxMMo9Ul7k=",
      "tags": ["Dinner"],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

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
            Text(
              "You have ${favoriteRecipes.length} favorite recipes",
              style: AppTextStyles.subHeading.copyWith(
                fontSize: 16.sp,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 2.h),

            /// Recipes List
            Expanded(
              child: ListView.separated(
                itemCount: favoriteRecipes.length,
                separatorBuilder: (_, __) => SizedBox(height: 2.h),
                itemBuilder: (context, index) {
                  final recipe = favoriteRecipes[index];
                  return _recipeCard(recipe, context, primaryColor);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recipeCard(
    Map<String, dynamic> recipe,
    BuildContext context,
    Color primaryColor,
  ) {
    return Container(
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
                  recipe["image"],
                  height: 22.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite, color: Colors.red),
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
                  recipe["title"],
                  style: AppTextStyles.headingLarge.copyWith(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  recipe["cuisine"],
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
                      (recipe["tags"] as List<String>)
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
                              padding: EdgeInsets.symmetric(
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
                        onPressed: () {
                          Get.to(()=>RecipeDetailPage(
                            title: recipe["title"],
                            cuisine: recipe["cuisine"],
                            imageUrl: recipe["image"],
                          ),);
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
                        onPressed: () {},
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
    );
  }
}
