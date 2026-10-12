import 'package:flutter/material.dart';

import '../models/category.dart';

class CategoryIcon extends StatelessWidget {
  const CategoryIcon({
    required this.category,
    super.key,
    this.size = 44,
  });

  final ExpenseCategory category;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: category.color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: Icon(category.icon, color: category.color, size: size * 0.5),
    );
  }
}
