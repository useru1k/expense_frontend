import '../models/budget.dart';
import '../models/category.dart';
import '../models/expense_transaction.dart';

class MockData {
  static List<ExpenseTransaction> transactions({DateTime? now}) {
    final reference = now ?? DateTime.now();
    final year = reference.year;
    final month = reference.month;

    return [
      ExpenseTransaction(
        id: 'salary',
        title: 'Salary deposit',
        amount: 5800,
        date: DateTime(year, month, 1),
        type: TransactionType.income,
        category: ExpenseCategory.other,
        notes: 'Monthly salary',
      ),
      ExpenseTransaction(
        id: 'rent',
        title: 'Apartment rent',
        amount: 1450,
        date: DateTime(year, month, 2),
        type: TransactionType.expense,
        category: ExpenseCategory.housing,
      ),
      ExpenseTransaction(
        id: 'groceries-1',
        title: 'Whole Foods Market',
        amount: 126.42,
        date: DateTime(year, month, 3),
        type: TransactionType.expense,
        category: ExpenseCategory.groceries,
      ),
      ExpenseTransaction(
        id: 'train-pass',
        title: 'City transit pass',
        amount: 96,
        date: DateTime(year, month, 4),
        type: TransactionType.expense,
        category: ExpenseCategory.transport,
      ),
      ExpenseTransaction(
        id: 'freelance',
        title: 'Freelance project',
        amount: 750,
        date: DateTime(year, month, 5),
        type: TransactionType.income,
        category: ExpenseCategory.other,
      ),
      ExpenseTransaction(
        id: 'streaming',
        title: 'Streaming bundle',
        amount: 32.99,
        date: DateTime(year, month, 6),
        type: TransactionType.expense,
        category: ExpenseCategory.subscriptions,
      ),
      ExpenseTransaction(
        id: 'brunch',
        title: 'Sunday brunch',
        amount: 58.75,
        date: DateTime(year, month, 7),
        type: TransactionType.expense,
        category: ExpenseCategory.dining,
      ),
      ExpenseTransaction(
        id: 'pharmacy',
        title: 'Pharmacy',
        amount: 42.8,
        date: DateTime(year, month, 8),
        type: TransactionType.expense,
        category: ExpenseCategory.health,
      ),
      ExpenseTransaction(
        id: 'groceries-2',
        title: 'Local market',
        amount: 84.2,
        date: DateTime(year, month, 9),
        type: TransactionType.expense,
        category: ExpenseCategory.groceries,
      ),
      ExpenseTransaction(
        id: 'sneakers',
        title: 'Running shoes',
        amount: 118.5,
        date: DateTime(year, month, 10),
        type: TransactionType.expense,
        category: ExpenseCategory.shopping,
      ),
      ExpenseTransaction(
        id: 'coffee',
        title: 'Coffee & pastry',
        amount: 14.5,
        date: DateTime(year, month, 11),
        type: TransactionType.expense,
        category: ExpenseCategory.dining,
      ),
      ExpenseTransaction(
        id: 'concert',
        title: 'Concert tickets',
        amount: 160,
        date: DateTime(year, month, 12),
        type: TransactionType.expense,
        category: ExpenseCategory.entertainment,
      ),
    ]..sort((a, b) => b.date.compareTo(a.date));
  }

  static List<CategoryBudget> budgets() {
    return const [
      CategoryBudget(category: ExpenseCategory.housing, limit: 1800),
      CategoryBudget(category: ExpenseCategory.groceries, limit: 550),
      CategoryBudget(category: ExpenseCategory.dining, limit: 280),
      CategoryBudget(category: ExpenseCategory.transport, limit: 180),
      CategoryBudget(category: ExpenseCategory.shopping, limit: 300),
      CategoryBudget(category: ExpenseCategory.entertainment, limit: 240),
    ];
  }
}
