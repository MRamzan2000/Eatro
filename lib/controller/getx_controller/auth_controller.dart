import 'dart:developer';

import 'package:eatro/controller/services/auth_services.dart';
import 'package:eatro/controller/utils/app_snackbar.dart';
import 'package:eatro/controller/utils/my_shared_pref.dart';
import 'package:eatro/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthServices _authServices = AuthServices();

  Rxn<User> currentUser = Rxn<User>();
  Rxn<UserModel> userModel = Rxn<UserModel>();
  RxBool isAuthenticated = false.obs;
  RxBool isGuest = false.obs;
  RxBool isLoading = false.obs;
  var errorMessage = "".obs;

  // -------------------- VALIDATORS --------------------
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email is required";
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value)) return "Please enter a valid email";
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 7) return "Password must be at least 7 characters long";
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) return "Name is required";
    if (value.length < 2) return "Name must be at least 2 characters long";
    return null;
  }

  // -------------------- SIGN UP --------------------
  Future<void> signUp(String email, String password, String name, {String? photoUrl}) async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      User? user = await _authServices.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        profile: photoUrl.toString()
      );

      if (user != null) {
        currentUser.value = user;
        isAuthenticated.value = true;

        await SharedPrefHelper.saveUser(
          uid: user.uid,
          email: user.email ?? "",
          name: name,
          photoUrl: photoUrl,
        );

        AppSnackbar.showSuccess("Account created successfully!");
        _closeAllDialogs();
      } else {
        errorMessage.value = "Sign up failed. Please try again.";
        AppSnackbar.showError(errorMessage.value);
      }
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? "Sign up failed.";
      AppSnackbar.showError(errorMessage.value);
    } catch (e) {
      errorMessage.value = e.toString();
      AppSnackbar.showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------- LOGIN --------------------
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      User? user = await _authServices.loginUser(email: email, password: password);

      if (user != null) {
        currentUser.value = user;
        isAuthenticated.value = true;

        await SharedPrefHelper.saveUser(
          uid: user.uid,
          email: user.email ?? "",
          name: user.displayName ?? "",
          photoUrl: user.photoURL,
        );

        AppSnackbar.showSuccess("Login successful!");
        _closeAllDialogs();
      } else {
        errorMessage.value = "Login failed. Please try again.";
        AppSnackbar.showError(errorMessage.value);
      }
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? "Login failed.";
      AppSnackbar.showError(errorMessage.value);
    } catch (e) {
      errorMessage.value = e.toString();
      AppSnackbar.showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------- GOOGLE SIGN IN --------------------
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      User? user = await _authServices.signInWithGoogle();

      if (user != null) {
        currentUser.value = user;
        isAuthenticated.value = true;

        await SharedPrefHelper.saveUser(
          uid: user.uid,
          email: user.email ?? "",
          name: user.displayName ?? "",
          photoUrl: user.photoURL,
        );

        AppSnackbar.showSuccess("Signed in with Google!");
        _closeAllDialogs();
      } else {
        errorMessage.value = "Google sign-in failed.";
        AppSnackbar.showError(errorMessage.value);
      }
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? "Google sign-in failed.";
      AppSnackbar.showError(errorMessage.value);
    } catch (e) {
      errorMessage.value = e.toString();
      AppSnackbar.showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------- CONTINUE AS GUEST --------------------
  Future<void> continueAsGuest() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      User? user = await _authServices.continueAsGuest();

      if (user != null) {
        currentUser.value = user;
        isGuest.value = true;
        isAuthenticated.value = true;

        String guestName = "Guest-${user.uid.substring(0, 5)}";

        await SharedPrefHelper.saveUser(
          uid: user.uid,
          email: "",
          name: guestName,
        );

        AppSnackbar.showSuccess("Continued as guest!");
        _closeAllDialogs();
      } else {
        errorMessage.value = "Guest login failed.";
        AppSnackbar.showError(errorMessage.value);
      }
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? "Guest login failed.";
      AppSnackbar.showError(errorMessage.value);
    } catch (e) {
      errorMessage.value = e.toString();
      AppSnackbar.showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------- LOGOUT --------------------
  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _authServices.auth.signOut();
      currentUser.value = null;
      isGuest.value = false;
      isAuthenticated.value = false;

      await SharedPrefHelper.logout();
      AppSnackbar.showSuccess("Logged out successfully");
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? "Logout failed.";
      AppSnackbar.showError(errorMessage.value);
    } catch (e) {
      errorMessage.value = "Logout failed: $e";
      AppSnackbar.showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------- FETCH USER DATA --------------------
  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      log("CurrentUser Id :$currentUserId");

      if (currentUserId != null) {
        final data = await _authServices.getUserData(currentUserId);
        if (data != null) {
          userModel.value = data;
          log("UserModel: ${userModel.value?.toJson()}");
        }
      } else {
        if (kDebugMode) {
          print("No logged in user found.");
        }
      }
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? "Failed to fetch user data.";
      AppSnackbar.showError(errorMessage.value);
    } catch (error) {
      errorMessage.value = error.toString();
      AppSnackbar.showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------- CLOSE DIALOGS --------------------
  void _closeAllDialogs() {
    while (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
