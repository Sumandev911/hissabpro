import 'package:flutter/foundation.dart';
import '../models/receivable.dart';

class ReceivableProvider extends ChangeNotifier {
  final List<Receivable> _receivables = [
    Receivable(
      id: '1',
      name: 'Rahul Sharma',
      amount: 2000,
      dueDate: DateTime.now().add(const Duration(days: 5)),
      status: ReceivableStatus.pending,
    ),
    Receivable(
      id: '2',
      name: 'Priya Patel',
      amount: 3500,
      dueDate: DateTime.now().add(const Duration(days: 10)),
      status: ReceivableStatus.pending,
    ),
    Receivable(
      id: '3',
      name: 'Suresh Kumar',
      amount: 1500,
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      status: ReceivableStatus.paid,
    ),
  ];

  List<Receivable> get receivables => List.unmodifiable(_receivables);

  double get totalReceivables => _receivables
      .where((r) => r.status == ReceivableStatus.pending)
      .fold(0.0, (sum, r) => sum + r.amount);

  void addReceivable(Receivable receivable) {
    _receivables.insert(0, receivable);
    notifyListeners();
  }

  void updateReceivable(Receivable receivable) {
    final index = _receivables.indexWhere((r) => r.id == receivable.id);
    if (index != -1) {
      _receivables[index] = receivable;
      notifyListeners();
    }
  }

  void markAsPaid(String id) {
    final index = _receivables.indexWhere((r) => r.id == id);
    if (index != -1) {
      _receivables[index] =
          _receivables[index].copyWith(status: ReceivableStatus.paid);
      notifyListeners();
    }
  }

  void deleteReceivable(String id) {
    _receivables.removeWhere((r) => r.id == id);
    notifyListeners();
  }
}
