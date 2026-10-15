import 'category.dart';

class CategoryBudget {
  const CategoryBudget({
    required this.category,
    required this.limit,
    this.id,
  });

  final String? id;
  final ExpenseCategory category;
  final double limit;

  factory CategoryBudget.fromJson(Map<String, dynamic> json) {
    final rawLimit = json['limit'];
    return CategoryBudget(
      id: json['id'] as String?,
      category: expenseCategoryFromApiValue(json['category'] as String),
      limit: rawLimit is num
          ? rawLimit.toDouble()
          : double.parse(rawLimit.toString()),
    );
  }
}
