// 모델 클래스 (실제는 별도 파일에 두는 게 좋음)
class Inventory {
  final int foodId;
  final String foodName;
  final int quantity;

  Inventory({
    required this.foodId,
    required this.foodName,
    required this.quantity,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      foodId: json['food_id'],
      foodName: json['food_name'],
      quantity: json['quantity'],
    );
  }
}
