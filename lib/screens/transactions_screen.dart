import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/expense_transaction.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/surface_card.dart';
import '../widgets/transaction_tile.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  TransactionType? _typeFilter;
  ExpenseCategory? _categoryFilter;
  DateTime? _dateFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ExpenseTransaction> _filteredTransactions(AppState state) {
    final normalizedQuery = _query.trim().toLowerCase();
    return state.transactions.where((transaction) {
      final matchesQuery = normalizedQuery.isEmpty ||
          transaction.title.toLowerCase().contains(normalizedQuery) ||
          transaction.category.label.toLowerCase().contains(normalizedQuery) ||
          (transaction.notes?.toLowerCase().contains(normalizedQuery) ?? false);
      final matchesType =
          _typeFilter == null || transaction.type == _typeFilter;
      final matchesCategory =
          _categoryFilter == null || transaction.category == _categoryFilter;
      final matchesDate = _dateFilter == null ||
          (transaction.date.year == _dateFilter!.year &&
              transaction.date.month == _dateFilter!.month &&
              transaction.date.day == _dateFilter!.day);
      return matchesQuery && matchesType && matchesCategory && matchesDate;
    }).toList();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateFilter ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (date != null) setState(() => _dateFilter = date);
  }

  void _clearFilters() {
    setState(() {
      _typeFilter = null;
      _categoryFilter = null;
      _dateFilter = null;
    });
  }

  Future<void> _deleteTransaction(
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction deleted')),
      );
    } catch (_) {
      // The shared app banner contains the backend error.
    }
  }

  Future<void> _clearAllTransactions(AppState state) async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Start fresh?'),
        content: const Text(
          'This will permanently remove every expense and income transaction.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Remove all'),
          ),
        ],
      ),
    );
    if (shouldClear != true) return;

    try {
      await state.clearTransactions();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All transactions removed')),
      );
    } catch (_) {
      // The shared app banner contains the backend error.
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final transactions = _filteredTransactions(state);
    final hasFilters =
        _typeFilter != null || _categoryFilter != null || _dateFilter != null;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth > 680 ? 32.0 : 20.0;
          return ListView(
            padding: EdgeInsets.fromLTRB(
                horizontalPadding, 22, horizontalPadding, 30),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Transactions',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                  ),
                  if (state.transactions.isNotEmpty)
                    IconButton(
                      onPressed: () => _clearAllTransactions(state),
                      tooltip: 'Remove all transactions',
                      icon: const Icon(Icons.delete_sweep_outlined),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Keep a clear view of every money move.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 22),
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: 'Search transactions',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FilterDropdown<TransactionType>(
                    label: _typeFilter == null
                        ? 'Type'
                        : _typeFilter == TransactionType.income
                            ? 'Income'
                            : 'Expenses',
                    icon: Icons.swap_vert_rounded,
                    value: _typeFilter,
                    items: const [
                      DropdownMenuItem(
                        value: TransactionType.income,
                        child: Text('Income'),
                      ),
                      DropdownMenuItem(
                        value: TransactionType.expense,
                        child: Text('Expenses'),
                      ),
                    ],
                    onChanged: (value) => setState(() => _typeFilter = value),
                  ),
                  _FilterDropdown<ExpenseCategory>(
                    label: _categoryFilter?.label ?? 'Category',
                    icon: Icons.category_outlined,
                    value: _categoryFilter,
                    items: [
                      for (final category in ExpenseCategory.values)
                        DropdownMenuItem(
                          value: category,
                          child: Text(category.label),
                        ),
                    ],
                    onChanged: (value) =>
                        setState(() => _categoryFilter = value),
                  ),
                  OutlinedButton.icon(
                    onPressed: _selectDate,
                    icon: const Icon(Icons.calendar_today_outlined, size: 16),
                    label: Text(_dateFilter == null ? 'Date' : 'Date selected'),
                  ),
                  if (hasFilters)
                    TextButton(
                      onPressed: _clearFilters,
                      child: const Text('Clear'),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Text(
                    '${transactions.length} ${transactions.length == 1 ? 'transaction' : 'transactions'}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const Spacer(),
                  if (hasFilters)
                    Text(
                      'Filtered results',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.green,
                          ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              SurfaceCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: transactions.isEmpty
                    ? EmptyState(
                        title: hasFilters
                            ? 'No matches found'
                            : 'No transactions yet',
                        message: hasFilters
                            ? 'Try changing your search or filters.'
                            : 'Add your first expense or income to get started.',
                        icon: hasFilters
                            ? Icons.search_off_rounded
                            : Icons.receipt_long_outlined,
                      )
                    : Column(
                        children: [
                          for (final transaction in transactions)
                            TransactionTile(
                              transaction: transaction,
                              onDelete: () =>
                                  _deleteTransaction(state, transaction),
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
}

class _FilterDropdown<T> extends StatelessWidget {
  const _FilterDropdown({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.only(left: 12, right: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 7),
          DropdownButton<T>(
            value: value,
            hint: Text(label),
            underline: const SizedBox.shrink(),
            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
            items: items,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
