enum ReceivableStatus { pending, paid }

class Receivable {
  final String id;
  final String name;
  final double amount;
  final DateTime dueDate;
  final ReceivableStatus status;

  Receivable({
    required this.id,
    required this.name,
    required this.amount,
    required this.dueDate,
    this.status = ReceivableStatus.pending,
  });

  Receivable copyWith({
    String? id,
    String? name,
    double? amount,
    DateTime? dueDate,
    ReceivableStatus? status,
  }) {
    return Receivable(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
    );
  }
}
