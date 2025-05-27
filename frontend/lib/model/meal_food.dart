import 'package:frontend/model/food.dart';

class MealFood {
  int? id;
  int? mealId;
  int? foodId;
  final int? quantity;
  final int? calories;
  final int? protein;
  final int? carbs;
  final int? fat;
  final Food? food;

  final String? foodName;

  MealFood({
    this.id,
    this.mealId,
    this.foodId,
    this.quantity,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.food,
    this.foodName,
  });
  factory MealFood.fromJson(Map<String, dynamic> json) {
    return MealFood(
      id: json['id'],
      mealId: json['meal_id'],
      foodId: json['food_id'],
      quantity: json['quantity'],
      calories: json['calories'],
      protein: json['protein'],
      carbs: json['carbs'],
      fat: json['fat'],
      foodName: json['food_name'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'meal_id': mealId,
      'food_id': foodId,
      'quantity': quantity,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'food': food?.toJson(),
    };
  }

  // JSON 메서드 추가
}
