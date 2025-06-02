import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:frontend/model/food.dart';
import 'package:frontend/service/token_storage.dart';

class FoodService {
  static const String _baseUrl = 'http://127.0.0.1:8000'; // 백엔드 URL
  static final Dio _dio = Dio(BaseOptions(baseUrl: _baseUrl));

  static Future<int> postFoodBatch({
    required String name,
    required int unit,
    required int caloriesPerUnit,
    required int proteinPerUnit,
    required int carbsPerUnit,
    required int fatPerUnit,
    required String allergens,
  }) async {
    try {
      final token = await TokenStorage.load();
      final response = await _dio.post(
        '/foods',
        data: {
          "name": name,
          "unit": unit,
          "calories_per_unit": caloriesPerUnit,
          "protein_per_unit": proteinPerUnit,
          "carbs_per_unit": carbsPerUnit,
          "fat_per_unit": fatPerUnit,
          "allergens": allergens,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response.statusCode ?? 400;
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  static Future<List<Food>> fetchFoods() async {
    try {
      final token = await TokenStorage.load();
      final response = await _dio.get(
        '/foods',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log('[응답 전체 출력] ${response.data}');

      final List<dynamic> data = response.data;
      return data.map((json) => Food.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
