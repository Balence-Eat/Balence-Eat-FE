import 'package:frontend/model/meal_food.dart';

class Meal {
  final int userId;
  final int mealId;
  final String mealType;
  final DateTime date;
  final List<MealFood> foods;

  Meal({
    required this.userId,
    required this.mealId,
    required this.mealType,
    required this.date,
    required this.foods,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'mealId': mealId,
      'mealType': mealType,
      'date': date.toIso8601String(),
      'foods': foods.map((food) => food.toJson()).toList(),
    };
  }

  static Meal fromJson(Map<String, dynamic> json) {
    return Meal(
      userId: json['userId'] as int,
      mealId: json['mealId'] as int,
      mealType: json['mealType'] as String,
      date: DateTime.parse(json['date'] as String),
      foods: (json['foods'] as List)
          .map((food) => MealFood.fromJson(food))
          .toList(),
    );
  }
}
