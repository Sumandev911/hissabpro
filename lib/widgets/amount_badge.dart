import 'package:flutter/material.dart';
import '../app_theme.dart';

class AmountBadge extends StatelessWidget {
  final double amount;
  final bool isExpense;

  const AmountBadge({
    super.key,
    required this.amount,
    this.isExpense = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = isExpense ? AppTheme.errorColor : AppTheme.accentColor;
    final prefix = isExpense ? '- ' : '+ ';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$prefix₹${amount.toStringAsFixed(0)}',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
