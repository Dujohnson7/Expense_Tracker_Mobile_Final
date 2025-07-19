import 'package:flutter/material.dart';
import '../models/savings_goal.dart';

class SavingsGoalTile extends StatelessWidget {
  final SavingsGoal goal;
  final Animation<double> animation;

  SavingsGoalTile({required this.goal, required this.animation});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: Card(
          child: ListTile(
            title: Text(goal.goalName),
            subtitle: Text('Goal: \$${goal.goalAmount.toStringAsFixed(2)} - Current: \$${goal.currentAmount.toStringAsFixed(2)} - Reminder: ${goal.reminderDate.toIso8601String().split('T')[0]}'),
          ),
        ),
      ),
    );
  }
}