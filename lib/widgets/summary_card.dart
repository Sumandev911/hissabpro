import 'package:flutter/material.dart';
import '../app_theme.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color? color;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppTheme.primaryColor;
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [cardColor, cardColor.withOpacity(0.8)],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(icon, color: Colors.white70, size: 22),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
