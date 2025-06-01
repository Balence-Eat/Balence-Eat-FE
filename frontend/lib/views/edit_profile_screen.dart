import 'package:flutter/material.dart';
import 'package:frontend/service/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String password = '';
  String gender = 'M';
  int height = 170;
  int weight = 60;
  int age = 20;
  int goalWeight = 65;
  DateTime goalDate = DateTime.now();

  Future<void> _submit() async {
    final body = {
      "password": password,
      "name": name,
      "gender": gender,
      "height": height,
      "weight": weight,
      "age": age,
      "goal": {
        "weight": goalWeight,
        "date": goalDate.toIso8601String().split('Z')[0],
      }
    };

    final success = await UserService.updateProfile(body);
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("프로필 정보가 업데이트되었습니다")),
        );
        Navigator.pop(context); // 뒤로가기
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[50],
        elevation: 0,
        title: Text('프로필 수정',
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
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: '이름'),
                onChanged: (val) => name = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '비밀번호'),
                obscureText: true,
                onChanged: (val) => password = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '성별 (M/F)'),
                onChanged: (val) => gender = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '키 (cm)'),
                keyboardType: TextInputType.number,
                onChanged: (val) => height = int.tryParse(val) ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '몸무게 (kg)'),
                keyboardType: TextInputType.number,
                onChanged: (val) => weight = int.tryParse(val) ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '나이'),
                keyboardType: TextInputType.number,
                onChanged: (val) => age = int.tryParse(val) ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '목표 몸무게'),
                keyboardType: TextInputType.number,
                onChanged: (val) => goalWeight = int.tryParse(val) ?? 0,
              ),
                TextFormField(
                    decoration: const InputDecoration(labelText: '목표 날짜 (YYYY-MM-DD)'),
                    keyboardType: TextInputType.datetime,
                    onChanged: (val) {
                    try {
                        goalDate = DateTime.parse(val);
                    } catch (e) {
                        goalDate = DateTime.now();
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
