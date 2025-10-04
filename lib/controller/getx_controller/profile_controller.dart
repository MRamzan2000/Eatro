import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_snackbar.dart';

class ProfileController extends GetxController {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  final isEditing = false.obs;
  final isLoading = true.obs;

  final profileUrl = "".obs;
  final name = "".obs;
  final email = "".obs;

  StreamSubscription<DocumentSnapshot>? _subscription;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  /// 🔹 Fetch User Profile from Firestore (handles guest users properly)
  Future<void> fetchProfile() async {
    isLoading.value = true;

    User? currentUser = FirebaseAuth.instance.currentUser;

    // 🔄 Wait for FirebaseAuth to initialize (important for guest users)
    int attempts = 0;
    while (currentUser == null && attempts < 5) {
      await Future.delayed(const Duration(milliseconds: 400));
      currentUser = FirebaseAuth.instance.currentUser;
      attempts++;
    }

    if (currentUser == null) {
      debugPrint("⚠️ No user logged in — cannot fetch profile.");
      isLoading.value = false;
      return;
    }

    debugPrint("🔄 Fetching profile for UID: ${currentUser.uid}");

    _subscription = FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .snapshots()
        .listen(
          (doc) {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          debugPrint("✅ Profile document fetched for UID: ${currentUser!.uid}");

          name.value = data["name"] ?? "User";
          email.value = currentUser.email ?? "No email";
          profileUrl.value = data["profile"] ?? "";

          nameCtrl.text = name.value;
          emailCtrl.text = email.value;
        } else {
          debugPrint("❌ No Firestore document found for UID: ${currentUser?.uid}");
          AppSnackbar.showError("No profile found for this user.");
        }

        isLoading.value = false;
      },
      onError: (e) {
        debugPrint("🔥 Firestore error while fetching profile: $e");
        AppSnackbar.showError("Failed to fetch profile: $e");
        isLoading.value = false;
      },
    );
  }

  /// 🔹 Save Updated Profile Data
  Future<void> saveProfile() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      AppSnackbar.showError("No logged-in user found.");
      return;
    }

    if (nameCtrl.text.isEmpty) {
      AppSnackbar.showError("Name cannot be empty.");
      return;
    }

    try {
      debugPrint("💾 Saving updated profile for UID: ${currentUser.uid}");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .update({
        "name": nameCtrl.text,
      });

      name.value = nameCtrl.text;
      AppSnackbar.showSuccess("Profile updated successfully!");
      isEditing.value = false;
    } catch (e) {
      debugPrint("🔥 Failed to update profile: $e");
      AppSnackbar.showError("Failed to update profile: $e");
    }
  }

  /// 🔹 Toggle Edit Mode
  void toggleEditing() {
    isEditing.value = !isEditing.value;
    debugPrint("✏️ Editing mode: ${isEditing.value}");
  }

  @override
  void onClose() {
    _subscription?.cancel();
    nameCtrl.dispose();
    emailCtrl.dispose();
    super.onClose();
    debugPrint("🧹 ProfileController disposed and listeners cancelled.");
  }
}
