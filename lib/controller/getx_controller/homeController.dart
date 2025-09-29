import 'package:get/get.dart';

class HomeController extends GetxController {
  /// Selected values
  RxString? selectedCuisine = RxString('');
  RxString? selectedMeal = RxString('');
  RxString? selectedHealth = RxString('');
  RxString selectedSort = "Name (A-Z)".obs;

  /// Options
  final List<String> cuisines = [
    "Chinese",
    "Japanese",
    "Korean",
    "Vietnamese",
    "Thai",
    "Italian",
    "French",
    "Mexican",
    "American",
    "Mediterranean",
    "Global",
    "Fusion",
    "Vegetarian",
    "Vegan",
    "Gluten-Free",
  ];

  final List<String> mealTypes = [
    "Breakfast",
    "Lunch",
    "Dinner",
    "Romantic",
    "Birthday",
    "Party",
    "Special",
    "Occasion",
    "Dessert",
    "Staple Food",
  ];

  final List<String> healthGoals = [
    "Cardiovascular Wellness",
    "Blood Sugar Friendly",
    "Cholesterol Friendly",
    "Kidney Friendly",
    "Liver Friendly",
    "Digestive Health",
    "Gut Health",
    "Healthy Weight",
    "Lower Sodium",
    "Lower Carb",
    "High Fiber",
    "Immune Wellness",
    "Senior-Friendly",
    "Iron Rich",
    "Higher in Protein",
    "Bone Health",
    "Brain Boost",
    "Supports Thyroid Health",
    "Supports Lung Health",
    "Skin & Hair Health",
    "Energy Boost",
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
