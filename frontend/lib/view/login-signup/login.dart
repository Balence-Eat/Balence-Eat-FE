import 'package:flutter/material.dart';
import 'package:frontend/common/show_response_dialog.dart';
import 'package:frontend/view_model/user_vm.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  final UserVM userVM = UserVM();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Balance Eat!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.green[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Text(
                '로그인',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: '이메일',
                  filled: true,
                  fillColor: const Color(0xFFF2FCEB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '비밀번호',
                  filled: true,
                  fillColor: const Color(0xFFF2FCEB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // SizedBox(
              //   height: 50,
              //   child: ElevatedButton(
              //     onPressed: () async {
              //       final success = await viewModel.login(
              //           usernameController.text, passwordController.text);
              //       if (success) {
              //         context.push('/home');
              //       } else {
              //         ErrorDialog.show(
              //           context,
              //           title: '로그인 실패',
              //           content: '사용자 이름과 비밀번호를 확인하세요.',
              //         );
              //       }
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.green[500],
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //     ),
              //     child: const Text(
              //       '로그인',
              //       style: TextStyle(fontSize: 16),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final statusCode = await userVM.login(
                        emailController.text, passwordController.text);
                    if (statusCode == 200) {
                      context.push('/home');
                    } else if (statusCode == 401) {
                      showResponseDialog(context, 401, "아이디 또는 비밀번호가 잘못되었습니다.");
                    } else {
                      showResponseDialog(context, statusCode, "로그인에 실패했습니다.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '로그인',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () {
                    context.push('/first-signup');
                  },
                  child: const Text(
                    '계정이 없으신가요? | 회원가입',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
