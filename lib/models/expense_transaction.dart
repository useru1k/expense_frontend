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

  factory ExpenseTransaction.fromJson(Map<String, dynamic> json) {
    final rawAmount = json['amount'];
    return ExpenseTransaction(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: rawAmount is num
          ? rawAmount.toDouble()
          : double.parse(rawAmount.toString()),
      date: DateTime.parse(json['date'] as String),
      type: TransactionType.values.byName(json['type'] as String),
      category: expenseCategoryFromApiValue(json['category'] as String),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toApiJson() {
    return {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String().split('T').first,
      'type': type.name,
      'category': category.name,
      'notes': notes,
    };
  }

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
