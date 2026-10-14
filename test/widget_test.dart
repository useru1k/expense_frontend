import 'package:expense_tracker/data/mock_data.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/models/currency.dart';
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
    await tester.tap(find.byIcon(Icons.receipt_long_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Keep a clear view of every money move.'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.grid_view_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Total balance'), findsOneWidget);
    await tester.tap(find.text('Add transaction'));
    await tester.pumpAndSettle();
    expect(find.text('How much?'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), '25.50');
    await tester.enterText(find.byType(TextFormField).at(1), 'Test coffee');
    final saveButton = find.widgetWithText(FilledButton, 'Save expense').first;
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('How much?'), findsNothing);
    expect(find.text('Total balance'), findsOneWidget);
    final appState = AppScope.of(tester.element(find.byType(MaterialApp)));
    expect(appState.transactions.any((item) => item.title == 'Test coffee'), isTrue);
    expect(appState.currentMonthTransactions.any((item) => item.title == 'Test coffee'), isTrue);
    await tester.scrollUntilVisible(
      find.text('Test coffee'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Test coffee'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.tune_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Currency'));
    await tester.pumpAndSettle();
    expect(find.text('Choose currency'), findsOneWidget);
    await tester.tap(find.text('Indian Rupee'));
    await tester.pumpAndSettle();
    expect(find.text('Indian Rupee (INR)'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.grid_view_outlined));
    await tester.pumpAndSettle();
    expect(find.textContaining('₹'), findsWidgets);
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

  test('currency selection updates the shared currency symbol', () {
    final state = AppState();

    expect(state.currencySymbol, '\$');
    state.setCurrency(CurrencyOption.inr);
    expect(state.selectedCurrency.code, 'INR');
    expect(state.currencySymbol, '₹');
    state.setCurrency(CurrencyOption.eur);
    expect(state.currencySymbol, '€');

    state.dispose();
  });
}
