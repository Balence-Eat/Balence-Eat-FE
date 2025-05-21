class Goal {
  final double weight;
  final DateTime date;

  Goal({
    required this.weight,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'date': date.toIso8601String(),
    };
  }
}
