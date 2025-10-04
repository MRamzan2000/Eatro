import 'dart:developer';
import 'package:eatro/controller/getx_controller/auth_controller.dart';
import 'package:eatro/controller/getx_controller/recipe_controller.dart';
import 'package:eatro/controller/utils/app_colors.dart';
import 'package:eatro/controller/utils/app_snackbar.dart';
import 'package:eatro/view/reuseable_widgets/custom_appbar.dart';
import 'package:eatro/view/reuseable_widgets/elevated_button.dart';
import 'package:eatro/view/reuseable_widgets/textfiled.dart';
import 'package:eatro/view/reuseable_widgets/verticle_space.dart';
import 'package:eatro/view/screens/forgot_password_screen.dart';
import 'package:eatro/view/screens/signup_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthController controller = Get.find<AuthController>();
  final RecipeController recipeController = Get.find<RecipeController>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Sign In"),
      body: Obx(
        () =>
            controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        getVerticalSpace(height: 3.h),
                        Icon(
                          Icons.lock_person_outlined,
                          size: 22.h,
                          color: AppColors.primaryColor,
                        ),
                        getVerticalSpace(height: 6.h),
                        CustomTextField(
                          hintText: "Email",
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          onChanged:
                              (value) => controller.errorMessage.value = "",
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          hintText: "Password",
                          controller: passwordController,
                          obscureText: true,
                          prefixIcon: Icons.lock_outline,
                          onChanged:
                              (value) => controller.errorMessage.value = "",
                        ),
                        if (controller.errorMessage.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              controller.errorMessage.value,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        getVerticalSpace(height: 1.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap:
                                () =>
                                    Get.to(() => const ForgotPasswordScreen()),
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        getVerticalSpace(height: 2.6.h),
                        CustomElevatedButton(
                          text: "Sign In",
                          onPressed: () async {
                            try {
                              if (emailController.text.trim().isEmpty ||
                                  passwordController.text.isEmpty) {
                                controller.errorMessage.value =
                                    "Please fill all fields";
                                AppSnackbar.showError("Please fill all fields");
                                return;
                              }
                              final emailError = controller.validateEmail(
                                emailController.text.trim(),
                              );
                              if (emailError != null) {
                                controller.errorMessage.value = emailError;
                                AppSnackbar.showError(emailError);
                                return;
                              }
                              final passwordError = controller.validatePassword(
                                passwordController.text,
                              );
                              if (passwordError != null) {
                                controller.errorMessage.value = passwordError;
                                AppSnackbar.showError(passwordError);
                                return;
                              }
                              await controller.login(
                                emailController.text.trim(),
                                passwordController.text,
                              );
                            } catch (e) {
                              if (kDebugMode) {
                                log("Login error: $e", name: 'SignInScreen');
                              }
                            }
                          },
                        ),

                        getVerticalSpace(height: 2.h),
                        GestureDetector(
                          onTap: () => Get.to(() => const SignUpScreen()),
                          child: Text(
                            "Don’t have an account? Sign Up",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        getVerticalSpace(height: 2.h),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
