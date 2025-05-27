import 'dart:convert';
import 'dart:developer';

import 'package:frontend/model/user.dart';
import 'package:frontend/service/token_service.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static bool useMock = true;

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
}
