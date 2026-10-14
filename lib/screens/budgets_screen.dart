import 'package:flutter/material.dart';

import '../models/budget.dart';
import '../models/category.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/currency_formatter.dart';
import '../widgets/category_icon.dart';
import '../widgets/section_header.dart';
import '../widgets/surface_card.dart';

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final overallProgress = state.totalBudget == 0
        ? 0.0
        : (state.totalExpenses / state.totalBudget).clamp(0.0, 1.0).toDouble();

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth > 680 ? 32.0 : 20.0;
          return ListView(
            padding: EdgeInsets.fromLTRB(
                horizontalPadding, 22, horizontalPadding, 30),
            children: [
              Text(
                'Budgets',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Give every dollar a job this month.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 22),
              SurfaceCard(
                color: AppColors.navyCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Monthly overview',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.78)),
                          ),
                        ),
                        Text(
                          formatMonth(state.selectedMonth),
                          style: const TextStyle(
                            color: AppColors.green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            formatAppCurrency(context, state.totalExpenses),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          'of ${formatAppCurrency(context, state.totalBudget)}',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: overallProgress,
                        minHeight: 10,
                        backgroundColor: Colors.white.withValues(alpha: 0.12),
                        valueColor: AlwaysStoppedAnimation(
                          state.totalExpenses > state.totalBudget
                              ? AppColors.red
                              : AppColors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.remainingBudget >= 0
                          ? '${formatAppCurrency(context, state.remainingBudget)} remaining across categories'
                          : '${formatAppCurrency(context, state.remainingBudget.abs())} over your category budgets',
                      style: TextStyle(
                        color: state.remainingBudget >= 0
                            ? AppColors.green
                            : AppColors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SectionHeader(title: 'Category budgets'),
              const SizedBox(height: 10),
              for (final budget in state.budgets)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _BudgetCard(budget: budget, state: state),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({required this.budget, required this.state});

  final CategoryBudget budget;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final spent = state.spentFor(budget.category);
    final progress = (spent / budget.limit).clamp(0.0, 1.0).toDouble();
    final isOver = spent > budget.limit;
    final isNearLimit = spent >= budget.limit * 0.8;
    final color = isOver
        ? AppColors.red
        : isNearLimit
            ? Colors.orangeAccent
            : budget.category.color;

    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              CategoryIcon(category: budget.category, size: 42),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(budget.category.label,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(
                      isOver
                          ? 'Over budget'
                          : isNearLimit
                              ? 'Approaching limit'
                              : 'On track',
                      style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Text(
                '${formatAppCurrency(context, spent)} / ${formatAppCurrency(context, budget.limit)}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: color.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: 7),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              isOver
                  ? '${formatAppCurrency(context, spent - budget.limit)} over'
                  : '${formatAppCurrency(context, budget.limit - spent)} left',
              style:
                  Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
