import 'package:eatro/controller/utils/app_colors.dart';
import 'package:eatro/controller/utils/app_styles.dart';
import 'package:eatro/view/reuseable_widgets/horizontal_space.dart';
import 'package:eatro/view/reuseable_widgets/textfiled.dart';
import 'package:eatro/view/reuseable_widgets/verticle_space.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AiSuggestionScreen extends StatelessWidget {
  const AiSuggestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAF9F3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + Refresh
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's\nRecommendations",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.refresh, color: AppColors.primaryColor, size: 18.sp),
                        SizedBox(width: 1.w),
                        Text(
                          "Refresh",
                          style: AppTextStyles.bodyMedium.copyWith(fontSize: 16.sp,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              getVerticalSpace(height: 2.h),

              Text(
                "Curated recipes based on your preferences and health goals",
                  style: AppTextStyles.headingMedium.copyWith(
                      color: AppColors.hintTextColor,
                      fontSize: 15.sp
                  )
              ),
              getVerticalSpace(height: 2.h),

              // Recipe Cards
              _buildRecipeCard(
                "Olive Oil Lemon Salad",
                "Mediterranean",
                "Cardiovascular Wellness",
                "+1",
                "https://media.istockphoto.com/id/1466485360/photo/close-up-photo-of-man%C3%A2s-hands-adding-dressing-to-a-salad-at-home.jpg?s=612x612&w=0&k=20&c=ayWwoxN2e4RCiDRYuDiyzzCz2yZUYxFenzc3AwdL2t4=",
              ),
              _buildRecipeCard(
                "Mexican Beef Taco Bowl",
                "Mexican",
                "Cardiovascular Wellness",
                "+2",
                "https://media.istockphoto.com/id/497617405/photo/tacos-and-salsa.jpg?s=612x612&w=is&k=20&c=nYy2kqhVq0SD-K4oobTjYdjwedd6PZkacfCO4BKd1WE=",
              ),
              _buildRecipeCard(
                "Fusion Rice Bowl",
                "Korean",
                "Senior-Friendly",
                "+1",
                "https://media.istockphoto.com/id/1327107343/photo/hawaiian-style-fried-rice-with-fried-spiced-ham-and-pineapple.jpg?s=612x612&w=0&k=20&c=3glWtUwHMlpRJotoelZsNQFYSpyOuDrgNN5oFYR-b0s=",
              ),
              _buildRecipeCard(
                "Tuna Teriyaki",
                "Japanese",
                "Gut Health",
                "+1",
                "https://media.istockphoto.com/id/154962197/photo/bento-salmon-sushi.jpg?s=612x612&w=0&k=20&c=H5YsvohfERUhsgOw_z6BjCYj5qfztVbBYzm_00DgM30=",
              ),

              getVerticalSpace(height: 2.h),

              // AI Recipe Assistant
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome,
                            color: AppColors.primaryColor, size: 18.sp),
                        SizedBox(width: 2.w),
                        Text(
                          "AI Recipe Assistant",
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    getVerticalSpace(height: 1.5.h),
                    Text(
                      "You can ask me anything about recipes, dietary needs, or ingredients. For jollybunny:",
                      style: TextStyle(fontSize: 15.sp, color: Colors.black54),
                    ),
                    getVerticalSpace(height: 1.h),
                    Text("• A quick salmon dinner under 500 calories"),
                    Text("• A kid-friendly lunchbox without nuts"),
                    Text("• A warm vegetarian soup for rainy days"),
                    getVerticalSpace(height: 2.h),

                    Text(
                      "Quick suggestions:",
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w600),
                    ),
                    getVerticalSpace(height: 1.h),

                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: [
                        _chip("A quick salmon dinner under 500 calories"),
                        _chip("A kid-friendly lunchbox without nuts"),
                        _chip("A warm vegetarian soup for rainy days"),
                        _chip("Something spicy and anti-inflammatory"),
                        _chip("A Mediterranean dish for heart health"),
                        _chip("Quick breakfast with high protein"),
                      ],
                    ),
                    getVerticalSpace(height: 2.h),
                    CustomTextField(hintText: "Ask me anything! Try: 'I want Japanese food"),
                 getVerticalSpace(height: 2.h),
                    Row(
                      children: [
                        // Green "Ask" Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5EC98A), // Light green color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                            ),
                            child: const Text(
                              "Ask",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Purple Icon Button
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9C4DFF), // Purple color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(14),
                            elevation: 0,
                          ),
                          child: const Icon(
                            Icons.auto_awesome, // ✨ sparkle icon
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(String title, String cuisine, String goal,
      String plus, String imageUrl) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 20.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyles.headingMedium.copyWith(
                        color: AppColors.headingColor,
                        fontSize: 16.sp
                    )),
                getVerticalSpace(height: 0.5.h),
                Text(cuisine,
                    style: AppTextStyles.subHeading.copyWith(
                      fontSize: 15.sp,
                      color: Colors.black54,
                    ),),
                getVerticalSpace(height: 1.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 0.8.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(goal,
                          style: AppTextStyles.buttonText.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.primaryColor
                          )),
                    ),
                    getHorizontalSpace(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.8.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(plus,
                          style: TextStyle(
                              fontSize: 14.sp, color: Colors.black87)),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: AppTextStyles.subHeading.copyWith(
        fontSize: 14.sp,
        color: AppColors.primaryColor,
      ),),
    );
  }
}
