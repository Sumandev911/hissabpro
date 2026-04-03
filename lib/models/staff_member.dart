class StaffMember {
  final String id;
  final String name;
  final double salary;
  final double advance;
  final DateTime paymentDate;

  StaffMember({
    required this.id,
    required this.name,
    required this.salary,
    this.advance = 0.0,
    required this.paymentDate,
  });

  StaffMember copyWith({
    String? id,
    String? name,
    double? salary,
    double? advance,
    DateTime? paymentDate,
  }) {
    return StaffMember(
      id: id ?? this.id,
      name: name ?? this.name,
      salary: salary ?? this.salary,
      advance: advance ?? this.advance,
      paymentDate: paymentDate ?? this.paymentDate,
    );
  }
}
