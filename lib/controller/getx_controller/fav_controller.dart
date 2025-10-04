import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatro/controller/utils/app_snackbar.dart';

class FavoritesController extends GetxController {
  final RxList<String> favorites = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  String _getStorageKey() {
    final user = FirebaseAuth.instance.currentUser;
    return 'eatro-favorites-${user?.uid ?? 'guest'}';
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedFavorites = prefs.getStringList(_getStorageKey()) ?? [];
      favorites.assignAll(savedFavorites);
    } catch (e) {
      if (kDebugMode) {
        log("Error loading favorites: $e", name: 'FavoritesController');
      }
      AppSnackbar.showError("Failed to load favorites.");
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_getStorageKey(), favorites);
    } catch (e) {
      if (kDebugMode) {
        log("Error saving favorites: $e", name: 'FavoritesController');
      }
      AppSnackbar.showError("Failed to save favorites.");
    }
  }

  Future<void> toggleFavorite(String recipeId) async {
    try {
      if (favorites.contains(recipeId)) {
        favorites.remove(recipeId);
      } else {
        favorites.add(recipeId);
      }
      await _saveFavorites();
    } catch (e) {
      if (kDebugMode) {
        log("Error toggling favorite: $e", name: 'FavoritesController');
      }
      AppSnackbar.showError("Failed to update favorites.");
    }
  }

  bool isFavorite(String recipeId) => favorites.contains(recipeId);
}
