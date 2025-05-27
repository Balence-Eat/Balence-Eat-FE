class Food {
  final int foodId;
  final String name;
  final int? unit;
  final int? caloriesPerUnit;
  final int? proteinPerUnit;
  final int? carbsPerUnit;
  final int? fatPerUnit;
  final String? allergens;

  Food({
    required this.foodId,
    required this.name,
    this.unit,
    this.caloriesPerUnit,
    this.proteinPerUnit,
    this.carbsPerUnit,
    this.fatPerUnit,
    this.allergens,
  });
  factory Food.fromJson(Map<String, dynamic> json) => Food(
        foodId: json['food_id'],
        name: json['name'],
        unit: json['unit'],
        caloriesPerUnit: json['calories_per_unit'],
        proteinPerUnit: json['protein_per_unit'],
        carbsPerUnit: json['carbs_per_unit'],
        fatPerUnit: json['fat_per_unit'],
        allergens: json['allergens'],
      );

  Map<String, dynamic> toJson() => {
        'food_id': foodId,
        'name': name,
        'unit': unit,
        'calories_per_unit': caloriesPerUnit,
        'protein_per_unit': proteinPerUnit,
        'carbs_per_unit': carbsPerUnit,
        'fat_per_unit': fatPerUnit,
        'allergens': allergens,
      };
}
