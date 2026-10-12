import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/budget.dart';
import '../models/category.dart';
import '../models/expense_transaction.dart';

class AppState extends ChangeNotifier {
  AppState({DateTime? now})
      : _transactions = MockData.transactions(now: now),
        budgets = MockData.budgets(),
        selectedMonth = DateTime(
          (now ?? DateTime.now()).year,
          (now ?? DateTime.now()).month,
        );

  final List<ExpenseTransaction> _transactions;
  final List<CategoryBudget> budgets;
  DateTime selectedMonth;
  ThemeMode themeMode = ThemeMode.dark;
  String currencySymbol = '\$';

  List<ExpenseTransaction> get transactions => List.unmodifiable(_transactions);

  List<ExpenseTransaction> get currentMonthTransactions {
    return _transactions
        .where(
          (transaction) =>
              transaction.date.year == selectedMonth.year &&
              transaction.date.month == selectedMonth.month,
        )
        .toList(growable: false);
  }

  double get totalIncome => currentMonthTransactions
      .where((transaction) => transaction.isIncome)
      .fold(0, (sum, transaction) => sum + transaction.amount);

  double get totalExpenses => currentMonthTransactions
      .where((transaction) => !transaction.isIncome)
      .fold(0, (sum, transaction) => sum + transaction.amount);

  double get balance => totalIncome - totalExpenses;

  double get totalBudget =>
      budgets.fold(0, (sum, budget) => sum + budget.limit);

  double get remainingBudget => totalBudget - totalExpenses;

  Map<ExpenseCategory, double> get spendingByCategory {
    final result = <ExpenseCategory, double>{};
    for (final transaction in currentMonthTransactions) {
      if (!transaction.isIncome) {
        result.update(
          transaction.category,
          (value) => value + transaction.amount,
          ifAbsent: () => transaction.amount,
        );
      }
    }
    return result;
  }

  List<double> get weeklyExpenses {
    final weeks = List<double>.filled(5, 0);
    for (final transaction in currentMonthTransactions) {
      if (!transaction.isIncome) {
        final weekIndex = ((transaction.date.day - 1) ~/ 7).clamp(0, 4).toInt();
        weeks[weekIndex] += transaction.amount;
      }
    }
    return weeks;
  }

  double spentFor(ExpenseCategory category) {
    return spendingByCategory[category] ?? 0;
  }

  void addTransaction(ExpenseTransaction transaction) {
    _transactions.add(transaction);
    _transactions.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  void setSelectedMonth(DateTime month) {
    selectedMonth = DateTime(month.year, month.month);
    notifyListeners();
  }

  void toggleTheme(bool useDarkTheme) {
    themeMode = useDarkTheme ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({
    required super.notifier,
    required super.child,
    super.key,
  });

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope is missing above this widget.');
    return scope!.notifier!;
  }
}
