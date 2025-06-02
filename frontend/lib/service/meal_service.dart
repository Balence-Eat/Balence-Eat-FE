import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:frontend/model/meal.dart';
import 'package:frontend/service/token_storage.dart';
import 'package:intl/intl.dart';

class MealService {
  static const String _baseUrl = 'http://127.0.0.1:8000'; // 백엔드 URL
  static final Dio _dio = Dio(BaseOptions(baseUrl: _baseUrl));

  static String formatDateToUTC(DateTime localDate) {
    // localDate를 UTC 자정 기준 날짜로 변환
    final utcDate =
        DateTime.utc(localDate.year, localDate.month, localDate.day);

    // ISO 8601 포맷 YYYY-MM-DD 형태로 자르기 (시간 제외)
    return DateFormat('yyyy-MM-dd').format(utcDate);
  }

  static Future<int> postMealBatch({
    required String mealType,
    required DateTime datetime,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final token = await TokenStorage.load();
      log(mealType);

      final response = await _dio.post(
        '/meals',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'meal_type': mealType,
          'datetime': datetime.toIso8601String(),
          'items': items,
        },
      );

      return response.statusCode ?? 400;
    } catch (e, st) {
      log('MealService Dio Error: $e\n$st');
      return 400;
    }
  }

  static Future<List<Meal>> getMealByDate(DateTime date) async {
    try {
      final token = await TokenStorage.load();
      var dateStr = formatDateToUTC(date);
      final response = await _dio.get(
        '/meals',
        queryParameters: {
          'date': dateStr, // UTC 자정 기준 날짜로 변환된 문자열
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = response.data as List;
      return data.map((json) => Meal.fromJson(json)).toList();
    } catch (e, st) {
      log('MealService Dio Error: $e\n$st');
      return [];
    }
  }
}
