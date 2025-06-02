import 'package:flutter/material.dart';
import 'package:frontend/common/label_input_field.dart';
import 'package:frontend/common/show_response_dialog.dart';
import 'package:frontend/model/goal.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/view_model/user_vm.dart';
import 'package:go_router/go_router.dart';

class SecondSignupScreen extends StatefulWidget {
  final User partialUser;
  const SecondSignupScreen({Key? key, required this.partialUser})
      : super(key: key);

  @override
  State<SecondSignupScreen> createState() => _SecondSignupScreenState();
}

class _SecondSignupScreenState extends State<SecondSignupScreen> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController goalWeightController = TextEditingController();
  final TextEditingController allergyController = TextEditingController();
  final UserVM viewModel = UserVM();
  DateTime? goalDate;

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    goalWeightController.dispose();
    allergyController.dispose();
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
              const Text(
                '회원가입 (2/2)',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              LabeledInputField(
                controller: heightController,
                hintText: '키 (cm)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              LabeledInputField(
                controller: weightController,
                hintText: '몸무게 (kg)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              LabeledInputField(
                controller: goalWeightController,
                hintText: '목표 몸무게 (kg)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              LabeledInputField(
                hintText: '알러지 (선택 사항)',
                controller: allergyController,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(Duration(days: 30)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Color(0xFFB8E986),
                            onPrimary: Colors.black,
                            onSurface: Colors.black,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  Color(0xFF66BB6A), // OK / Cancel 버튼 색
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      goalDate = picked;
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF2FCEB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.transparent),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.green[400]),
                      const SizedBox(width: 12),
                      Text(
                        goalDate == null
                            ? '목표 날짜 선택'
                            : '${goalDate!.year}-${goalDate!.month.toString().padLeft(2, '0')}-${goalDate!.day.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: goalDate == null ? Colors.grey : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final completedUser = User(
                      email: widget.partialUser.email,
                      password: widget.partialUser.password,
                      name: widget.partialUser.name,
                      gender: widget.partialUser.gender,
                      height: int.tryParse(heightController.text) ?? 0,
                      weight: int.tryParse(weightController.text) ?? 0,
                      age: widget.partialUser.age,
                      goal: Goal(
                        weight:
                            double.tryParse(goalWeightController.text) ?? 0.0,
                        date: goalDate ?? DateTime.now(),
                      ),
                      allergy: allergyController.text.trim(),
                    );

                    final statusCode = await viewModel.signUp(completedUser);
                    if (statusCode == 200 || statusCode == 201) {
                      showResponseDialog(
                        context,
                        statusCode,
                        '회원가입이 완료되었습니다.',
                      );
                      context.push('/login');
                    } else if (statusCode == 400) {
                      showResponseDialog(
                        context,
                        statusCode,
                        '이미 존재하는 이메일입니다.',
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '회원가입',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
