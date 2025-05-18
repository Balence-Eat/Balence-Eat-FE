class MealFood {
  final int id;
  final String title;
  final int quantity;
  final int calories;
  final int protein;
  final int fat;
  final int carbs;

  MealFood({
    required this.id,
    required this.title,
    required this.quantity,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'quantity': quantity,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
    };
  }

  factory MealFood.fromJson(Map<String, dynamic> json) {
    return MealFood(
      id: json['id'] as int,
      title: json['title'] as String,
      quantity: json['quantity'] as int,
      calories: json['calories'] as int,
      protein: json['protein'] as int,
      fat: json['fat'] as int,
      carbs: json['carbs'] as int,
    );
  }
}
