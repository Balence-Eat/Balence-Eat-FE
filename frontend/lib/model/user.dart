import 'package:frontend/model/goal.dart';

class User {
  final String email;
  final String password;
  final String name;
  final String gender;
  final int height;
  final int weight;
  final int age;
  final Goal goal;

  User(
      {required this.email,
      required this.password,
      required this.name,
      required this.gender,
      required this.height,
      required this.weight,
      required this.age,
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
      "goal": goal.toJson(),
    };
  }
}
