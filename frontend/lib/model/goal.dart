class Goal {
  final double weight;
  final DateTime date;

  Goal({required this.weight, required this.date});

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      weight: json['weight']?.toDouble() ?? 0,
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() => {
  'weight': weight,
  'date': date.toLocal().toIso8601String().split('.').first, // milliseconds 제거 + Z 없음
  };
}