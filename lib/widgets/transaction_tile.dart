import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/expense_transaction.dart';
import '../utils/currency_formatter.dart';
import 'category_icon.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    required this.transaction,
    this.onDelete,
    super.key,
  });

  final ExpenseTransaction transaction;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final amountColor = transaction.isIncome
        ? const Color(0xFF6EE7B7)
        : Theme.of(context).textTheme.bodyLarge?.color;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          CategoryIcon(category: transaction.category, size: 46),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '${transaction.category.label}  •  ${formatDate(transaction.date)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${transaction.isIncome ? '+' : '-'}${formatAppCurrency(context, transaction.amount)}',
            style: TextStyle(
              color: amountColor,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          if (onDelete != null) ...[
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              tooltip: 'Transaction actions',
              padding: EdgeInsets.zero,
              onSelected: (value) {
                if (value == 'delete') onDelete!();
              },
              itemBuilder: (context) => const [
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Delete transaction'),
                ),
              ],
              icon: const Icon(Icons.more_vert_rounded, size: 20),
            ),
          ],
        ],
      ),
    );
  }
}
