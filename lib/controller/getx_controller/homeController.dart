import 'dart:developer';
import 'package:eatro/controller/getx_controller/recipe_controller.dart';
import 'package:eatro/controller/utils/app_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:eatro/model/recipe_model.dart';

class HomeController extends GetxController {
  final searchQuery = ''.obs;
  final filterState = FilterState().obs;
  final currentPage = 1.obs;
  final itemsPerPage = 10;
  final isFilterShow = false.obs;

  void updateFilter({
    String? searchTerm,
    List<String>? cuisines,
    List<String>? mealTypes,
    List<String>? healthGoals,
    String? sortBy,
  }) {
    try {
      filterState.value = filterState.value.copyWith(
        searchTerm: searchTerm,
        cuisines: cuisines,
        mealTypes: mealTypes,
        healthGoals: healthGoals,
        sortBy: sortBy,
      );
    } catch (e) {
      if (kDebugMode) log("Error updating filter: $e", name: 'HomeController');
      AppSnackbar.showError("Failed to update filters.");
    }
  }

  void resetToFirstPage() {
    currentPage.value = 1;
  }

  void goToPreviousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }

  void goToNextPage(int totalPages) {
    if (currentPage.value < totalPages) {
      currentPage.value++;
    }
  }

  Future<void> resetFilters() async {
    try {
      searchQuery.value = '';
      filterState.value = FilterState();
      isFilterShow.value = false;
      Get.find<RecipeController>().resetFilters();
    } catch (e) {
      if (kDebugMode) {
        log("Error resetting filters: $e", name: 'HomeController');
      }
      AppSnackbar.showError("Failed to reset filters.");
    }
  }
}
