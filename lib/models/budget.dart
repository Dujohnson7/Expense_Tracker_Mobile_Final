class Budget {
  final int id;
  final String month;
  final double budgetAmount;

  Budget({
    required this.id,
    required this.month,
    required this.budgetAmount,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      month: json['month'],
      budgetAmount: (json['budget_amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'month': month,
      'budget_amount': budgetAmount,
    };
  }
}