class Expense {
  final String id;
  final String name;
  final double amount;
  final DateTime date;
  final String category;

  Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    this.category = 'General',
  });

  Expense copyWith({
    String? id,
    String? name,
    double? amount,
    DateTime? date,
    String? category,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }
}
