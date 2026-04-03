import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hissabpro/main.dart';
import 'package:hissabpro/providers/expense_provider.dart';
import 'package:hissabpro/providers/receivable_provider.dart';
import 'package:hissabpro/providers/staff_provider.dart';

void main() {
  testWidgets('App starts and shows bottom navigation bar',
      (WidgetTester tester) async {
    await tester.pumpWidget(const HisaabProApp());
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Expenses'), findsOneWidget);
    expect(find.text('Receivables'), findsOneWidget);
    expect(find.text('Staff'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('Home screen shows summary cards', (WidgetTester tester) async {
    await tester.pumpWidget(const HisaabProApp());
    await tester.pumpAndSettle();

    expect(find.text('Total Expenses'), findsOneWidget);
    expect(find.text('Receivables'), findsWidgets);
  });

  testWidgets('Navigation to Expenses screen works',
      (WidgetTester tester) async {
    await tester.pumpWidget(const HisaabProApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Expenses'));
    await tester.pumpAndSettle();

    expect(find.text('Add Expense'), findsWidgets);
  });

  testWidgets('ExpenseProvider tracks total expenses correctly', (tester) async {
    final provider = ExpenseProvider();
    // Initial expenses from sample data
    expect(provider.totalExpenses, greaterThan(0));
  });

  testWidgets('ReceivableProvider tracks pending receivables correctly',
      (tester) async {
    final provider = ReceivableProvider();
    expect(provider.totalReceivables, greaterThan(0));
  });

  testWidgets('StaffProvider tracks salary correctly', (tester) async {
    final provider = StaffProvider();
    expect(provider.totalSalary, greaterThan(0));
  });
}
