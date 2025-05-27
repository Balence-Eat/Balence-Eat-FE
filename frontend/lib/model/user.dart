import 'package:frontend/model/goal.dart';

class User {
  final String email;
  final String password;
  final String name;
  final String gender;
  final int height;
  final int weight;
  final int age;
  final String? allergy;
  final Goal goal;

  User(
      {required this.email,
      required this.password,
      required this.name,
      required this.gender,
      required this.height,
      required this.weight,
      required this.age,
      this.allergy,
      required this.goal});

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "name": name,
      "gender": gender,
      "height": height,
      "weight": weight,
      "age": age,
      "allergy": allergy,
      "goal": goal.toJson(),
    };
  }
}
