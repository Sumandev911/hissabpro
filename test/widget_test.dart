import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hissabpro/main.dart';
import 'package:hissabpro/models/expense.dart';
import 'package:hissabpro/models/receivable.dart';
import 'package:hissabpro/models/staff_member.dart';
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
    expect(find.text('Receivables'), findsWidgets);
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

  test('ExpenseProvider correctly sums expense amounts', () {
    final provider = ExpenseProvider();
    final initialTotal = provider.totalExpenses;

    provider.addExpense(Expense(
      id: 'test-1',
      name: 'Test Expense',
      amount: 1000,
      date: DateTime.now(),
    ));
    expect(provider.totalExpenses, equals(initialTotal + 1000));
  });

  test('ReceivableProvider sums only pending receivables', () {
    final provider = ReceivableProvider();
    final initialPending = provider.totalReceivables;

    provider.addReceivable(Receivable(
      id: 'test-r1',
      name: 'Test Person',
      amount: 500,
      dueDate: DateTime.now().add(const Duration(days: 7)),
      status: ReceivableStatus.pending,
    ));
    expect(provider.totalReceivables, equals(initialPending + 500));

    // Mark as paid — total should decrease
    provider.markAsPaid('test-r1');
    expect(provider.totalReceivables, equals(initialPending));
  });

  test('StaffProvider correctly sums salary and advance', () {
    final provider = StaffProvider();
    final initialSalary = provider.totalSalary;
    final initialAdvance = provider.totalAdvance;

    provider.addStaff(StaffMember(
      id: 'test-s1',
      name: 'Test Employee',
      salary: 15000,
      advance: 3000,
      paymentDate: DateTime.now().add(const Duration(days: 30)),
    ));
    expect(provider.totalSalary, equals(initialSalary + 15000));
    expect(provider.totalAdvance, equals(initialAdvance + 3000));
  });
}
