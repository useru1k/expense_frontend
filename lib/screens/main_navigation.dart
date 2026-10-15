import 'package:flutter/material.dart';

import 'add_transaction_screen.dart';
import 'analytics_screen.dart';
import 'budgets_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import 'transactions_screen.dart';
import '../state/app_state.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  Future<void> _openAddTransaction() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const AddTransactionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final pages = [
      HomeScreen(
        onOpenAdd: _openAddTransaction,
        onViewAllTransactions: () => setState(() => _selectedIndex = 1),
      ),
      const TransactionsScreen(),
      const AnalyticsScreen(),
      const BudgetsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: Column(
        children: [
          if (appState.isLoading) const LinearProgressIndicator(minHeight: 2),
          if (appState.errorMessage != null)
            MaterialBanner(
              content: Text(appState.errorMessage!),
              actions: [
                TextButton(
                  onPressed: appState.loadFromApi,
                  child: const Text('Retry'),
                ),
              ],
            ),
          Expanded(
            child: IndexedStack(index: _selectedIndex, children: pages),
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _openAddTransaction,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add transaction'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.track_changes_outlined),
            selectedIcon: Icon(Icons.track_changes_rounded),
            label: 'Budgets',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
