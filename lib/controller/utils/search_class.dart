// lib/utils/search_class.dart


import 'package:eatro/controller/utils/recipe_utils.dart';
import 'package:eatro/model/recipe_model.dart';

import 'mockData.dart' ;

class SearchToken {
  final String type; // 'cuisine', 'mealType', 'healthGoal', 'freeText'
  final String value;
  final String original;

  SearchToken({
    required this.type,
    required this.value,
    required this.original,
  });
}

class SmartSearchResult {
  final List<Recipe> filteredRecipes;
  final List<SearchToken> activeFilters;

  SmartSearchResult({
    required this.filteredRecipes,
    required this.activeFilters,
  });
}

class SmartSearch {
  static bool fuzzyMatch(String text, String pattern) {
    final textLower = text.toLowerCase();
    final patternLower = pattern.toLowerCase();

    if (textLower.contains(patternLower)) return true;

    if ((text.length - pattern.length).abs() <= 2) {
      int differences = 0;
      final minLength = textLower.length < patternLower.length ? textLower.length : patternLower.length;

      for (int i = 0; i < minLength; i++) {
        if (textLower[i] != patternLower[i]) {
          differences++;
          if (differences > 2) return false;
        }
      }
      return differences <= 2;
    }
    return false;
  }

  static SmartSearchResult search({
    required List<Recipe> recipes,
    required String searchQuery,
    required FilterState filters,
  }) {
    if (searchQuery.trim().isEmpty &&
        filters.cuisines.isEmpty &&
        filters.mealTypes.isEmpty &&
        filters.healthGoals.isEmpty) {
      final sortedRecipes = sortRecipes(recipes, filters.sortBy.toString());
      return SmartSearchResult(
        filteredRecipes: sortedRecipes,
        activeFilters: [],
      );
    }

    final tokens = searchQuery.split(RegExp(r'\s+')).where((token) => token.isNotEmpty).toList();
    final searchTokens = <SearchToken>[];
    final freeTextTokens = <String>[];

    for (var token in tokens) {
      bool matched = false;

      for (var cuisine in cuisineOptions) {
        if (fuzzyMatch(cuisine, token)) {
          searchTokens.add(SearchToken(type: 'cuisine', value: cuisine, original: token));
          matched = true;
          break;
        }
      }

      if (!matched) {
        for (var mealType in mealTypeOptions) {
          if (fuzzyMatch(mealType, token)) {
            searchTokens.add(SearchToken(type: 'mealType', value: mealType, original: token));
            matched = true;
            break;
          }
        }
      }

      if (!matched) {
        for (var healthGoal in healthGoalOptions) {
          if (fuzzyMatch(healthGoal, token)) {
            searchTokens.add(SearchToken(type: 'healthGoal', value: healthGoal, original: token));
            matched = true;
            break;
          }
        }
      }

      if (!matched) {
        freeTextTokens.add(token);
      }
    }

    if (freeTextTokens.isNotEmpty) {
      final freeText = freeTextTokens.join(' ');
      searchTokens.add(SearchToken(type: 'freeText', value: freeText, original: freeText));
    }

    searchTokens.addAll(filters.cuisines
        .map((c) => SearchToken(type: 'cuisine', value: c, original: c)));
    searchTokens.addAll(
        filters.mealTypes.map((m) => SearchToken(type: 'mealType', value: m, original: m)));
    searchTokens.addAll(filters.healthGoals
        .map((h) => SearchToken(type: 'healthGoal', value: h, original: h)));

    var filteredRecipes = recipes.where((recipe) {
      final cuisineFilters = searchTokens.where((t) => t.type == 'cuisine').toList();
      final mealTypeFilters = searchTokens.where((t) => t.type == 'mealType').toList();
      final healthGoalFilters = searchTokens.where((t) => t.type == 'healthGoal').toList();
      final freeTextFilters = searchTokens.where((t) => t.type == 'freeText').toList();

      if (cuisineFilters.isNotEmpty) {
        final matchesCuisine = cuisineFilters.any((filter) => fuzzyMatch(recipe.cuisine, filter.value));
        if (!matchesCuisine) return false;
      }

      if (mealTypeFilters.isNotEmpty) {
        final matchesMealType = mealTypeFilters.any(
                (filter) => recipe.mealType.any((mt) => fuzzyMatch(mt, filter.value)));
        if (!matchesMealType) return false;
      }

      if (healthGoalFilters.isNotEmpty) {
        final matchesHealthGoal = healthGoalFilters.any(
                (filter) => recipe.healthGoals.any((hg) => fuzzyMatch(hg, filter.value)));
        if (!matchesHealthGoal) return false;
      }

      if (freeTextFilters.isNotEmpty) {
        final searchText =
        '${recipe.name} ${recipe.description} ${recipe.ingredients.join(' ')}'.toLowerCase();
        final matchesFreeText = freeTextFilters.any((filter) =>
            filter.value.toLowerCase().split(' ').every((word) => searchText.contains(word)));
        if (!matchesFreeText) return false;
      }

      return true;
    }).toList();

    filteredRecipes = sortRecipes(filteredRecipes, filters.sortBy.toString());

    return SmartSearchResult(
      filteredRecipes: filteredRecipes,
      activeFilters: searchTokens,
    );
  }
}