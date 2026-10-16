import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/expense_transaction.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/currency_formatter.dart';
import '../widgets/category_icon.dart';
import '../widgets/brand_logo.dart';
import '../widgets/empty_state.dart';
import '../widgets/mini_bar_chart.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/surface_card.dart';
import '../widgets/transaction_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.onOpenAdd,
    required this.onViewAllTransactions,
    super.key,
  });

  final VoidCallback onOpenAdd;
  final VoidCallback onViewAllTransactions;

  static Future<void> _deleteTransaction(
    BuildContext context,
    AppState state,
    ExpenseTransaction transaction,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete transaction?'),
        content: Text('Remove “${transaction.title}” permanently?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete != true) return;

    try {
      await state.deleteTransaction(transaction.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction deleted')),
      );
    } catch (_) {
      // The shared app banner contains the backend error.
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final monthTransactions = state.currentMonthTransactions;
    final recentTransactions = monthTransactions.take(4).toList();
    final categoryEntries = state.spendingByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final greeting = _greeting();

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth > 680 ? 32.0 : 20.0;
          return ListView(
            padding: EdgeInsets.fromLTRB(
                horizontalPadding, 22, horizontalPadding, 110),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Here is your money overview.',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const BrandLogo(size: 46, padding: 7),
                ],
              ),
              const SizedBox(height: 24),
              _MonthSelector(
                month: state.selectedMonth,
                onChanged: state.setSelectedMonth,
              ),
              const SizedBox(height: 16),
              _BalanceCard(state: state),
              const SizedBox(height: 14),
              Row(
                children: [
                  StatCard(
                    label: 'Income',
                    amount: state.totalIncome,
                    icon: Icons.arrow_downward_rounded,
                  ),
                  const SizedBox(width: 10),
                  StatCard(
                    label: 'Expenses',
                    amount: state.totalExpenses,
                    icon: Icons.arrow_upward_rounded,
                    tint: AppColors.red,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SectionHeader(title: 'Spending trend'),
              const SizedBox(height: 10),
              SurfaceCard(
                child: MiniBarChart(
                  values: state.weeklyExpenses,
                  labels: const [
                    'Week 1',
                    'Week 2',
                    'Week 3',
                    'Week 4',
                    'Week 5'
                  ],
                  highlightIndex: _highestIndex(state.weeklyExpenses),
                ),
              ),
              const SizedBox(height: 28),
              SectionHeader(title: 'Spending by category'),
              const SizedBox(height: 10),
              SurfaceCard(
                child: categoryEntries.isEmpty
                    ? const EmptyState(
                        title: 'No spending yet',
                        message:
                            'Add a transaction to see your category breakdown.',
                      )
                    : Column(
                        children: [
                          for (final entry in categoryEntries.take(4))
                            _CategoryBreakdownRow(
                              category: entry.key,
                              amount: entry.value,
                              percentage: state.totalExpenses == 0
                                  ? 0
                                  : entry.value / state.totalExpenses,
                            ),
                        ],
                      ),
              ),
              const SizedBox(height: 28),
              SectionHeader(
                title: 'Recent transactions',
                actionLabel: 'View all',
                onAction: onViewAllTransactions,
              ),
              const SizedBox(height: 4),
              SurfaceCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: recentTransactions.isEmpty
                    ? const EmptyState(
                        title: 'No transactions this month',
                        message: 'Your new activity will appear here.',
                      )
                    : Column(
                        children: [
                          for (final transaction in recentTransactions)
                            TransactionTile(
                              transaction: transaction,
                              onDelete: () => _deleteTransaction(
                                  context, state, transaction),
                            ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  static String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning, Alex';
    if (hour < 18) return 'Good afternoon, Alex';
    return 'Good evening, Alex';
  }

  static int? _highestIndex(List<double> values) {
    if (values.every((value) => value == 0)) return null;
    var index = 0;
    for (var i = 1; i < values.length; i++) {
      if (values[i] > values[index]) index = i;
    }
    return index;
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({required this.month, required this.onChanged});

  final DateTime month;
  final ValueChanged<DateTime> onChanged;

  Future<void> _pickMonth(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: month,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      helpText: 'Select a month',
    );
    if (selected != null) onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.green),
        const SizedBox(width: 8),
        Text(
          formatMonth(month),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () => _pickMonth(context),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          label: const Text('Change'),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.navyCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Total balance',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
              ),
              const Spacer(),
              Icon(
                Icons.more_horiz_rounded,
                color: Colors.white.withValues(alpha: 0.65),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              formatAppCurrency(context, state.balance),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Icon(Icons.trending_up_rounded,
                  color: AppColors.green, size: 18),
              const SizedBox(width: 6),
              Text(
                'Healthy cash flow this month',
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryBreakdownRow extends StatelessWidget {
  const _CategoryBreakdownRow({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  final ExpenseCategory category;
  final double amount;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          CategoryIcon(category: category, size: 38),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        category.label,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      formatAppCurrency(context, amount),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: percentage.clamp(0.0, 1.0).toDouble(),
                    minHeight: 6,
                    backgroundColor: category.color.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation(category.color),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
