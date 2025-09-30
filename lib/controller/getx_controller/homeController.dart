import 'package:get/get.dart';
import 'package:eatro/model/recipe_model.dart';

class HomeController extends GetxController {
  final searchQuery = ''.obs;
  final filterState = FilterState().obs;

  void updateFilter({
    String? searchTerm,
    List<String>? cuisines,
    List<String>? mealTypes,
    List<String>? healthGoals,
    String? sortBy,
  }) {
    filterState.value = filterState.value.copyWith(
      searchTerm: searchTerm,
      cuisines: cuisines,
      mealTypes: mealTypes,
      healthGoals: healthGoals,
      sortBy: sortBy,
    );
  }

  void resetFilters() {
    searchQuery.value = '';
    filterState.value = FilterState();
  }
}