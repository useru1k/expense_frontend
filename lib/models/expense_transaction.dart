import 'category.dart';

enum TransactionType { income, expense }

class ExpenseTransaction {
  const ExpenseTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    this.notes,
  });

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final ExpenseCategory category;
  final String? notes;

  bool get isIncome => type == TransactionType.income;

  ExpenseTransaction copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    TransactionType? type,
    ExpenseCategory? category,
    String? notes,
  }) {
    return ExpenseTransaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      category: category ?? this.category,
      notes: notes ?? this.notes,
    );
  }
}
