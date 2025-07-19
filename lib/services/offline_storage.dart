import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/expense.dart';
import '../models/budget.dart';
import '../models/savings_goal.dart';

class OfflineStorage {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'expense_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expenses (
            id INTEGER PRIMARY KEY,
            title TEXT,
            amount REAL,
            date TEXT,
            category TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE budgets (
            id INTEGER PRIMARY KEY,
            month TEXT,
            budget_amount REAL
          )
        ''');
        await db.execute('''
          CREATE TABLE savings_goals (
            id INTEGER PRIMARY KEY,
            goal_name TEXT,
            goal_amount REAL,
            current_amount REAL,
            reminder_date TEXT
          )
        ''');
      },
    );
  }

  Future<void> saveExpense(Expense expense) async {
    final db = await database;
    await db.insert(
      'expenses',
      {
        'id': expense.id,
        'title': expense.title,
        'amount': expense.amount,
        'date': expense.date.toIso8601String(),
        'category': expense.category,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('expenses');
    return maps.map((m) => Expense(
      id: m['id'],
      title: m['title'],
      amount: m['amount'],
      date: DateTime.parse(m['date']),
      category: m['category'],
    )).toList();
  }

  Future<void> deleteExpense(int id) async {
    final db = await database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> saveBudget(String month, double budgetAmount) async {
    final db = await database;
    await db.insert(
      'budgets',
      {
        'id': DateTime.now().millisecondsSinceEpoch,
        'month': month,
        'budget_amount': budgetAmount,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Budget>> getBudgets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('budgets');
    return maps.map((m) => Budget(
      id: m['id'],
      month: m['month'],
      budgetAmount: m['budget_amount'],
    )).toList();
  }

  Future<void> saveSavingsGoal(SavingsGoal goal) async {
    final db = await database;
    await db.insert(
      'savings_goals',
      {
        'id': goal.id,
        'goal_name': goal.goalName,
        'goal_amount': goal.goalAmount,
        'current_amount': goal.currentAmount,
        'reminder_date': goal.reminderDate.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SavingsGoal>> getSavingsGoals() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('savings_goals');
    return maps.map((m) => SavingsGoal(
      id: m['id'],
      goalName: m['goal_name'],
      goalAmount: m['goal_amount'],
      currentAmount: m['current_amount'],
      reminderDate: DateTime.parse(m['reminder_date']),
    )).toList();
  }
}