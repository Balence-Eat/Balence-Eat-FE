class Goal {
  final double weight;
  final DateTime date;

  Goal({
    required this.weight,
    required this.date,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    print("goal json: $json");

    final weight = json['weight'];
    final date = json['date'];

    if (weight == null || date == null) {
      throw FormatException("goal 안의 데이터가 누락됨: $json");
    }

    return Goal(
      weight: weight.toDouble(),
      date: DateTime.parse(date),
    );
  }

  Map<String, dynamic> toJson() => {
        'weight': weight,
        'date': date.toIso8601String().split('T')[0] // 시간대 제거
      };
}
