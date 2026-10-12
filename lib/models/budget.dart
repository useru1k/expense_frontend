import 'category.dart';

class CategoryBudget {
  const CategoryBudget({
    required this.category,
    required this.limit,
  });

  final ExpenseCategory category;
  final double limit;
}
