import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../models/receivable.dart';
import '../providers/receivable_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_header.dart';

class ReceivablesScreen extends StatelessWidget {
  const ReceivablesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receivables'),
      ),
      body: Consumer<ReceivableProvider>(
        builder: (context, provider, _) {
          if (provider.receivables.isEmpty) {
            return EmptyState(
              icon: Icons.people_outline,
              title: 'No Receivables Yet',
              subtitle: 'Tap the + button to add someone who owes you money',
              buttonLabel: 'Add Receivable',
              onButtonPressed: () => _showAddReceivableDialog(context),
            );
          }
          return Column(
            children: [
              _buildTotalBanner(provider.totalReceivables),
              const SectionHeader(title: 'People Who Owe You'),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: provider.receivables.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 72),
                  itemBuilder: (context, index) {
                    final receivable = provider.receivables[index];
                    return _buildReceivableItem(
                        context, receivable, provider);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddReceivableDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Receivable'),
      ),
    );
  }

  Widget _buildTotalBanner(double total) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.accentColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Pending',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            '₹${total.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceivableItem(
    BuildContext context,
    Receivable receivable,
    ReceivableProvider provider,
  ) {
    final isPaid = receivable.status == ReceivableStatus.paid;
    final isOverdue = !isPaid &&
        receivable.dueDate.isBefore(DateTime.now());
    final statusColor = isPaid
        ? AppTheme.accentColor
        : isOverdue
            ? AppTheme.errorColor
            : AppTheme.warningColor;
    final statusLabel = isPaid
        ? 'Paid'
        : isOverdue
            ? 'Overdue'
            : 'Pending';

    return Dismissible(
      key: Key(receivable.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppTheme.errorColor,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => provider.deleteReceivable(receivable.id),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppTheme.accentColor.withOpacity(0.12),
          child: Text(
            receivable.name[0].toUpperCase(),
            style: const TextStyle(
              color: AppTheme.accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          receivable.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Text(
          'Due: ${DateFormat('dd MMM yyyy').format(receivable.dueDate)}',
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${receivable.amount.toStringAsFixed(0)}',
              style: TextStyle(
                color: isPaid ? AppTheme.textSecondary : AppTheme.accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                decoration: isPaid ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: isPaid
                  ? null
                  : () => provider.markAsPaid(receivable.id),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Receivable'),
            content: const Text(
                'Are you sure you want to delete this receivable?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorColor),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showAddReceivableDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _AddReceivableSheet(),
    );
  }
}

class _AddReceivableSheet extends StatefulWidget {
  const _AddReceivableSheet();

  @override
  State<_AddReceivableSheet> createState() => _AddReceivableSheetState();
}

class _AddReceivableSheetState extends State<_AddReceivableSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate =
      DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Receivable',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Person Name',
                hintText: 'e.g. Rahul Sharma',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount Owed (₹)',
                hintText: 'e.g. 2000',
                prefixIcon: Icon(Icons.currency_rupee),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Amount is required';
                if (double.tryParse(v) == null) return 'Enter a valid amount';
                if (double.parse(v) <= 0) return 'Amount must be positive';
                return null;
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _pickDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Due Date',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                child: Text(
                  DateFormat('dd MMM yyyy').format(_selectedDate),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Save Receivable'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final receivable = Receivable(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      amount: double.parse(_amountController.text),
      dueDate: _selectedDate,
    );
    context.read<ReceivableProvider>().addReceivable(receivable);
    Navigator.pop(context);
  }
}
