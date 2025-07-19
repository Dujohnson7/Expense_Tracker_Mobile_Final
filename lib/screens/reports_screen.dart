import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';
import '../models/expense.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ApiService apiService = ApiService();
  List<Expense> expenses = [];
  String? _selectedCategoryFilter;
  final List<String> _categories = ['All', 'Food', 'Transport', 'Entertainment', 'Education', 'Other'];

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  Future<void> _fetchExpenses() async {
    final fetchedExpenses = await apiService.getExpenses();
    setState(() {
      expenses = fetchedExpenses;
    });
  }

  Map<String, double> _calculateSpendingByCategory() {
    final Map<String, double> spending = {};
    for (var expense in expenses) {
      if (_selectedCategoryFilter == null || _selectedCategoryFilter == 'All' || expense.category == _selectedCategoryFilter) {
        spending[expense.category] = (spending[expense.category] ?? 0) + expense.amount;
      }
    }
    return spending;
  }

  @override
  Widget build(BuildContext context) {
    final spending = _calculateSpendingByCategory();
    final pieChartSections = spending.entries.toList().asMap().map((index, entry) => MapEntry(
      index,
      PieChartSectionData(
        color: [
          Colors.red,
          Colors.blue,
          Colors.yellow,
          Colors.cyan,
          Colors.purple,
          Colors.orange
        ][index % 6],
        value: entry.value,
        title: '${entry.key}\n\$${entry.value.toStringAsFixed(2)}',
        radius: 100,
        titleStyle: TextStyle(fontSize: 12, color: Colors.white),
      ),
    )).values.toList();

    return Scaffold(
      appBar: AppBar(title: Text('Spending Reports')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter by Category:', style: Theme.of(context).textTheme.titleLarge),
            Wrap(
              spacing: 8.0,
              children: _categories.map((category) {
                return ChoiceChip(
                  label: Text(category),
                  selected: _selectedCategoryFilter == category || (category == 'All' && _selectedCategoryFilter == null),
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategoryFilter = selected && category != 'All' ? category : null;
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text('Spending by Category', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16),
            Expanded(
              child: pieChartSections.isEmpty
                  ? Center(child: Text('No data available'))
                  : PieChart(
                PieChartData(
                  sections: pieChartSections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}