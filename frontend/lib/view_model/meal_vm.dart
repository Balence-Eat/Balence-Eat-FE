import 'dart:developer';
import 'package:frontend/model/meal.dart';
import 'package:frontend/service/meal_service.dart';

class MealVM {
  Future<int> createMeal(String mealType, DateTime datetime,
      List<Map<String, dynamic>> items) async {
    final responseCode = await MealService.postMealBatch(
      mealType: mealType,
      datetime: datetime,
      items: items,
    );
    log('식사 생성 응답 코드: $responseCode');
    return responseCode;
  }

  Future<List<Meal>> fetchMealDate(DateTime date) async {
    final response = await MealService.getMealByDate(date);
    log('식사 데이터 조회 응답 : ${response.map((m) => m.toJson()).toList()}');
    if (response.isNotEmpty) {
      return response;
    } else {
      return [];
    }
  }
}
