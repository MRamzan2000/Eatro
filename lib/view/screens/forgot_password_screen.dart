import 'dart:developer';
import 'package:eatro/controller/getx_controller/auth_controller.dart';
import 'package:eatro/controller/utils/app_snackbar.dart';
import 'package:eatro/controller/utils/app_styles.dart';
import 'package:eatro/view/reuseable_widgets/custom_appbar.dart';
import 'package:eatro/view/reuseable_widgets/elevated_button.dart';
import 'package:eatro/view/reuseable_widgets/textfiled.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthController controller = Get.find<AuthController>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Forgot Password"),
      body: Obx(
        () =>
            controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter your email to reset password",
                        style: AppTextStyles.subHeading,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: emailController,
                        hintText: "Enter your email",
                        keyboardType: TextInputType.emailAddress,
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
                      const SizedBox(height: 25),
                      CustomElevatedButton(
                        text: "Send Reset Link",
                        onPressed: () async {
                          try {
                            if (emailController.text.trim().isEmpty) {
                              controller.errorMessage.value =
                                  "Please enter an email";
                              AppSnackbar.showError("Please enter an email");
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
                            await controller.resetPassword(
                              emailController.text.trim(),
                            );
                          } catch (e) {
                            if (kDebugMode) {
                              log(
                                "Reset Password error: $e",
                                name: 'ForgotPasswordScreen',
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
