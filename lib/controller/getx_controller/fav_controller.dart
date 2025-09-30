import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatro/model/recipe_model.dart';

class FavoritesController extends GetxController {
  final RxList<String> favorites = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  // Get storage key based on user
  String _getStorageKey() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.providerData.isNotEmpty) {
      return 'eatro-favorites-${user.uid}';
    }
    return 'eatro-favorites-guest';
  }

  // Load favorites from SharedPreferences
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedFavorites = prefs.getStringList(_getStorageKey()) ?? [];
    favorites.assignAll(savedFavorites);
  }

  // Save favorites to SharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_getStorageKey(), favorites);
  }

  // Toggle favorite status for a recipe
  void toggleFavorite(String recipeId) {
    if (favorites.contains(recipeId)) {
      favorites.remove(recipeId);
    } else {
      favorites.add(recipeId);
    }
    _saveFavorites();
  }

  // Check if a recipe is favorited
  bool isFavorite(String recipeId) => favorites.contains(recipeId);
}