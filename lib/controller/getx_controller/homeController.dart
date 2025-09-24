import 'package:get/get.dart';

class HomeController extends GetxController {
  /// Selected values
  RxString? selectedCuisine = RxString('');
  RxString? selectedMeal = RxString('');
  RxString? selectedHealth = RxString('');
  RxString selectedSort = "Name (A-Z)".obs;

  /// Options
  final List<String> cuisines = [
    "Italian",
    "Chinese",
    "Pakistani",
    "Indian",
  ];

  final List<String> mealTypes = [
    "Breakfast",
    "Lunch",
    "Dinner",
    "Snack",
  ];

  final List<String> healthGoals = [
    "Cardiovascular Wellness",
    "Blood Sugar Friendly",
    "Cholesterol Friendly",
    "Kidney Friendly",
  ];

  final List<String> sortOptions = [
    "Name (A-Z)",
    "Newest First",
    "Most Popular",
    "Lowest Calories",
    "Highest Calories",
    "Highest Protein",
    "Lowest Protein"
  ];
}
