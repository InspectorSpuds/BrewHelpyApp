import 'package:brewhelpy/recipe_steps.dart';

class Recipe {
  final String name;
  final String brewMethod;
  final int coffeeMass;
  final int brewTemp;
  final int totalTime;
  final List<RecipeStep> steps;

  Recipe({
    required this.name,
    required this.brewMethod,
    required this.coffeeMass,
    required this.brewTemp,
    required this.totalTime,
    required this.steps,
  });
}