import 'package:flutter/material.dart';
import '../models/savings_goal.dart';
import '../services/api_service.dart';
import '../widgets/savings_goal_tile.dart';

class SavingsGoalScreen extends StatefulWidget {
  @override
  _SavingsGoalScreenState createState() => _SavingsGoalScreenState();
}

class _SavingsGoalScreenState extends State<SavingsGoalScreen> {
  final ApiService apiService = ApiService();
  final _goalNameController = TextEditingController();
  final _goalAmountController = TextEditingController();
  final _reminderDateController = TextEditingController();
  List<SavingsGoal> savingsGoals = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _fetchGoals();
  }

  @override
  void dispose() {
    _goalNameController.dispose();
    _goalAmountController.dispose();
    _reminderDateController.dispose();
    super.dispose();
  }

  Future<void> _fetchGoals() async {
    final goals = await apiService.getSavingsGoals();
    setState(() {
      savingsGoals = goals;
    });
  }

  Future<void> _addSavingsGoal() async {
    if (_goalNameController.text.isNotEmpty &&
        _goalAmountController.text.isNotEmpty &&
        _reminderDateController.text.isNotEmpty) {
      final goal = SavingsGoal(
        id: DateTime.now().millisecondsSinceEpoch,
        goalName: _goalNameController.text,
        goalAmount: double.parse(_goalAmountController.text),
        currentAmount: 0.0,
        reminderDate: DateTime.parse(_reminderDateController.text),
      );
      await apiService.addSavingsGoal(goal);
      setState(() {
        savingsGoals.add(goal);
        _listKey.currentState?.insertItem(savingsGoals.length - 1);
      });
      _goalNameController.clear();
      _goalAmountController.clear();
      _reminderDateController.clear();
      _fetchGoals();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Savings Goals')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _goalNameController,
                      decoration: InputDecoration(
                        labelText: 'Goal Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value!.isEmpty ? 'Enter a goal name' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _goalAmountController,
                      decoration: InputDecoration(
                        labelText: 'Goal Amount',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Enter a goal amount' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _reminderDateController,
                      decoration: InputDecoration(
                        labelText: 'Reminder Date (YYYY-MM-DD)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value!.isEmpty ? 'Enter a date' : null,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addSavingsGoal,
                      child: Text('Add Savings Goal'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: AnimatedList(
                key: _listKey,
                initialItemCount: savingsGoals.length,
                itemBuilder: (context, index, animation) {
                  return SavingsGoalTile(goal: savingsGoals[index], animation: animation);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}