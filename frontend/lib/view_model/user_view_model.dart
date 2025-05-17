import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/common/error_dialog.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/service/auth_service.dart';

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
}
