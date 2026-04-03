import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../models/staff_member.dart';
import '../providers/staff_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_header.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff'),
      ),
      body: Consumer<StaffProvider>(
        builder: (context, provider, _) {
          if (provider.staff.isEmpty) {
            return EmptyState(
              icon: Icons.badge_outlined,
              title: 'No Staff Added',
              subtitle: 'Tap the + button to add your first employee',
              buttonLabel: 'Add Staff',
              onButtonPressed: () => _showAddStaffDialog(context),
            );
          }
          return Column(
            children: [
              _buildSalaryBanner(provider),
              const SectionHeader(title: 'Employees'),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: provider.staff.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 72),
                  itemBuilder: (context, index) {
                    final member = provider.staff[index];
                    return _buildStaffItem(context, member, provider);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddStaffDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Staff'),
      ),
    );
  }

  Widget _buildSalaryBanner(StaffProvider provider) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF8E85FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Salary',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${provider.totalSalary.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.white30,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Total Advance',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${provider.totalAdvance.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffItem(
    BuildContext context,
    StaffMember member,
    StaffProvider provider,
  ) {
    return Dismissible(
      key: Key(member.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppTheme.errorColor,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => provider.deleteStaff(member.id),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF6C63FF).withOpacity(0.15),
          child: Text(
            member.name[0].toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF6C63FF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          member.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Text(
          'Pay date: ${DateFormat('dd MMM').format(member.paymentDate)}',
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Salary: ₹${member.salary.toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppTheme.textPrimary,
              ),
            ),
            if (member.advance > 0)
              Text(
                'Advance: ₹${member.advance.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.warningColor,
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
            title: const Text('Remove Staff'),
            content:
                const Text('Are you sure you want to remove this employee?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorColor),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Remove'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showAddStaffDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _AddStaffSheet(),
    );
  }
}

class _AddStaffSheet extends StatefulWidget {
  const _AddStaffSheet();

  @override
  State<_AddStaffSheet> createState() => _AddStaffSheetState();
}

class _AddStaffSheetState extends State<_AddStaffSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _salaryController = TextEditingController();
  final _advanceController = TextEditingController();
  DateTime _selectedDate =
      DateTime.now().add(const Duration(days: 30));

  @override
  void dispose() {
    _nameController.dispose();
    _salaryController.dispose();
    _advanceController.dispose();
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Staff',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Employee Name',
                  hintText: 'e.g. Ramesh Yadav',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(
                  labelText: 'Monthly Salary (₹)',
                  hintText: 'e.g. 12000',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Salary is required';
                  }
                  if (double.tryParse(v) == null) {
                    return 'Enter a valid amount';
                  }
                  if (double.parse(v) <= 0) return 'Amount must be positive';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _advanceController,
                decoration: const InputDecoration(
                  labelText: 'Advance Given (₹)',
                  hintText: 'e.g. 1000 (optional)',
                  prefixIcon: Icon(Icons.money_outlined),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v != null && v.isNotEmpty) {
                    if (double.tryParse(v) == null) {
                      return 'Enter a valid amount';
                    }
                    if (double.parse(v) < 0) return 'Amount cannot be negative';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _pickDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Payment Date',
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
                  child: const Text('Save Staff'),
                ),
              ),
            ],
          ),
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
    final member = StaffMember(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      salary: double.parse(_salaryController.text),
      advance: _advanceController.text.isNotEmpty
          ? double.parse(_advanceController.text)
          : 0.0,
      paymentDate: _selectedDate,
    );
    context.read<StaffProvider>().addStaff(member);
    Navigator.pop(context);
  }
}
