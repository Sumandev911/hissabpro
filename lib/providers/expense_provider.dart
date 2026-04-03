import 'package:flutter/foundation.dart';
import '../models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  final List<Expense> _expenses = [
    Expense(
      id: '1',
      name: 'Stock Purchase',
      amount: 5000,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Stock',
    ),
    Expense(
      id: '2',
      name: 'Electricity Bill',
      amount: 1200,
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: 'Utilities',
    ),
    Expense(
      id: '3',
      name: 'Rent',
      amount: 8000,
      date: DateTime.now().subtract(const Duration(days: 7)),
      category: 'Rent',
    ),
  ];

  List<Expense> get expenses => List.unmodifiable(_expenses);

  double get totalExpenses =>
      _expenses.fold(0.0, (sum, e) => sum + e.amount);

  void addExpense(Expense expense) {
    _expenses.insert(0, expense);
    notifyListeners();
  }

  void updateExpense(Expense expense) {
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
      notifyListeners();
    }
  }

  void deleteExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
