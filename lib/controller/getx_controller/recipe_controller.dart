import 'dart:convert';
import 'package:eatro/model/recipe_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RecipeController extends GetxController {
  var recipes = <Recipe>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final String apiUrl =
      'https://script.google.com/macros/s/AKfycbypHKtYPiWJnjJiLDME_G3JslZA_LXTGVLI4sXZrE6ULWMMFLPkOv3n2SvaIf3NW43w/exec';

  static List<Recipe>? _recipesCache;
  static int _lastFetchTime = 0;
  static const int _cacheDuration = 2 * 60 * 1000; // 2 minutes

  final List<String> pantryStaples = [
    "salt",
    "oil",
    "water",
    "sugar",
    "soy sauce"
  ];

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();
  }

  Future<void> fetchRecipes({bool forceRefresh = false}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (!forceRefresh &&
        _recipesCache != null &&
        (now - _lastFetchTime) < _cacheDuration) {
      recipes.value = _recipesCache!;
      return;
    }

    try {
      isLoading(true);
      errorMessage('');

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isEmpty) {
          recipes.value = _getSampleRecipes();
          errorMessage('No recipes found, using sample data.');
        } else {
          recipes.value = data
              .asMap()
              .entries
              .map((e) =>
              Recipe.fromJson(e.value as Map<String, dynamic>, e.key))
              .toList();
        }
        _recipesCache = recipes;
        _lastFetchTime = now;
      } else {
        recipes.value = _getSampleRecipes();
        errorMessage(
            'Server error: ${response.statusCode} - ${response.reasonPhrase}, using sample data.');
      }
    } catch (e) {
      recipes.value = _getSampleRecipes();
      errorMessage('Error fetching recipes: $e, using sample data.');
    } finally {
      isLoading(false);
    }
  }

  void clearCache() {
    _recipesCache = null;
    _lastFetchTime = 0;
  }

  void resetFilters() {
    clearCache();
    fetchRecipes(forceRefresh: true);
  }

  List<Recipe> _getSampleRecipes() {
    return [
      Recipe(
        id: '1',
        name: 'Lemon Tofu Bowl',
        cuisine: 'Vegan',
        mealType: ['Lunch'],
        healthGoals: ['Weight Control', 'Low Carb', 'High Protein'],
        imageUrl:
        'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=800',
        image:
        'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=800',
        description:
        'Crispy tofu with lemon sauce and fresh vegetables. Perfect plant-based protein meal.',
        instructions:
        'Press tofu to remove excess water, then cube into bite-sized pieces. Heat olive oil in a large pan over medium-high heat. Add tofu cubes and cook until golden brown on all sides, about 8 minutes. Add garlic and ginger, cook for 1 minute until fragrant. Steam broccoli until tender-crisp, about 4 minutes. In a small bowl, whisk together lemon juice, zest, soy sauce, and sesame oil. Toss tofu and broccoli with the lemon sauce. Season with salt and pepper, serve immediately.',
        ingredients: [
          '200g firm tofu, cubed',
          '1 lemon, juiced and zested',
          '2 cups broccoli florets',
          '1 tbsp olive oil',
          '2 cloves garlic, minced',
          '1 tsp ginger, grated',
          '2 tbsp soy sauce',
          '1 tbsp sesame oil',
          'Salt and pepper to taste'
        ],
        steps: [
          'Press tofu to remove excess water, then cube into bite-sized pieces',
          'Heat olive oil in a large pan over medium-high heat',
          'Add tofu cubes and cook until golden brown on all sides, about 8 minutes',
          'Add garlic and ginger, cook for 1 minute until fragrant',
          'Steam broccoli until tender-crisp, about 4 minutes',
          'In a small bowl, whisk together lemon juice, zest, soy sauce, and sesame oil',
          'Toss tofu and broccoli with the lemon sauce',
          'Season with salt and pepper, serve immediately'
        ],
        notes: 'Contains soy. Perfect for plant-based protein needs.',
        calories: 300,
        protein: 20,
        fat: 10,
        carbs: 15,
        nutrition: Nutrition(
          calories: 300,
          protein: 20,
          fat: 10,
          carbs: 15,
        ),
      ),
    ];
  }

  Map<String, List<Map<String, dynamic>>> searchRecipes(
      List<String> userIngredients) {
    List<Map<String, dynamic>> perfect = [];
    List<Map<String, dynamic>> nearby = [];
    List<Map<String, dynamic>> explore = [];

    for (var recipe in recipes) {
      final recipeIngredients = recipe.ingredients
          .map((i) => i.toLowerCase().trim())
          .toList();

      var missing = recipeIngredients
          .where((ingredient) =>
      !userIngredients.contains(ingredient) &&
          !pantryStaples.contains(ingredient))
          .toList();

      if (missing.isEmpty) {
        perfect.add({"recipe": recipe, "missing": []});
      } else if (missing.length <= 2) {
        nearby.add({"recipe": recipe, "missing": missing});
      } else {
        explore.add({"recipe": recipe, "missing": missing});
      }
    }

    return {
      "perfect": perfect,
      "nearby": nearby,
      "explore": explore,
    };
  }
}