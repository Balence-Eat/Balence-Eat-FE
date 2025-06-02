import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:frontend/model/inventory.dart';
import 'package:frontend/service/token_storage.dart';

class InventoryService {
  static const String _baseUrl = 'http://127.0.0.1:8000'; // 백엔드 URL
  static final Dio _dio = Dio(BaseOptions(baseUrl: _baseUrl));

  static Future<List<Inventory>> getInventory() async {
    try {
      final token = await TokenStorage.load();
      final response = await _dio.get(
        '/inventory',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      final data = response.data;
      log(data.toString());

      if (data is List) {
        log(data.map((item) => Inventory.fromJson(item)).toList().toString());
        return data.map((item) => Inventory.fromJson(item)).toList();
      } else if (data is Map &&
          data.containsKey('data') &&
          data['data'] is List) {
        // 백엔드가 {"data": [...]} 식으로 응답하는 경우
        return (data['data'] as List)
            .map((item) => Inventory.fromJson(item))
            .toList();
      } else {
        throw Exception('예상하지 못한 응답 형식: $data');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  static Future<int> addInventory(int foodId, int quantity) async {
    try {
      final token = await TokenStorage.load();
      final response = await _dio.post(
        '/inventory',
        data: {
          'food_id': foodId,
          'quantity': quantity,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.statusCode ?? 500;
    } on DioException catch (e) {
      log('Dio error: ${e.response?.data ?? e.message}');
      return e.response?.statusCode ?? 500;
    } catch (e) {
      log('Unexpected error: $e');
      return 500;
    }
  }
}
