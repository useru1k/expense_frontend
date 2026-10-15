import 'package:flutter/material.dart';

import '../models/budget.dart';
import '../models/category.dart';
import '../models/currency.dart';
import '../models/expense_transaction.dart';
import '../services/api_client.dart';

class AppState extends ChangeNotifier {
  AppState({DateTime? now, ApiClient? apiClient})
      : _apiClient = apiClient,
        _transactions = <ExpenseTransaction>[],
        _budgets = <CategoryBudget>[],
        selectedMonth = DateTime(
          (now ?? DateTime.now()).year,
          (now ?? DateTime.now()).month,
        );

  final ApiClient? _apiClient;
  final List<ExpenseTransaction> _transactions;
  final List<CategoryBudget> _budgets;
  bool _isLoading = false;
  String? _errorMessage;
  DateTime selectedMonth;
  ThemeMode themeMode = ThemeMode.dark;
  CurrencyOption selectedCurrency = CurrencyOption.usd;

  String get currencySymbol => selectedCurrency.symbol;

  List<ExpenseTransaction> get transactions => List.unmodifiable(_transactions);

  List<CategoryBudget> get budgets => List.unmodifiable(_budgets);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

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

  Future<void> loadFromApi() async {
    final apiClient = _apiClient;
    if (apiClient == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final results = await Future.wait<dynamic>([
        apiClient.fetchTransactions(),
        apiClient.fetchBudgets(),
      ]);
      _transactions
        ..clear()
        ..addAll(results[0] as List<ExpenseTransaction>)
        ..sort((a, b) => b.date.compareTo(a.date));
      _budgets
        ..clear()
        ..addAll(results[1] as List<CategoryBudget>);
    } catch (error) {
      _transactions.clear();
      _budgets.clear();
      _errorMessage = _friendlyError(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(ExpenseTransaction transaction) async {
    try {
      final saved = _apiClient == null
          ? transaction
          : await _apiClient.createTransaction(transaction);
      _transactions
        ..removeWhere((item) => item.id == saved.id)
        ..add(saved)
        ..sort((a, b) => b.date.compareTo(a.date));
      _errorMessage = null;
      notifyListeners();
    } catch (error) {
      _errorMessage = _friendlyError(error);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _apiClient?.deleteTransaction(transactionId);
      _transactions.removeWhere((item) => item.id == transactionId);
      _errorMessage = null;
      notifyListeners();
    } catch (error) {
      _errorMessage = _friendlyError(error);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> clearTransactions() async {
    try {
      await _apiClient?.deleteAllTransactions();
      _transactions.clear();
      _errorMessage = null;
      notifyListeners();
    } catch (error) {
      _errorMessage = _friendlyError(error);
      notifyListeners();
      rethrow;
    }
  }

  void setSelectedMonth(DateTime month) {
    selectedMonth = DateTime(month.year, month.month);
    notifyListeners();
  }

  void toggleTheme(bool useDarkTheme) {
    themeMode = useDarkTheme ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setCurrency(CurrencyOption currency) {
    selectedCurrency = currency;
    notifyListeners();
  }

  @override
  void dispose() {
    _apiClient?.dispose();
    super.dispose();
  }

  String _friendlyError(Object error) {
    if (error is ApiException) return error.message;
    return 'Could not connect to the backend. Check that FastAPI is running.';
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
