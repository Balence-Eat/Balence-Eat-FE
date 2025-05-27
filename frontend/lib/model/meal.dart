import 'package:frontend/model/meal_food.dart';

class Meal {
  final int mealId;
  final DateTime datetime;
  final String mealType;
  final List<MealFood>? mealFoods;

  // total 추가
  final int totalCalories;
  final int totalProtein;
  final int totalCarbs;
  final int totalFat;
  // 생성자

  Meal({
    required this.mealId,
    required this.datetime,
    required this.mealType,
    this.mealFoods,
    this.totalCalories = 0,
    this.totalProtein = 0,
    this.totalCarbs = 0,
    this.totalFat = 0,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    final total = json['total'] ?? {};

    return Meal(
      mealId: json['meal_id'],
      mealType: json['meal_type'], // 기본값 fallback 처리
      datetime: DateTime.parse(json['datetime']),
      mealFoods: (json['foods'] as List<dynamic>?)
          ?.map((item) => MealFood.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalCalories: total['calories'] ?? 0,
      totalProtein: total['protein'] ?? 0,
      totalCarbs: total['carbs'] ?? 0,
      totalFat: total['fat'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'meal_id': mealId,
      'meal_type': mealType.toString(),
      'datetime': datetime.toIso8601String(),
      'meal_foods': mealFoods?.map((item) => item.toJson()).toList(),
    };
  }
}
