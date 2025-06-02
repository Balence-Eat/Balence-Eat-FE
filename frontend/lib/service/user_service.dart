import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/model/user_profile.dart';
import 'token_storage.dart';

class UserService {
  static const String baseUrl = 'http://127.0.0.1:8000'; // PC에서 테스트 시
  static const String profileUrl = '$baseUrl/profile';

  static Future<Map<String, dynamic>?> fetchProfile(String token) async {
    final response = await http.get(
      Uri.parse(profileUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print('프로필 요청 실패: ${response.statusCode}');
      return null;
    }
  }

  static Future<bool> updateProfile(Map<String, dynamic> data) async {
    final token = await TokenStorage.load();
      if (token == null || token.isEmpty) {
        print("토큰 비어있음");
      } else {
        print("토큰: $token");
      }

    final response = await http.patch(
      Uri.parse('$baseUrl/profile/edit-profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    print('응답 코드: ${response.statusCode}');
    print('응답 본문: ${response.body}');

    return response.statusCode == 200;
  }
}
