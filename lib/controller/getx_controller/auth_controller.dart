import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:eatro/model/user_model.dart';

class AuthController extends GetxController {
  Rxn<UserModel> user = Rxn<UserModel>();
  RxBool isAuthenticated = false.obs;
  RxBool isGuest = false.obs;
  RxBool isLoading = false.obs;

  static const String authKey = "eatro-auth";
  static const String identityKey = "eatro-identity-chosen";

  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  Future<void> initGoogleSignIn() async {
    await googleSignIn.initialize(
      clientId: "811434924053-2fohlijj3hk50lcrn2isipm38ofbkmbv.apps.googleusercontent.com",
    );
  }

  @override
  void onInit() {
    super.onInit();
    initGoogleSignIn();
    _loadUser();
  }
  // Load user
  Future<void> _loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(authKey);
      if (saved != null) {
        final data = UserModel.fromJson(jsonDecode(saved));
        user.value = data;
        isAuthenticated.value = true;
        isGuest.value = data.provider == "guest";
      }
    } catch (e) {
      if (e is MissingPluginException) {
        Get.snackbar("Error", "SharedPreferences plugin not initialized",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(authKey);
    }
  }

  // Save User
  Future<void> _saveUser(UserModel newUser) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = jsonEncode(newUser.toJson());
      await prefs.setString(authKey, jsonData);
      await prefs.setBool(identityKey, true);
      user.value = newUser;
      isAuthenticated.value = true;
      isGuest.value = newUser.provider == "guest";
    } catch (e) {
      if (e is MissingPluginException) {
        Get.snackbar("Error", "SharedPreferences plugin not initialized",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
      rethrow;
    }
  }

  // Sign In With Google
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      GoogleSignInAccount? googleUser;

      if (googleSignIn.supportsAuthenticate()) {
        googleUser = await googleSignIn.authenticate();
      } else {
        await googleSignIn.signOut(); // force chooser
        googleUser = await googleSignIn.authenticate();
      }

      final newUser = UserModel(
        id: googleUser.id,
        name: googleUser.displayName ?? "Google User",
        email: googleUser.email,
        provider: "google",
        avatar: googleUser.photoUrl,
      );

      await _saveUser(newUser);

      Get.back();
      await Future.delayed(const Duration(milliseconds: 300));
      Get.snackbar("Success", "Signed in with Google successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      print("Failed to sign in with Google: $e");
      Get.snackbar("Error", "Failed to sign in with Google: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Get User Data
  Future<UserModel?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(authKey);
      if (saved != null) {
        final data = UserModel.fromJson(jsonDecode(saved));
        return data;
      } else {
        if (kDebugMode) {
          print("No user data found in SharedPreferences");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving user data: $e");
      }
      if (e is MissingPluginException) {
        Get.snackbar("Error", "SharedPreferences plugin not initialized",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
      return null;
    }
  }

  // Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  //Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 7) {
      return "Password must be at least 7 characters long";
    }
    return null;
  }

  // validate name
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is required";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    return null;
  }

  //Email Sign-In
  Future<void> signInWithEmail(String email, String password) async {
    try {
      isLoading.value = true;
      final emailError = validateEmail(email);
      final passwordError = validatePassword(password);
      if (emailError != null) throw Exception(emailError);
      if (passwordError != null) throw Exception(passwordError);

      if (kDebugMode) {
        print("Signing in: $email");
      }
      await Future.delayed(const Duration(seconds: 1));
      final newUser = UserModel(
        id: "email_${DateTime.now().millisecondsSinceEpoch}",
        name: email.split("@")[0],
        email: email,
        provider: "email",
      );
      await _saveUser(newUser);
      Get.back();
      await Future.delayed(const Duration(milliseconds: 300));
      Get.snackbar("Success", "Signed in successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      if (kDebugMode) {
        print("Sign-in error: $e");
      }
      Get.snackbar("Error", e.toString().replaceFirst("Exception: ", ""),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  //Email Sign-Up
  Future<void> signUpWithEmail(String email, String password, String name) async {
    try {
      isLoading.value = true;
      final emailError = validateEmail(email);
      final passwordError = validatePassword(password);
      final nameError = validateName(name);
      if (emailError != null) throw Exception(emailError);
      if (passwordError != null) throw Exception(passwordError);
      if (nameError != null) throw Exception(nameError);

      if (kDebugMode) {
        print("Creating user: $email, $name");
      }
      await Future.delayed(const Duration(seconds: 1));
      final newUser = UserModel(
        id: "email_${DateTime.now().millisecondsSinceEpoch}",
        name: name,
        email: email,
        provider: "email",
      );
      await _saveUser(newUser);
      Get.back();
      await Future.delayed(const Duration(milliseconds: 300));
      Get.snackbar("Success", "Account created successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      if (kDebugMode) {
        print("Sign-up error: $e");
      }
      Get.snackbar("Error", e.toString().replaceFirst("Exception: ", ""),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  //Continue as Guest
  Future<void> continueAsGuest() async {
    try {
      isLoading.value = true;
      if (kDebugMode) {
        print("Continuing as guest");
      }
      await Future.delayed(const Duration(seconds: 1));
      final newUser = UserModel(
        id: "guest_${DateTime.now().millisecondsSinceEpoch}",
        name: "Guest User",
        email: "",
        provider: "guest",
        avatar: "assets/images/user.png"
      );
      await _saveUser(newUser);
      Get.back();
      await Future.delayed(const Duration(milliseconds: 300));
      Get.snackbar("Success", "Continued as guest successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      if (kDebugMode) {
        print("Guest sign-in error: $e");
      }
      Get.snackbar("Error", "Failed to continue as guest: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  //Sign Out
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(authKey);
      await prefs.remove(identityKey);
      await googleSignIn.signOut();
      user.value = null;
      isAuthenticated.value = false;
      isGuest.value = false;
      if (kDebugMode) {
        print("Signed out");
      }
      Get.snackbar("Success", "Signed out successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      if (kDebugMode) {
        print("Sign-out error: $e");
      }
      Get.snackbar("Error", "Failed to sign out: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  //Delete Account (Local only)
  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("eatro-favorites");
      await prefs.remove("eatro-preferences");
      await prefs.remove(authKey);
      await prefs.remove(identityKey);
      await googleSignIn.signOut();
      user.value = null;
      isAuthenticated.value = false;
      isGuest.value = false;
      if (kDebugMode) {
        print("Account deleted");
      }
      Get.snackbar("Success", "Account deleted successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      if (kDebugMode) {
        print("Delete account error: $e");
      }
      Get.snackbar("Error", "Failed to delete account: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
