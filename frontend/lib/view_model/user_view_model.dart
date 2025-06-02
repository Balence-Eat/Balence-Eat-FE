import 'dart:developer';

import 'package:frontend/model/user.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/model/user_profile.dart';
import 'package:frontend/service/token_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserViewModel {
  Future<bool> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return false;
    }

    return await AuthService.login(username, password);
  }

  Future<bool> signUp(User user) async {
    try {
      final success = await AuthService.signUp(user);
      if (success) {
        log('회원가입 성공');
      } else {
        log('회원가입 실패');
      }
      return success;
    } catch (e) {
      log('회원가입 실패: $e');
      return false;
    }
  }

  Future<UserProfile?> fetchProfile() async {
    UserProfile? userProfile;
    final token = await TokenStorage.load();
    final url = Uri.parse('http://localhost:8000/profile');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      userProfile = UserProfile.fromJson(data);
      return userProfile;
    } else {
      log('프로필 가져오기 실패: ${response.statusCode}');
      return null;
    }
  }
}
