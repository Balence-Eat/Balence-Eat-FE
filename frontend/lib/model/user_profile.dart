import 'package:frontend/model/goal.dart';

class UserProfile {
  final String name;
  final String gender;
  final int height;
  final int weight;
  final Goal goal;

  UserProfile({
    required this.name,
    required this.gender,
    required this.height,
    required this.weight,
    required this.goal,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
  if (json['goal'] == null) {
    throw Exception("goal 정보가 누락되었습니다.");
  }

  return UserProfile(
    name: json['name'] ?? '',
    gender: json['gender'] ?? '',
    height: json['height'] ?? 0,
    weight: json['weight'] ?? 0,
    goal: Goal.fromJson(json['goal']),
  );
}

  Map<String, dynamic> toJson() => {
        'name': name,
        'gender': gender,
        'height': height,
        'weight': weight,
        'goal': goal.toJson(),
      };
}
