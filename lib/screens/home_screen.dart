import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../models/budget.dart';
import '../models/savings_goal.dart';
import '../services/api_service.dart';
import '../widgets/expense_tile.dart';
import '../widgets/savings_goal_tile.dart';
import '../theme/app_theme.dart';
import 'add_expense_screen.dart';
import 'budget_screen.dart';
import 'savings_goal_screen.dart';
import 'reports_screen.dart';
import '../utils/notifications.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final ApiService apiService = ApiService();
  List<Expense> expenses = [];
  double budget = 0.0;
  List<SavingsGoal> savingsGoals = [];
  AnimationController? _animationController;
  final GlobalKey<AnimatedListState> _expenseListKey = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _goalListKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fetchData();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    final fetchedExpenses = await apiService.getExpenses();
    final budgets = await apiService.getBudgets();
    final goals = await apiService.getSavingsGoals();
    final currentMonth = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}';
    final currentBudget = budgets.firstWhere(
          (b) => b.month == currentMonth,
      orElse: () => Budget(id: 0, month: currentMonth, budgetAmount: 0.0),
    );
    setState(() {
      expenses = fetchedExpenses;
      budget = currentBudget.budgetAmount;
      savingsGoals = goals;
    });
    _checkBudget();
    _checkReminders();
  }

  Future<void> _checkBudget() async {
    final currentMonth = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}';
    final totalSpent = expenses
        .where((e) => e.date.toIso8601String().startsWith(currentMonth))
        .fold(0.0, (sum, e) => sum + e.amount);
    if (budget > 0 && totalSpent > budget) {
      await showBudgetNotification(totalSpent, budget);
    }
  }

  Future<void> _checkReminders() async {
    final today = DateTime.now();
    for (var goal in savingsGoals) {
      if (goal.reminderDate.year == today.year &&
          goal.reminderDate.month == today.month &&
          goal.reminderDate.day == today.day) {
        await showSavingsGoalReminder(goal.id, goal.goalName, goal.goalAmount, goal.currentAmount);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current Budget: \$${budget.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddExpenseScreen())),
                        child: Text('Add Expense'),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BudgetScreen())),
                        child: Text('Manage Budget'),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SavingsGoalScreen())),
                        child: Text('Manage Savings Goals'),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReportsScreen())),
                        child: Text('View Reports'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Recent Expenses', style: Theme.of(context).textTheme.titleLarge),
            ),
            AnimatedList(
              key: _expenseListKey,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              initialItemCount: expenses.length > 5 ? 5 : expenses.length,
              itemBuilder: (context, index, animation) {
                return ExpenseTile(
                  expense: expenses[index],
                  animation: animation,
                  onDelete: () async {
                    final removedExpense = expenses[index];
                    setState(() {
                      expenses.removeAt(index);
                      _expenseListKey.currentState?.removeItem(
                        index,
                            (context, animation) => ExpenseTile(expense: removedExpense, animation: animation, onDelete: () {}),
                        duration: Duration(milliseconds: 300),
                      );
                    });
                    await apiService.deleteExpense(removedExpense.id);
                    _fetchData();
                  },
                );
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Savings Goals', style: Theme.of(context).textTheme.titleLarge),
            ),
            AnimatedList(
              key: _goalListKey,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              initialItemCount: savingsGoals.length > 3 ? 3 : savingsGoals.length,
              itemBuilder: (context, index, animation) {
                return SavingsGoalTile(goal: savingsGoals[index], animation: animation);
              },
            ),
          ],
        ),
      ),
    );
  }
}