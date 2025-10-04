import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatro/controller/services/auth_services.dart';
import 'package:eatro/controller/utils/app_snackbar.dart';
import 'package:eatro/controller/utils/my_shared_pref.dart';
import 'package:eatro/model/user_model.dart';
import 'package:eatro/view/bottom_navigation_bar.dart';
import 'package:eatro/view/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  final AuthServices _authServices = AuthServices();
  final ImagePicker _picker = ImagePicker();

  Rxn<User> currentUser = Rxn<User>();
  Rxn<UserModel> userModel = Rxn<UserModel>();
  RxBool isAuthenticated = false.obs;
  RxBool isGuest = false.obs;
  RxBool isLoading = false.obs;
  var errorMessage = "".obs;
  Rxn<File> profileImage = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    errorMessage.value = "";
    currentUser.value = _authServices.auth.currentUser;
    if (currentUser.value != null) {
      isAuthenticated.value = true;
      fetchUserData();
    }
  }

  // VALIDATORS
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

  // SIGN UP
  Future<void> signUp(
      String email,
      String password,
      String name, {
        String? photoUrl,
      })
  async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      User? user = await _authServices.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        profile: photoUrl ?? "",
      );

      if (user != null) {
        currentUser.value = user;
        isAuthenticated.value = true;

        await SharedPrefHelper.saveUser(
          uid: user.uid,
          email: user.email ?? "",
          name: name,
          photoUrl: photoUrl,
          password: password
        );
        Get.back();
        Get.back();
        AppSnackbar.showSuccess("Account created successfully!");

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

// LOGIN
  Future<void> login(String email, String password)
  async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      User? user = await _authServices.loginUser(
        email: email.trim(),
        password: password.trim(),
      );

      if (user != null) {
        currentUser.value = user;
        isAuthenticated.value = true;

        await SharedPrefHelper.saveUser(
          uid: user.uid,
          email: user.email ?? "",
          name: user.displayName ?? "",
          photoUrl: user.photoURL ?? "",
          password: password
        );

        await SharedPrefHelper.setLogin(true);

        AppSnackbar.showSuccess("Login successful!");
        Get.offAll(() => CustomBottomNavigationBAR());
      } else {
        errorMessage.value = "Login failed. Please try again.";
        AppSnackbar.showError(errorMessage.value);
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          errorMessage.value = "No account found with this email.";
          break;
        case "wrong-password":
          errorMessage.value = "Incorrect password. Please try again.";
          break;
        case "invalid-email":
          errorMessage.value = "Invalid email format.";
          break;
        case "user-disabled":
          errorMessage.value = "This account has been disabled.";
          break;
        default:
          errorMessage.value = "Login failed. Please try again.";
      }

      AppSnackbar.showError(errorMessage.value);
    } catch (e) {
      errorMessage.value = "Login failed. Please try again.";
      AppSnackbar.showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }


// CONTINUE AS GUEST
  Future<void> continueAsGuest()
  async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      // generate a unique dummy email and password
      String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
      String dummyEmail = "guest_$uniqueId@eatro.com";
      String dummyPassword = "guest_${uniqueId}_123";

      // create user with random credentials
      UserCredential result = await _authServices.auth
          .createUserWithEmailAndPassword(email: dummyEmail, password: dummyPassword);
      User? user = result.user;

      if (user != null) {
        currentUser.value = user;
        isGuest.value = true;
        isAuthenticated.value = true;

        String guestName = "Guest-${user.uid.substring(0, 5)}";
        String photoUrl =
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8TeQ5iojLROQXom0AApSQbIamNDJRFDYgjw&s";

        // Add to Firestore
        await _authServices.addUser(
          uid: user.uid,
          name: guestName,
          email: dummyEmail,
          photoUrl: photoUrl,
        );

        // Save to local storage
        await SharedPrefHelper.saveUser(
          uid: user.uid,
          email: dummyEmail,
          name: guestName,
          photoUrl: photoUrl,
          password: dummyPassword
        );

        await SharedPrefHelper.setLogin(true);
        AppSnackbar.showSuccess("Continued as guest!");
        Get.offAll(() => CustomBottomNavigationBAR());
      } else {
        errorMessage.value = "Guest registration failed.";
        AppSnackbar.showError(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      AppSnackbar.showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }


  // LOGOUT
  Future<void> logout({required BuildContext context})
  async {
    try {
      isLoading.value = true;
      await _authServices.signOut();
      currentUser.value = null;
      isGuest.value = false;
      isAuthenticated.value = false;
      await SharedPrefHelper.logout();
      AppSnackbar.showSuccess("Logged out successfully");
      Get.offAll(() => WelcomeScreen());
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

  // FETCH USER DATA
  Future<void> fetchUserData()
  async {
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

  // PICK PROFILE IMAGE
  Future<void> pickProfileImage()
  async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        profileImage.value = File(image.path);
      }
    } catch (e) {
      errorMessage.value = "Failed to pick image: $e";
      AppSnackbar.showError(errorMessage.value);
    }
  }

  // FORGOT PASSWORD
  Future<void> resetPassword(String email)
  async {
    final emailError = validateEmail(email);
    if (emailError != null) {
      errorMessage.value = emailError;
      AppSnackbar.showError(errorMessage.value);
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = "";
      await _authServices.resetPassword(email);
      AppSnackbar.showSuccess("Password reset email sent! Check your inbox.");
      Get.back();
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getFirebaseErrorMessage(e.code);
      AppSnackbar.showError(errorMessage.value);
    } catch (e) {
      errorMessage.value = "An unexpected error occurred: ${e.toString()}";
      AppSnackbar.showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
 // Delete Account
  Future<void> deleteAccountAndLogout({
    required BuildContext context,
  })
  async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        final savedUid = SharedPrefHelper.uid;
        if (savedUid != null) {
          user = FirebaseAuth.instance.currentUser ??
              (await FirebaseAuth.instance.authStateChanges().firstWhere(
                    (u) => u?.uid == savedUid,
                orElse: () => null,
              ));
        }
      }

      if (user == null) {
        debugPrint("⚠️ No logged-in user found.");
        return;
      }

      if (!user.isAnonymous) {
        final email = SharedPrefHelper.email;
        final password = SharedPrefHelper.password;

        if (email == null || password == null) {
          debugPrint("⚠️ Stored credentials not found. Logging out...");
          await logout(context: context);
          return;
        }

        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);
      } else {
        debugPrint("ℹ️ Guest user detected — skipping reauthentication.");
      }

      // Try deleting Firestore document
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .delete();
        debugPrint("🔥 Firestore document deleted for UID: ${user.uid}");
      } catch (firestoreError) {
        debugPrint("⚠️ Failed to delete Firestore document: $firestoreError");
      }

      // Delete Firebase Auth user
      await user.delete();
      debugPrint("✅ Firebase user deleted: ${user.uid}");

      // Clear local storage
      await SharedPrefHelper.logout();
      await logout(context: context);

      debugPrint("🎉 Account deleted successfully.");
      Get.offAll(() => WelcomeScreen());

    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        errorMessage.value = "Please log in again before deleting your account.";
      } else {
        errorMessage.value = _getFirebaseErrorMessage(e.code);
      }
      debugPrint("❌ FirebaseAuthException: ${errorMessage.value}");
    } catch (e) {
      errorMessage.value = "Failed to delete account: ${e.toString()}";
      debugPrint("❌ General Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }





  // Helper for Firebase error messages
  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'operation-not-allowed':
        return 'Operation is not allowed.';
      default:
        return 'An error occurred: ${code}';
    }
  }
}