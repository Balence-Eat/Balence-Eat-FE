import 'package:flutter/material.dart';
import 'package:frontend/common/bottom_navigation_bar.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/service/token_storage.dart';
import 'package:go_router/go_router.dart';
import 'profile_screen.dart';

class ProfileLogin extends StatefulWidget {
  const ProfileLogin({super.key});

  @override
  State<ProfileLogin> createState() => _ProfileLoginState();
}

class _ProfileLoginState extends State<ProfileLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _handleLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final success = await AuthService.login(email, password);

    if (success == 200 || success == 201) {
      // 로그인 성공 시 ProfileScreen 으로 이동
      if (context.mounted) {
        context.go('/profile/detail');
      }
    } else {
      setState(() {
        _errorMessage = "아이디 또는 비밀번호를 다시 확인해주세요";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[50],
          elevation: 0,
          title: Text(
            '프로필',
            style: TextStyle(
              color: Colors.green[700],
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.green[700]),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('로그인해주세요'),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: '아이디'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(hintText: '비밀번호'),
              ),
              const SizedBox(height: 12),
              if (_errorMessage != null)
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handleLogin,
                child: const Text('로그인'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBarWidget(currentIndex: 3));
  }
}
