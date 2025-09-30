// lib/utils/recipe_utils.dart

import 'package:eatro/model/recipe_model.dart';

import 'mockData.dart';

List<Recipe> sortRecipes(List<Recipe> recipes, String sortBy) {
  final sorted = [...recipes];
  switch (sortBy) {
    case 'name':
      return sorted..sort((a, b) => a.name.compareTo(b.name));
    case 'newest':
      return sorted..sort((a, b) => int.parse(b.id).compareTo(int.parse(a.id)));
    case 'popularity':
      return sorted..sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
    case 'calories-low':
      return sorted..sort((a, b) => a.calories.compareTo(b.calories));
    case 'calories-high':
      return sorted..sort((a, b) => b.calories.compareTo(a.calories));
    case 'protein-high':
      return sorted..sort((a, b) => b.protein.compareTo(a.protein));
    case 'protein-low':
      return sorted..sort((a, b) => a.protein.compareTo(b.protein));
    default:
      return sorted;
  }
}

List<Recipe> filterRecipes(
    List<Recipe> recipes, String searchTerm, FilterState filters) {
  if (recipes.isEmpty) return [];

  return recipes.where((recipe) {
    final matchesSearch = recipe.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
        recipe.ingredients.any((ingredient) =>
            ingredient.toLowerCase().contains(searchTerm.toLowerCase()));

    final matchesCuisine = filters.cuisines.isEmpty ||
        filters.cuisines.contains(recipe.cuisine);

    final matchesMealType = filters.mealTypes.isEmpty ||
        filters.mealTypes.any((filterType) => recipe.mealType.contains(filterType));

    final matchesHealthGoal = filters.healthGoals.isEmpty ||
        filters.healthGoals
            .any((filterGoal) => recipe.healthGoals.contains(filterGoal));

    return matchesSearch && matchesCuisine && matchesMealType && matchesHealthGoal;
  }).toList();
}