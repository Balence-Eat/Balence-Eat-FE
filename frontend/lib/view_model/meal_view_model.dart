import 'dart:developer';
import 'package:frontend/service/meal_service.dart';

import 'package:frontend/model/meal.dart';

class MealViewModel {
  Future<bool> createMeal(Meal meal) async {
    final responseCode = await MealService.postMeal(meal);
    if (responseCode == 200 || responseCode == 201) {
      log('식사 등록 성공');
      return true;
    } else {
      log('식사 등록 실패: $responseCode');
      return false;
    }
  }
}
