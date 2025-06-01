import 'dart:developer';
import 'package:frontend/model/food.dart';
import 'package:frontend/service/food_service.dart';

class FoodVM {
  Future<int> createFood({
    required String name,
    required int unit,
    required int caloriesPerUnit,
    required int proteinPerUnit,
    required int carbsPerUnit,
    required int fatPerUnit,
    required String allergens,
  }) async {
    final responseCode = await FoodService.postFoodBatch(
        name: name,
        unit: unit,
        caloriesPerUnit: caloriesPerUnit,
        proteinPerUnit: proteinPerUnit,
        carbsPerUnit: caloriesPerUnit,
        fatPerUnit: fatPerUnit,
        allergens: allergens);
    // responseCode를 활용하거나 추가 로직을 여기에 작성할 수 있습니다.
    log('식사 생성 응답 코드: $responseCode');
    return responseCode;
  }

  Future<List<Food>> getFoods() async {
    try {
      final foodList = await FoodService.fetchFoods();
      log('음식 조회 응답 : $foodList');
      return foodList;
    } catch (e) {
      throw Exception('음식 조회 실패: $e');
    }
  }
}
