import 'package:flutter/material.dart';
import 'package:frontend/common/error_dialog.dart';
import 'package:frontend/common/label_input_field.dart';
import 'package:frontend/model/goal.dart';

import 'package:frontend/model/user.dart';
import 'package:frontend/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers for user input
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController goalWeightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  final UserViewModel viewModel = UserViewModel();

  String? gender; // 'M' or 'F'

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    heightController.dispose();
    weightController.dispose();
    goalWeightController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.green[700],
          onPressed: () {
            context.pop();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
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
                const Text(
                  '회원가입(1/2)',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                LabeledInputField(
                  controller: emailController,
                  hintText: '이메일',
                ),
                const SizedBox(height: 16),
                LabeledInputField(
                  controller: passwordController,
                  hintText: '비밀번호',
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                LabeledInputField(
                  controller: nameController,
                  hintText: '이름',
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: gender,
                  items: [
                    DropdownMenuItem(value: 'M', child: Text('남성')),
                    DropdownMenuItem(value: 'F', child: Text('여성')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      gender = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: '성별',
                    filled: true,
                    fillColor: Color(0xFFF2FCEB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                LabeledInputField(
                  controller: ageController,
                  hintText: '나이',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // 성공 시 User 일부 정보만 담아 second_signup으로 전달
                      final partialUser = User(
                        name: nameController.text,
                        gender: gender ?? '',
                        height: 0,
                        weight: 0,
                        age: int.tryParse(ageController.text) ?? 0,
                        email: emailController.text,
                        password: passwordController.text,
                        goal: Goal(
                          weight: 0.0,
                          date: DateTime.now(),
                        ),
                      );

                      context.push('/second_signup', extra: partialUser);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[500],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '계속',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      context.push('/login');
                    },
                    child: const Text(
                      '이미 계정이 있으신가요? | 로그인',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
