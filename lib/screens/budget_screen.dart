import 'package:flutter/material.dart';
import '../models/budget.dart';
import '../services/api_service.dart';
import '../utils/notifications.dart';

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final ApiService apiService = ApiService();
  final _budgetController = TextEditingController();
  List<Budget> budgets = [];
  double currentBudget = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchBudgets();
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _fetchBudgets() async {
    final fetchedBudgets = await apiService.getBudgets();
    final currentMonth = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}';
    final current = fetchedBudgets.firstWhere(
          (b) => b.month == currentMonth,
      orElse: () => Budget(id: 0, month: currentMonth, budgetAmount: 0.0),
    );
    setState(() {
      budgets = fetchedBudgets;
      currentBudget = current.budgetAmount;
    });
  }

  Future<void> _setBudget() async {
    if (_budgetController.text.isNotEmpty) {
      final budgetAmount = double.parse(_budgetController.text);
      final currentMonth = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}';
      await apiService.setBudget(currentMonth, budgetAmount);
      _budgetController.clear();
      _fetchBudgets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Budget')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Current Budget: \$${currentBudget.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _budgetController,
                      decoration: InputDecoration(
                        labelText: 'Set Monthly Budget',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Enter a budget' : null,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _setBudget,
                      child: Text('Set Budget'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Text('Budget History', style: Theme.of(context).textTheme.titleLarge),
            Expanded(
              child: ListView.builder(
                itemCount: budgets.length,
                itemBuilder: (context, index) {
                  final budget = budgets[index];
                  return Card(
                    child: ListTile(
                      title: Text('Month: ${budget.month}'),
                      subtitle: Text('Budget: \$${budget.budgetAmount.toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}