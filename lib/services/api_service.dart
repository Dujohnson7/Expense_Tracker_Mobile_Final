import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/budget.dart';
import '../models/savings_goal.dart';
import 'offline_storage.dart';

class ApiService {
  final OfflineStorage offlineStorage = OfflineStorage();

  Future<List<Expense>> getExpenses() async {
    try {
      return await offlineStorage.getExpenses();
    } catch (e) {
      debugPrint('Error fetching expenses: $e');
      return [];
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      await offlineStorage.saveExpense(expense);
    } catch (e) {
      debugPrint('Error adding expense: $e');
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      await offlineStorage.deleteExpense(id);
    } catch (e) {
      debugPrint('Error deleting expense: $e');
    }
  }

  Future<void> setBudget(String month, double budgetAmount) async {
    try {
      await offlineStorage.saveBudget(month, budgetAmount);
    } catch (e) {
      debugPrint('Error setting budget: $e');
    }
  }

  Future<List<Budget>> getBudgets() async {
    try {
      return await offlineStorage.getBudgets();
    } catch (e) {
      debugPrint('Error fetching budgets: $e');
      return [];
    }
  }

  Future<void> addSavingsGoal(SavingsGoal goal) async {
    try {
      await offlineStorage.saveSavingsGoal(goal);
    } catch (e) {
      debugPrint('Error adding savings goal: $e');
    }
  }

  Future<List<SavingsGoal>> getSavingsGoals() async {
    try {
      return await offlineStorage.getSavingsGoals();
    } catch (e) {
      debugPrint('Error fetching savings goals: $e');
      return [];
    }
  }
}