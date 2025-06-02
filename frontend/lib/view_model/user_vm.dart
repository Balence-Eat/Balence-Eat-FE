import 'package:frontend/model/user.dart';
import 'package:frontend/service/auth_service.dart';

class UserVM {
  Future<int> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return 400;
    }

    return await AuthService.login(username, password);
  }

  Future<int> signUp(User user) async {
    return await AuthService.signUp(user);
  }
}
