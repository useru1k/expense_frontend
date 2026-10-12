import 'package:expense_tracker/data/mock_data.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/models/expense_transaction.dart';
import 'package:expense_tracker/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mock data totals are calculated from the transaction list', () {
    final reference = DateTime(2026, 10, 11);
    final state = AppState(now: reference);
    final transactions = MockData.transactions(now: reference);
    final income = transactions
        .where((transaction) => transaction.isIncome)
        .fold<double>(0, (sum, transaction) => sum + transaction.amount);
    final expenses = transactions
        .where((transaction) => !transaction.isIncome)
        .fold<double>(0, (sum, transaction) => sum + transaction.amount);

    expect(income, 6550);
    expect(expenses, closeTo(2184.16, 0.001));
    expect(state.totalIncome, greaterThan(0));
    state.dispose();
  });

  testWidgets('main destinations and add transaction flow are reachable',
      (tester) async {
    await tester.pumpWidget(const ExpenseTrackerApp());
    await tester.pumpAndSettle();

    expect(find.text('Total balance'), findsOneWidget);
    await tester.tap(find.text('Transactions'));
    await tester.pumpAndSettle();
    expect(find.text('Keep a clear view of every money move.'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add transaction'));
    await tester.pumpAndSettle();
    expect(find.text('How much?'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), '25.50');
    await tester.enterText(find.byType(TextFormField).at(1), 'Test coffee');
    await tester.tap(find.text('Save expense'));
    await tester.pumpAndSettle();

    expect(find.text('Test coffee'), findsOneWidget);
  });

  test('transaction model exposes income state', () {
    final transaction = ExpenseTransaction(
      id: 'test',
      title: 'Payday',
      amount: 100,
      date: DateTime(2026, 10, 1),
      type: TransactionType.income,
      category:
          MockData.transactions(now: DateTime(2026, 10, 11)).first.category,
    );

    expect(transaction.isIncome, isTrue);
  });
}
