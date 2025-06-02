import 'package:flutter/material.dart';
import 'package:frontend/common/bottom_navigation_bar.dart';
import 'package:frontend/service/token_storage.dart';
import 'package:frontend/service/user_service.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? updatedUser;

  const ProfileScreen({super.key, this.updatedUser});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.updatedUser != null) {
      profileData = widget.updatedUser;
      isLoading = false;
    } else {
      _loadProfile();
    }
  }

  Future<void> _loadProfile() async {
    final token = await TokenStorage.load();
    if (token == null) {
      setState(() {
        isLoading = false;
        profileData = null;
      });
      return;
    }

    final data = await UserService.fetchProfile(token);
    setState(() {
      profileData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (profileData == null) {
      return const Scaffold(
        body: Center(child: Text('프로필 정보를 불러올 수 없습니다.')),
      );
    }

    final goal = profileData!['goal'];

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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildProfileRow('이름', profileData!['name']),
                buildProfileRow('성별', profileData!['gender']),
                buildProfileRow('키', '${profileData!['height']} cm'),
                buildProfileRow('몸무게', '${profileData!['weight']} kg'),
                buildProfileRow('목표 몸무게', '${goal['weight']} kg'),
                buildProfileRow('목표 날짜', goal['date'].toString().split('T')[0]),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await context.push('/edit-profile');
                      _loadProfile(); // 프로필 업데이트 후 다시 불러오기
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '프로필 수정하기',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBarWidget(currentIndex: 3));
  }

  Widget buildProfileRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title:',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
