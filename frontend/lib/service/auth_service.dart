import 'dart:convert';
import 'dart:developer';

import 'package:frontend/model/user.dart';
import 'package:frontend/service/token_stoarage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static bool useMock = true;

  static Future<bool> login(String username, String password) async {
    if (useMock) {
      // 더미 테스트 모드
      if (username == 'test1' && password == '1234') {
        await TokenStorage.save('fake_access_token_123456');
        return true;
      } else {
        return false;
      }
    }

    // 실제 서버 연동 모드
    final url = Uri.parse('http://localhost:3000/api/v1/login');
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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await TokenStorage.save(data['access_token']);
      return true;
    }

    return false;
  }

  static Future<bool> signUp(User user) async {
    if (useMock) {
      log('[MOCK] 회원가입 성공 처리됨');
      return true;
    }

    final url = Uri.parse('http://localhost:3000/api/v1/users/signup');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    log('응답 코드: ${response.statusCode}');
    log('응답 본문: ${response.body}');

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
