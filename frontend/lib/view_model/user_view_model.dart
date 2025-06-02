import 'dart:developer';

import 'package:frontend/model/user.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/model/user_profile.dart';
import 'package:frontend/service/token_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserViewModel {
  Future<int> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return 400;
    }
    return await AuthService.login(username, password);
  }

  Future<int> signUp(User user) async {
    return await AuthService.signUp(user);
  }

  Future<UserProfile?> fetchProfile() async {
    UserProfile? userProfile;
    final token = await TokenStorage.load();
    final url = Uri.parse('http://127.0.0.1:8000');

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
