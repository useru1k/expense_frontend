import 'package:flutter/material.dart';

import '../models/category.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/currency_formatter.dart';
import '../widgets/category_icon.dart';
import '../widgets/empty_state.dart';
import '../widgets/mini_bar_chart.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/surface_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final categoryEntries = state.spendingByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final averageWeekly = state.weeklyExpenses.isEmpty
        ? 0.0
        : state.totalExpenses / state.weeklyExpenses.length;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth > 680 ? 32.0 : 20.0;
          return ListView(
            padding: EdgeInsets.fromLTRB(
                horizontalPadding, 22, horizontalPadding, 30),
            children: [
              Text(
                'Analytics',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Understand the patterns behind your spending.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 22),
              SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            formatMonth(state.selectedMonth),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const Icon(Icons.calendar_month_outlined,
                            color: AppColors.green),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        StatCard(
                          label: 'Income',
                          amount: state.totalIncome,
                          icon: Icons.arrow_downward_rounded,
                        ),
                        const SizedBox(width: 10),
                        StatCard(
                          label: 'Spent',
                          amount: state.totalExpenses,
                          icon: Icons.arrow_upward_rounded,
                          tint: AppColors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${formatCurrency(state.balance)} net saved',
                      style: TextStyle(
                        color: state.balance >= 0
                            ? AppColors.green
                            : AppColors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              SectionHeader(title: 'Weekly spending'),
              const SizedBox(height: 10),
              SurfaceCard(
                child: MiniBarChart(
                  values: state.weeklyExpenses,
                  labels: const ['W1', 'W2', 'W3', 'W4', 'W5'],
                  highlightIndex: _highestIndex(state.weeklyExpenses),
                ),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: _InsightCard(
                      label: 'Average / week',
                      value: formatCurrency(averageWeekly),
                      icon: Icons.show_chart_rounded,
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InsightCard(
                      label: 'Budget left',
                      value: formatCurrency(state.remainingBudget),
                      icon: Icons.account_balance_wallet_outlined,
                      color: state.remainingBudget >= 0
                          ? AppColors.green
                          : AppColors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              SectionHeader(title: 'Category breakdown'),
              const SizedBox(height: 10),
              SurfaceCard(
                child: categoryEntries.isEmpty
                    ? const EmptyState(
                        title: 'No data for this month',
                        message: 'Add expenses to unlock your breakdown.',
                      )
                    : Column(
                        children: [
                          for (final entry in categoryEntries)
                            _AnalyticsCategoryRow(
                              category: entry.key,
                              amount: entry.value,
                              total: state.totalExpenses,
                            ),
                        ],
                      ),
              ),
              const SizedBox(height: 26),
              SurfaceCard(
                color: AppColors.navyCard,
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline_rounded,
                        color: AppColors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        categoryEntries.isEmpty
                            ? 'Your insights will appear once you add spending.'
                            : 'Your largest category is ${categoryEntries.first.key.label}. Small, consistent changes there can make the biggest difference.',
                        style:
                            const TextStyle(color: Colors.white, height: 1.4),
                      ),
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

  static int? _highestIndex(List<double> values) {
    if (values.every((value) => value == 0)) return null;
    var index = 0;
    for (var i = 1; i < values.length; i++) {
      if (values[i] > values[index]) index = i;
    }
    return index;
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsCategoryRow extends StatelessWidget {
  const _AnalyticsCategoryRow({
    required this.category,
    required this.amount,
    required this.total,
  });

  final ExpenseCategory category;
  final double amount;
  final double total;

  @override
  Widget build(BuildContext context) {
    final percentage = total == 0 ? 0.0 : amount / total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          CategoryIcon(category: category, size: 40),
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
                      '${(percentage * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: percentage.clamp(0.0, 1.0).toDouble(),
                          minHeight: 6,
                          backgroundColor:
                              category.color.withValues(alpha: 0.12),
                          valueColor: AlwaysStoppedAnimation(category.color),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      formatCurrency(amount),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
