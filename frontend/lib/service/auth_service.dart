import 'dart:convert';
import 'dart:developer';

import 'package:frontend/model/user.dart';
import 'package:frontend/service/token_service.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/model/user_profile.dart';

class AuthService {
  static bool useMock = false;

  static Future<int> login(String username, String password) async {
    // 실제 서버 연동 모드
    final url = Uri.parse('http://127.0.0.1:8000/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'password',
        'username': username,
        'password': password,
        'scope': '',
        'client_id': '',
        'client_secret': '',
      },
    );

    log('응답 코드: ${response.statusCode}');
    log('응답 본문: ${utf8.decode(response.bodyBytes)}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await TokenStorage.save(data['access_token']);
      return response.statusCode;
    }
    return response.statusCode;
  }

  static Future<int> signUp(User user) async {
    final url = Uri.parse('http://127.0.0.1:8000/signup');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    log('응답 코드: ${response.statusCode}');
    log('응답 본문: ${utf8.decode(response.bodyBytes)}');

    return response.statusCode;
  }

  static Future<UserProfile?> getProfile() async {
    final token = await TokenStorage.load();
    if (token == null) {
      print('토큰 없음');
      return null;
    }

    final url = Uri.parse('http://127.0.0.1:8000/profile');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserProfile.fromJson(data);
    } else {
      print('프로필 가져오기 실패: ${response.statusCode}');
      print(response.body);
      return null;
    }
  }
}
