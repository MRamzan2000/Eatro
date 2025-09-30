import 'package:get/get.dart';

class Recipe {
  final String id;
  final String name;
  final String cuisine;
  final List<String> mealType;
  final List<String> healthGoals;
  final String imageUrl;
  final String image; // Alias for imageUrl
  final String description;
  final String instructions;
  final List<String> ingredients;
  final List<String> steps;
  final String? notes;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final Nutrition nutrition;

  Recipe({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.mealType,
    required this.healthGoals,
    required this.imageUrl,
    required this.image,
    required this.description,
    required this.instructions,
    required this.ingredients,
    required this.steps,
    this.notes,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.nutrition,
  });

  factory Recipe.fromJson(Map<String, dynamic> json, int index) {
    final name = json['Name']?.toString().trim() ?? 'Unknown';
    final cuisine = json['Cuisine']?.toString().trim() ?? 'Unknown';
    final mealTypes = json['Meal Type']?.toString() ?? '';
    final healthGoals = json['Health Goals']?.toString() ?? '';
    final imageUrl = json['Image']?.toString().trim() ??
        'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=800';
    final notes = json['Notes']?.toString().trim() ?? '';
    final ingredients = json['Ingredients']?.toString() ?? '';
    final steps = json['Steps']?.toString() ?? '';
    final calories = double.tryParse(json['Calories']?.toString() ?? '0') ?? 0.0;
    final protein = double.tryParse(json['Protein']?.toString() ?? '0') ?? 0.0;
    final fat = double.tryParse(json['Fat']?.toString() ?? '0') ?? 0.0;
    final carbs = double.tryParse(json['Carbs']?.toString() ?? '0') ?? 0.0;

    return Recipe(
      id: (index + 1).toString(),
      name: name,
      cuisine: cuisine,
      mealType: _parseCommaSeparated(mealTypes),
      healthGoals: _parseCommaSeparated(healthGoals),
      imageUrl: imageUrl,
      image: imageUrl,
      description: notes,
      instructions: steps.replaceAll('\n', ' ').trim(),
      ingredients: _parseMultilineText(ingredients),
      steps: _parseNumberedSteps(steps),
      notes: notes.isEmpty ? null : notes,
      calories: calories,
      protein: protein,
      fat: fat,
      carbs: carbs,
      nutrition: Nutrition(
        calories: calories,
        protein: protein,
        fat: fat,
        carbs: carbs,
      ),
    );
  }
}

class Nutrition {
  final double calories;
  final double protein;
  final double fat;
  final double carbs;

  Nutrition({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });
}

class FilterState {
  final String? searchTerm;
  final RxList<String> cuisines;
  final RxList<String> mealTypes;
  final RxList<String> healthGoals;
  final String? sortBy;

  FilterState({
    this.searchTerm = '',
    List<String>? cuisines,
    List<String>? mealTypes,
    List<String>? healthGoals,
    this.sortBy = 'name',
  })  : cuisines = (cuisines ?? []).obs,
        mealTypes = (mealTypes ?? []).obs,
        healthGoals = (healthGoals ?? []).obs;

  FilterState copyWith({
    String? searchTerm,
    List<String>? cuisines,
    List<String>? mealTypes,
    List<String>? healthGoals,
    String? sortBy,
  }) {
    return FilterState(
      searchTerm: searchTerm ?? this.searchTerm,
      cuisines: cuisines ?? this.cuisines,
      mealTypes: mealTypes ?? this.mealTypes,
      healthGoals: healthGoals ?? this.healthGoals,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

class UserPreferences {
  final List<String> healthGoals;
  final List<String> dietaryRestrictions;
  final List<String> favoriteCuisines;
  final List<String> mealPreferences;

  UserPreferences({
    required this.healthGoals,
    required this.dietaryRestrictions,
    required this.favoriteCuisines,
    required this.mealPreferences,
  });
}

class RecommendationRequest {
  final String prompt;
  final UserPreferences? preferences;

  RecommendationRequest({
    required this.prompt,
    this.preferences,
  });
}

List<String> _parseMultilineText(String text) {
  if (text.isEmpty) return [];
  return text
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();
}

List<String> _parseNumberedSteps(String text) {
  if (text.isEmpty) return [];
  final steps = text
      .split(RegExp(r'(?=\d+\.\s)'))
      .where((step) => step.trim().isNotEmpty)
      .toList();
  return steps
      .map((step) => step
      .replaceFirst(RegExp(r'^\d+\.\s*'), '')
      .replaceAll(RegExp(r'\.\s*$'), '')
      .trim())
      .where((step) => step.isNotEmpty)
      .toList();
}

List<String> _parseCommaSeparated(String text) {
  if (text.isEmpty) return [];
  return text
      .split(RegExp(r'[,;]'))
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();
}