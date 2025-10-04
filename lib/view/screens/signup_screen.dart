import 'dart:developer';
import 'dart:io';
import 'package:eatro/controller/getx_controller/auth_controller.dart';
import 'package:eatro/controller/utils/app_colors.dart';
import 'package:eatro/controller/utils/app_snackbar.dart';
import 'package:eatro/view/reuseable_widgets/custom_appbar.dart';
import 'package:eatro/view/reuseable_widgets/elevated_button.dart';
import 'package:eatro/view/reuseable_widgets/textfiled.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController controller = Get.find<AuthController>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Sign Up"),
      body: Obx(
        () =>
            controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        /// Profile Image Picker
                        Obx(
                          () => GestureDetector(
                            onTap: controller.pickProfileImage,
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              child:
                                  controller.profileImage.value != null
                                      ? ClipOval(
                                        child: Image.file(
                                          File(
                                            controller
                                                    .profileImage
                                                    .value
                                                    ?.path ??
                                                "",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                      : Icon(
                                        Icons.add_a_photo,
                                        size: 40,
                                        color: AppColors.primaryColor,
                                      ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        /// Full Name
                        CustomTextField(
                          hintText: "Full Name",
                          controller: nameController,
                          prefixIcon: Icons.person_outline,
                          onChanged:
                              (value) => controller.errorMessage.value = "",
                        ),
                        const SizedBox(height: 15),

                        /// Email
                        CustomTextField(
                          hintText: "Email",
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          onChanged:
                              (value) => controller.errorMessage.value = "",
                        ),
                        const SizedBox(height: 15),

                        /// Password
                        CustomTextField(
                          hintText: "Password",
                          controller: passwordController,
                          obscureText: true,
                          prefixIcon: Icons.lock_outline,
                          onChanged:
                              (value) => controller.errorMessage.value = "",
                        ),
                        const SizedBox(height: 15),

                        /// Confirm Password
                        CustomTextField(
                          hintText: "Confirm Password",
                          controller: confirmPasswordController,
                          obscureText: true,
                          prefixIcon: Icons.lock_person_outlined,
                          onChanged:
                              (value) => controller.errorMessage.value = "",
                        ),

                        /// Error Message
                        if (controller.errorMessage.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              controller.errorMessage.value,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(height: 25),

                        /// Sign Up Button
                        CustomElevatedButton(
                          text: "Sign Up",
                          onPressed: () async {
                            try {
                              if (nameController.text.trim().isEmpty ||
                                  emailController.text.trim().isEmpty ||
                                  passwordController.text.isEmpty ||
                                  confirmPasswordController.text.isEmpty) {
                                controller.errorMessage.value =
                                    "Please fill all fields";
                                AppSnackbar.showError("Please fill all fields");
                                return;
                              }
                              if (passwordController.text !=
                                  confirmPasswordController.text) {
                                controller.errorMessage.value =
                                    "Passwords do not match";
                                AppSnackbar.showError("Passwords do not match");
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
                              await controller.signUp(
                                emailController.text.trim(),
                                passwordController.text,
                                nameController.text.trim(),
                                photoUrl: controller.profileImage.value?.path,
                              );
                              controller.profileImage.value =
                                  null; // Clear image to free memory
                            } catch (e) {
                              if (kDebugMode) {
                                log("SignUp error: $e", name: 'SignUpScreen');
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
