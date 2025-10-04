import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:eatro/controller/utils/app_snackbar.dart';

class PreferenceController extends GetxController {
  var isLoading = false.obs;

  Future<void> savePreferences(Set<String> preferences) async {
    try {
      isLoading.value = true;

      await FirebaseFirestore.instance
          .collection("preferences")
          .add({
        "preferences": preferences.toList(),
        "createdAt": FieldValue.serverTimestamp(),
      });

      AppSnackbar.showSuccess("Preferences saved successfully!");
    } catch (e) {
      AppSnackbar.showError("Failed to save preferences: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
