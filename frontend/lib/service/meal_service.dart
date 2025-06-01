import 'dart:convert';
import 'dart:developer';

import 'package:frontend/model/meal.dart';
import 'package:frontend/service/token_storage.dart';
import 'package:http/http.dart' as http;

class MealService {
  static const String _baseUrl = 'https://your-api.com/api/v1';

  static Future<int> postMeal(Meal meal) async {
    try {
      log('[MOCK] Meal 전송됨: ${jsonEncode(meal.toJson())}');
      final token = await TokenStorage.load();

      final response = await http.post(
        Uri.parse('$_baseUrl/meals'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(meal.toJson()),
      );

      return response.statusCode;
    } catch (e) {
      log('MealService Error: $e');
      throw Exception('Failed to post meal');
    }
  }
}
