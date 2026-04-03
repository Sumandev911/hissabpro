import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../providers/expense_provider.dart';
import '../providers/receivable_provider.dart';
import '../models/expense.dart';
import '../models/receivable.dart';
import '../widgets/summary_card.dart';
import '../widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HisaabPro'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.3),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummarySection(context),
              _buildRecentTransactions(context),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    return Consumer2<ExpenseProvider, ReceivableProvider>(
      builder: (context, expenseProvider, receivableProvider, _) {
        final totalExpenses = expenseProvider.totalExpenses;
        final totalReceivables = receivableProvider.totalReceivables;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Total Expenses',
                      amount: '₹${_formatAmount(totalExpenses)}',
                      icon: Icons.arrow_downward,
                      color: AppTheme.errorColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      title: 'Receivables',
                      amount: '₹${_formatAmount(totalReceivables)}',
                      icon: Icons.arrow_upward,
                      color: AppTheme.accentColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    return Consumer2<ExpenseProvider, ReceivableProvider>(
      builder: (context, expenseProvider, receivableProvider, _) {
        final transactions = _mergeTransactions(
          expenseProvider.expenses,
          receivableProvider.receivables,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Recent Transactions'),
            if (transactions.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'No transactions yet',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length > 10 ? 10 : transactions.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 72),
                itemBuilder: (context, index) {
                  return _buildTransactionItem(transactions[index]);
                },
              ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> _mergeTransactions(
    List<Expense> expenses,
    List<Receivable> receivables,
  ) {
    final transactions = <Map<String, dynamic>>[];

    for (final expense in expenses) {
      transactions.add({
        'type': 'expense',
        'name': expense.name,
        'amount': expense.amount,
        'date': expense.date,
        'category': expense.category,
      });
    }

    for (final receivable in receivables) {
      transactions.add({
        'type': 'receivable',
        'name': receivable.name,
        'amount': receivable.amount,
        'date': receivable.dueDate,
        'status': receivable.status,
      });
    }

    transactions.sort((a, b) =>
        (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    return transactions;
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final isExpense = transaction['type'] == 'expense';
    final color = isExpense ? AppTheme.errorColor : AppTheme.accentColor;
    final icon = isExpense ? Icons.shopping_bag_outlined : Icons.person_outline;
    final amountPrefix = isExpense ? '- ' : '+ ';
    final dateStr =
        DateFormat('dd MMM').format(transaction['date'] as DateTime);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.12),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        transaction['name'] as String,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: AppTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        isExpense
            ? (transaction['category'] as String)
            : 'Receivable',
        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$amountPrefix₹${(transaction['amount'] as double).toStringAsFixed(0)}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          Text(
            dateStr,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
