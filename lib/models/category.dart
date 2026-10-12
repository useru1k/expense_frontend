import 'package:flutter/material.dart';

enum ExpenseCategory {
  housing,
  groceries,
  dining,
  transport,
  shopping,
  health,
  subscriptions,
  entertainment,
  other,
}

extension ExpenseCategoryDetails on ExpenseCategory {
  String get label {
    switch (this) {
      case ExpenseCategory.housing:
        return 'Housing';
      case ExpenseCategory.groceries:
        return 'Groceries';
      case ExpenseCategory.dining:
        return 'Dining';
      case ExpenseCategory.transport:
        return 'Transport';
      case ExpenseCategory.shopping:
        return 'Shopping';
      case ExpenseCategory.health:
        return 'Health';
      case ExpenseCategory.subscriptions:
        return 'Subscriptions';
      case ExpenseCategory.entertainment:
        return 'Entertainment';
      case ExpenseCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseCategory.housing:
        return Icons.home_outlined;
      case ExpenseCategory.groceries:
        return Icons.shopping_basket_outlined;
      case ExpenseCategory.dining:
        return Icons.restaurant_outlined;
      case ExpenseCategory.transport:
        return Icons.directions_car_outlined;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag_outlined;
      case ExpenseCategory.health:
        return Icons.favorite_border;
      case ExpenseCategory.subscriptions:
        return Icons.autorenew_rounded;
      case ExpenseCategory.entertainment:
        return Icons.movie_outlined;
      case ExpenseCategory.other:
        return Icons.more_horiz_rounded;
    }
  }

  Color get color {
    switch (this) {
      case ExpenseCategory.housing:
        return const Color(0xFF8B9CFF);
      case ExpenseCategory.groceries:
        return const Color(0xFF6EE7B7);
      case ExpenseCategory.dining:
        return const Color(0xFFFFB86B);
      case ExpenseCategory.transport:
        return const Color(0xFF65C7F7);
      case ExpenseCategory.shopping:
        return const Color(0xFFF08BD8);
      case ExpenseCategory.health:
        return const Color(0xFFFF7C9B);
      case ExpenseCategory.subscriptions:
        return const Color(0xFFC5A3FF);
      case ExpenseCategory.entertainment:
        return const Color(0xFFFFD166);
      case ExpenseCategory.other:
        return const Color(0xFF9AA6B8);
    }
  }
}
