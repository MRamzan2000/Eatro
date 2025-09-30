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

  final user = FirebaseAuth.instance.currentUser;

  final profileUrl = "".obs;
  final name = "".obs;
  final email = "".obs;

  StreamSubscription<DocumentSnapshot>? _subscription;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  void fetchProfile() {
    if (user == null) return;

    _subscription = FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        name.value = data["name"] ?? "User";
        email.value = user?.email ?? "No email";
        profileUrl.value = data["profile"] ?? "";

        nameCtrl.text = name.value;
        emailCtrl.text = email.value;
      }
      isLoading.value = false;
    });
  }

  Future<void> saveProfile() async {
    if (user == null) return;

    await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
      "name": nameCtrl.text,
    });

    name.value = nameCtrl.text;
    AppSnackbar.showSuccess("Profile Updated successfully!");
    isEditing.value = false;
  }

  void toggleEditing() {
    isEditing.value = !isEditing.value;
  }

  @override
  void onClose() {
    _subscription?.cancel(); // 🔴 old snapshot listener band karna zaroori hai
    nameCtrl.dispose();
    emailCtrl.dispose();
    super.onClose();
  }
}
