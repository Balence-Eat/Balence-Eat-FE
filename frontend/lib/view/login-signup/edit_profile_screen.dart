import 'package:flutter/material.dart';
import 'package:frontend/service/user_service.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String gender = 'M';
  int height = 170;
  int weight = 60;
  int age = 20;
  int goalWeight = 65;
  DateTime goalDate = DateTime.now();

  Future<void> _submit() async {
    final body = {
      "name": name,
      "height": height,
      "weight": weight,
      "age": age,
      "goal": {
        "weight": goalWeight.toInt(),
        "date": goalDate.toIso8601String().split("T")[0],
      }
    };

    print("보낼 데이터: $body");

    final success = await UserService.updateProfile(body);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("프로필 정보가 업데이트되었습니다")),
      );
      context.pop(context); // 이전 화면으로 돌아가기
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[50],
        elevation: 0,
        title: Text(
          '프로필 수정',
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
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: '이름'),
                onChanged: (val) => setState(() => name = val),
              ),
              // 성별 입력이 필요하면 이 부분 활성화하세요
              // TextFormField(
              //   decoration: const InputDecoration(labelText: '성별 (M/F)'),
              //   onChanged: (val) => setState(() => gender = val),
              // ),
              TextFormField(
                decoration: const InputDecoration(labelText: '키 (cm)'),
                keyboardType: TextInputType.number,
                onChanged: (val) =>
                    setState(() => height = int.tryParse(val) ?? 0),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '몸무게 (kg)'),
                keyboardType: TextInputType.number,
                onChanged: (val) =>
                    setState(() => weight = int.tryParse(val) ?? 0),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '나이'),
                keyboardType: TextInputType.number,
                onChanged: (val) =>
                    setState(() => age = int.tryParse(val) ?? 0),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '목표 몸무게'),
                keyboardType: TextInputType.number,
                onChanged: (val) =>
                    setState(() => goalWeight = int.tryParse(val) ?? 0),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: '목표 날짜 (YYYY-MM-DD)'),
                keyboardType: TextInputType.datetime,
                onChanged: (val) {
                  try {
                    setState(() => goalDate = DateTime.parse(val));
                  } catch (e) {
                    // 잘못된 날짜 포맷은 무시
                  }
                },
              ),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("저장"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
