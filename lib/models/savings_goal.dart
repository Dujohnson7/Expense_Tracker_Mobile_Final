class SavingsGoal {
  final int id;
  final String goalName;
  final double goalAmount;
  final double currentAmount;
  final DateTime reminderDate;

  SavingsGoal({
    required this.id,
    required this.goalName,
    required this.goalAmount,
    required this.currentAmount,
    required this.reminderDate,
  });

  factory SavingsGoal.fromJson(Map<String, dynamic> json) {
    return SavingsGoal(
      id: json['id'],
      goalName: json['goal_name'],
      goalAmount: (json['goal_amount'] as num).toDouble(),
      currentAmount: (json['current_amount'] as num).toDouble(),
      reminderDate: DateTime.parse(json['reminder_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goal_name': goalName,
      'goal_amount': goalAmount,
      'current_amount': currentAmount,
      'reminder_date': reminderDate.toIso8601String(),
    };
  }
}